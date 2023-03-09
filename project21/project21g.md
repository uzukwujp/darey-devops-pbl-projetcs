#### Step 5 Prepare the `etcd` database for encryption at rest.

Kubernetes uses [`etcd` (A distributed key value store)](https://etcd.io) to store variety of data which includes the cluster state, application configurations, and secrets. By default, the data that is being persisted to the disk is not encrypted. Any attacker that is able to gain access to this database can exploit the cluster since the data is stored in plain text. Hence, it is a security risk for Kubernetes that needs to be addressed. 

To mitigate this risk, we must prepare to encrypt `etcd` at rest. "At rest" means data that is stored and persists on a disk. Anytime you hear "in-flight" or "in transit" refers to data that is being transferred over the network. "In-flight" encryption is done through TLS.


**Generate the encryption key and encode it using `base64`**

```
ETCD_ENCRYPTION_KEY=$(head -c 64 /dev/urandom | base64) 
```

See the output that will be generated when called. Yours will be a different random string.

`echo $ETCD_ENCRYPTION_KEY`

**OUTPUT:**

```
OuxSvV5XUQVid4fNNbeyFEDTUPr1yozZPQ+E6Eqj80m1FSVDB6jOHt9miD/7kMdJIvVshlMgxY80wFajlqItug===$
```

** Create an `encryption-config.yaml` file as [documented officially by kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#understanding-the-encryption-at-rest-configuration)


```
cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ETCD_ENCRYPTION_KEY}
      - identity: {}
EOF
```

Send the encryption file to the **Controller nodes** using `scp` and a `for` loop.

### Bootstrap `etcd` cluster

**TIPS:** Use a terminal multi-plexer like [multi-tabbed putty](https://youtu.be/0c1cWrMnZlc) or [tmux](https://youtu.be/Yl7NFenTgIo) to work with multiple terminal sessions simultaneously. It will make your life easier, especially when you need to work on multiple nodes and run the same command across all nodes. Imagine repeating the same commands on 10 different nodes, and you don not intend to start automating with a configuration management tool like Ansible **yet**.

The primary purpose of the `etcd` component is to store the state of the cluster. This is because Kubernetes itself is stateless. Therefore, all its stateful data will persist in `etcd`. Since Kubernetes is a distributed system - it needs a distributed storage to keep persistent data in it. `etcd` is a highly-available key value store that fits the purpose. All K8s cluster configurations are stored in a form of key value pairs in `etcd`, it also stores the **actual** and **desired** states of the cluster. `etcd` cluster is intelligent enough to _watch_ for changes made on one instance and almost instantly replicate those changes to the rest of the instances, so all of them will be always reconciled. 

**NOTE:** Don not just copy and paste the commands, ensure that you go through each and understand exactly what they will do on your servers. Use tools like `tmux` to make it easy to run commands on multiple terminal screens at once.

1. SSH into the controller server 

- Master-1
```
  master_1_ip=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=${NAME}-master-0" \
  --output text --query 'Reservations[].Instances[].PublicIpAddress')
  ssh -i k8s-cluster-from-ground-up.id_rsa ubuntu@${master_1_ip}
```

- Master-2
```
  master_2_ip=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=${NAME}-master-1" \
  --output text --query 'Reservations[].Instances[].PublicIpAddress')
  ssh -i k8s-cluster-from-ground-up.id_rsa ubuntu@${master_2_ip}
```

- Master-3
```
  master_3_ip=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=${NAME}-master-2" \
  --output text --query 'Reservations[].Instances[].PublicIpAddress')
  ssh -i k8s-cluster-from-ground-up.id_rsa ubuntu@${master_3_ip}
```

You should have a a similar pane like below. You should be able to see all the files that have been sent to the nodes. 

![](https://dareyio-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project21/Master-Nodes-Terminal.png)

2. Download and install **etcd**

```
  wget -q --show-progress --https-only --timestamping \
  "https://github.com/etcd-io/etcd/releases/download/v3.4.15/etcd-v3.4.15-linux-amd64.tar.gz"
```
3. Extract and install the etcd server and the etcdctl command line utility:
```
{
  tar -xvf etcd-v3.4.15-linux-amd64.tar.gz
  sudo mv etcd-v3.4.15-linux-amd64/etcd* /usr/local/bin/
}
```
4. Configure the **etcd** server 

```
{
  sudo mkdir -p /etc/etcd /var/lib/etcd
  sudo chmod 700 /var/lib/etcd
  sudo cp ca.pem master-kubernetes-key.pem master-kubernetes.pem /etc/etcd/
}
```
5. The instance internal IP address will be used to serve client requests and communicate with `etcd` cluster peers. Retrieve the internal IP address for the current compute instance: 
```
export INTERNAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
```
6. Each `etcd` member must have a unique name within an `etcd` cluster. Set the `etcd` name to node Private IP address so it will uniquely identify the machine: 

```
ETCD_NAME=$(curl -s http://169.254.169.254/latest/user-data/ \
  | tr "|" "\n" | grep "^name" | cut -d"=" -f2)
  
echo ${ETCD_NAME}
```

7. Create the `etcd.service` systemd unit file:

The flags are well documented [here](https://www.bookstack.cn/read/etcd-3.2.17-en/717bafd59fa87192.md)
```
cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
Type=notify
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --listen-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${INTERNAL_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster master-0=https://172.31.0.10:2380,master-1=https://172.31.0.11:2380,master-2=https://172.31.0.12:2380 \\
  --cert-file=/etc/etcd/master-kubernetes.pem \\
  --key-file=/etc/etcd/master-kubernetes-key.pem \\
  --peer-cert-file=/etc/etcd/master-kubernetes.pem \\
  --peer-key-file=/etc/etcd/master-kubernetes-key.pem \\
  --initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```
8. Start and enable the **etcd** Server 
```
{
  sudo systemctl daemon-reload
  sudo systemctl enable etcd
  sudo systemctl start etcd
}
```

9. Verify the **etcd** installation

```
sudo ETCDCTL_API=3 etcdctl member list \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/master-kubernetes.pem \
  --key=/etc/etcd/master-kubernetes-key.pem
```

Output:

```
6709c481b5234095, started, master-0, https://172.31.0.10:2380, https://172.31.0.10:2379, false
ade74a4f39c39f33, started, master-1, https://172.31.0.11:2380, https://172.31.0.11:2379, false
ed33b44c0b153ee3, started, master-2, https://172.31.0.12:2380, https://172.31.0.12:2379, false
```

```
systemctl status etcd
```

![](https://dareyio-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project21/etcd-service-status.png)

### Bootstrap the `Control Plane`

In this section, you will configure the components for the control plane on the master/controller nodes.

1. Create the Kubernetes configuration directory:
```
sudo mkdir -p /etc/kubernetes/config
```

2. Download the official Kubernetes release binaries:
```
wget -q --show-progress --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kube-apiserver" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kube-controller-manager" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kube-scheduler" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl"
```

3. Install the Kubernetes binaries:
```
{
  chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl
  sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/local/bin/
}
```

4. Configure the Kubernetes API Server:
```
{
  sudo mkdir -p /var/lib/kubernetes/

  sudo mv ca.pem ca-key.pem master-kubernetes-key.pem master-kubernetes.pem \
    service-account-key.pem service-account.pem \
    encryption-config.yaml /var/lib/kubernetes/
}
```

The instance internal IP address will be used to advertise the API Server to members of the cluster. Retrieve the internal IP address for the current compute instance:

```
export INTERNAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
export export KUBERNETES_API_SERVER_ADDRESS="k8s-api-server.svc.darey.io"
```

Create the kube-apiserver.service systemd unit file: [Ensure to read each startup flag used in below systemd file from the documentation here](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)

```
cat <<EOF | sudo tee /etc/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-apiserver \\
  --advertise-address=${INTERNAL_IP} \\
  --allow-privileged=true \\
  --apiserver-count=3 \\
  --audit-log-maxage=30 \\
  --audit-log-maxbackup=3 \\
  --audit-log-maxsize=100 \\
  --audit-log-path=/var/log/audit.log \\
  --authorization-mode=Node,RBAC \\
  --bind-address=0.0.0.0 \\
  --client-ca-file=/var/lib/kubernetes/ca.pem \\
  --enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\
  --etcd-cafile=/var/lib/kubernetes/ca.pem \\
  --etcd-certfile=/var/lib/kubernetes/master-kubernetes.pem \\
  --etcd-keyfile=/var/lib/kubernetes/master-kubernetes-key.pem\\
  --etcd-servers=https://172.31.0.10:2379,https://172.31.0.11:2379,https://172.31.0.12:2379 \\
  --event-ttl=1h \\
  --encryption-provider-config=/var/lib/kubernetes/encryption-config.yaml \\
  --kubelet-certificate-authority=/var/lib/kubernetes/ca.pem \\
  --kubelet-client-certificate=/var/lib/kubernetes/master-kubernetes.pem \\
  --kubelet-client-key=/var/lib/kubernetes/master-kubernetes-key.pem \\
  --runtime-config='api/all=true' \\
  --service-account-key-file=/var/lib/kubernetes/service-account.pem \\
  --service-account-signing-key-file=/var/lib/kubernetes/service-account-key.pem \\
  --service-account-issuer=https://${INTERNAL_IP}:6443 \\
  --service-cluster-ip-range=172.32.0.0/24 \\
  --service-node-port-range=30000-32767 \\
  --tls-cert-file=/var/lib/kubernetes/master-kubernetes.pem \\
  --tls-private-key-file=/var/lib/kubernetes/master-kubernetes-key.pem \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

5. Configure the Kubernetes Controller Manager:

Move the kube-controller-manager kubeconfig into place:

```
sudo mv kube-controller-manager.kubeconfig /var/lib/kubernetes/
```
Export some variables to retrieve the `vpc_cidr` - This will be required for the `bind-address` flag:

```
export AWS_METADATA="http://169.254.169.254/latest/meta-data"
export EC2_MAC_ADDRESS=$(curl -s $AWS_METADATA/network/interfaces/macs/ | head -n1 | tr -d '/')
export VPC_CIDR=$(curl -s $AWS_METADATA/network/interfaces/macs/$EC2_MAC_ADDRESS/vpc-ipv4-cidr-block/)
export NAME=k8s-cluster-from-ground-up
```

Create the kube-controller-manager.service systemd unit file:

```
cat <<EOF | sudo tee /etc/systemd/system/kube-controller-manager.service
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-controller-manager \\
  --bind-address=0.0.0.0 \\
  --cluster-cidr=${VPC_CIDR} \\
  --cluster-name=${NAME} \\
  --cluster-signing-cert-file=/var/lib/kubernetes/ca.pem \\
  --cluster-signing-key-file=/var/lib/kubernetes/ca-key.pem \\
  --kubeconfig=/var/lib/kubernetes/kube-controller-manager.kubeconfig \\
  --authentication-kubeconfig=/var/lib/kubernetes/kube-controller-manager.kubeconfig \\
  --authorization-kubeconfig=/var/lib/kubernetes/kube-controller-manager.kubeconfig \\
  --leader-elect=true \\
  --root-ca-file=/var/lib/kubernetes/ca.pem \\
  --service-account-private-key-file=/var/lib/kubernetes/service-account-key.pem \\
  --service-cluster-ip-range=172.32.0.0/24 \\
  --use-service-account-credentials=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

6. Configure the Kubernetes Scheduler:

Move the kube-scheduler kubeconfig into place:

```
sudo mv kube-scheduler.kubeconfig /var/lib/kubernetes/
sudo mkdir -p /etc/kubernetes/config
```

Create the kube-scheduler.yaml configuration file:

```
cat <<EOF | sudo tee /etc/kubernetes/config/kube-scheduler.yaml
apiVersion: kubescheduler.config.k8s.io/v1beta1
kind: KubeSchedulerConfiguration
clientConnection:
  kubeconfig: "/var/lib/kubernetes/kube-scheduler.kubeconfig"
leaderElection:
  leaderElect: true
EOF
```

Create the kube-scheduler.service systemd unit file:
```
cat <<EOF | sudo tee /etc/systemd/system/kube-scheduler.service
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-scheduler \\
  --config=/etc/kubernetes/config/kube-scheduler.yaml \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

7. Start the Controller Services
```
{
  sudo systemctl daemon-reload
  sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler
  sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler
}
```

Check the status of the services. Start with the `kube-scheduler` and  `kube-controller-manager`. It may take up to 20 seconds for `kube-apiserver` to be fully loaded.

{
sudo systemctl status kube-apiserver
sudo systemctl status kube-controller-manager
sudo systemctl status kube-scheduler
}

**NOTE:** There is a trap in the entire setup you have been going through, and so the `api-server` will not start up on your server if you have followed the exact steps so far. As a DevOps engineer, you must be able to solve problems. 

**HINTS:**

1. The problem relates to `etcd` configuration.
2. Check the `systemd` logs for the `api-server`. The problem will be clearly logged, and it will give you an idea what is wrong. Find out how to fix it.


### Test that Everything is working fine 

1. To get the cluster details run:

```
kubectl cluster-info  --kubeconfig admin.kubeconfig
```

**OUTPUT:**

```
Kubernetes control plane is running at https://k8s-api-server.svc.darey.io:6443

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

2. To get the current namespaces:

```
kubectl get namespaces --kubeconfig admin.kubeconfig
```

**OUTPUT:**

```
NAME              STATUS   AGE
default           Active   22m
kube-node-lease   Active   22m
kube-public       Active   22m
kube-system       Active   22m
```

3. To reach the Kubernetes API Server publicly 

```
curl --cacert /var/lib/kubernetes/ca.pem https://$INTERNAL_IP:6443/version
```

**OUTPUT:**

```
{
  "major": "1",
  "minor": "21",
  "gitVersion": "v1.21.0",
  "gitCommit": "cb303e613a121a29364f75cc67d3d580833a7479",
  "gitTreeState": "clean",
  "buildDate": "2021-04-08T16:25:06Z",
  "goVersion": "go1.16.1",
  "compiler": "gc",
  "platform": "linux/amd64"
}
```

4. To get the status of each component:

```
kubectl get componentstatuses --kubeconfig admin.kubeconfig
```

![](https://dareyio-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project21/Check-componentStatus.png)

5. On one of the controller nodes, configure Role Based Access Control (RBAC) so that the `api-server` has necessary authorization for for the `kubelet`.
   
Create the **ClusterRole**:
```
cat <<EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:kube-apiserver-to-kubelet
rules:
  - apiGroups:
      - ""
    resources:
      - nodes/proxy
      - nodes/stats
      - nodes/log
      - nodes/spec
      - nodes/metrics
    verbs:
      - "*"
EOF
```

Create the **ClusterRoleBinding** to bind the `kubernetes` user with the role created above:

```
cat <<EOF | kubectl --kubeconfig admin.kubeconfig  apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: system:kube-apiserver
  namespace: ""
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:kube-apiserver-to-kubelet
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: kubernetes
EOF
```