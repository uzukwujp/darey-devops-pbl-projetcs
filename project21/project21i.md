**Configure the worker nodes components**

9. **Configure `kubelet`:**

In the home directory, you should have the certificates and `kubeconfig` file for each node. A list in the home folder should look like below:

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project21/Worker-nodes-home-folder.png" width="936px" height="550px">
**Configuring the network**

Get the POD_CIDR that will be used as part of network configuration

```
POD_CIDR=$(curl -s http://169.254.169.254/latest/user-data/ \
  | tr "|" "\n" | grep "^pod-cidr" | cut -d"=" -f2)
echo "${POD_CIDR}"
```

In case you are wondering where this `$POD_CIDR` is coming from. Well, this was configured at the time of creating the worker nodes. Remember the for loop below? The `--user-data` flag is where we specified what we want the POD_CIDR to be. It is very important to ensure that the CIDR does not overlap with EC2 IPs within the subnet. In the real world, this will be decided in collaboration with the Network team.


Why do we need a network plugin? And why network configuration is crucial to implementing a Kubernetes cluster?

First, let us understand the Kubernetes networking model:

The networking model assumes a flat network, in which containers and nodes can communicate with each other. That means, regardless of which node is running the container in the cluster, Kubernetes expects that all the containers must be able to communicate with each other. Therefore, any network interface used for a Kubernetes implementation must follow this requirement. Otherwise, containers running in [pods](https://kubernetes.io/docs/concepts/workloads/pods/) will not be able to communicate.  Of course, this has security concerns. Because if an attacker is able to get into the cluster through a compromised container, then the entire cluster can be exploited.

To mitigate security risks and have a better controlled network topology, Kubernetes uses [CNI (Container Network Interface)](https://github.com/containernetworking/cni) to manage [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) which can be used to operate the **Pod network** through external plugins such as [`Calico`](https://docs.projectcalico.org/about/about-calico), [`Flannel`](https://github.com/flannel-io/flannel#flannel) or [`Weave Net`](https://www.weave.works/oss/net/) to name [a few](https://kubernetes.io/docs/concepts/cluster-administration/networking/). With these, you can set policies similar to how you would configure segurity groups in AWS and limit network communications through either cidr `ipBlock`, `namespaceSelectors`, or  `podSelectors`, you will see more of these concepts further on.

To really understand Kubernetes further, let us explore some basic concepts around its networking:

**Pods:**

[A Pod](https://kubernetes.io/docs/concepts/workloads/pods/) is the basic building block of Kubernetes; it is the smallest and simplest unit in the Kubernetes object model that you create or deploy. A Pod represents a running process on your cluster.
It encapsulates a container running an application such as the **Tooling website** (or, in some cases, multiple containers), storage resources, a unique network IP, and options that govern how the container(s) should run. All the containers running inside a Pod can reach each other on localhost. 

For example, if you deploy both `Tooling` and `MySQL` containers inside the same pod, then both of them are considered running on `localhost`. Although this design pattern is not ideal. Most likely they will run in separate Pods. In most cases one Pod contains just one container, but there are some design patterns that imply multi-container pods (e.g. `sidecar`, `ambassador`, `adapter`) - you can read more about them in [this article](https://betterprogramming.pub/understanding-kubernetes-multi-container-pod-patterns-577f74690aee). 

For a better understanding, of Kubernetes networking, let us assume that we have 2-containers in a single Pod and we have 2 such Pods (we can actually have as many pods of the same composition as our node resources would allow).

Network configuration will look like this:

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project21/k8s_network.png" width="936px" height="550px">
Notice, that both containers share a single virtual network interface `veth0` that belongs to a virtual network within a single node. This virtual interface `veth0` is used to allow communication from a pod to the outer world through a bridge `cbr0` (custom bridge). This bridge is an interface that forwards the traffic from the Pods on one node to other nodes through a physical network interface `eth0`. Routing between the nodes is done by means of a router with the routing table. 

For more detailed explanation of different aspects of Kubernetes networking - watch [this video](https://www.youtube.com/watch?v=5cNrTU6o3Fw).


**Pod Network**

You must decide on the **Pod CIDR** per worker node. Each worker node will run multiple pods, and each pod will have its own IP address. IP address of a particular Pod on worker node 1 should be able to communicate with the IP address of another particular Pod on worker node 2. For this to become possible, there must be a bridge network with virtual network interfaces that connects them all together. [Here is an interesting read that goes a little deeper into how it works](https://www.digitalocean.com/community/tutorials/kubernetes-networking-under-the-hood) *Bookmark that page and read it over and over again after you have completed this project*

10.  Configure the bridge and loopback networks

Bridge:
```
cat > 172-20-bridge.conf <<EOF
{
    "cniVersion": "0.3.1",
    "name": "bridge",
    "type": "bridge",
    "bridge": "cnio0",
    "isGateway": true,
    "ipMasq": true,
    "ipam": {
        "type": "host-local",
        "ranges": [
          [{"subnet": "${POD_CIDR}"}]
        ],
        "routes": [{"dst": "0.0.0.0/0"}]
    }
}
EOF
```

Loopback:

```
cat > 99-loopback.conf <<EOF
{
    "cniVersion": "0.3.1",
    "type": "loopback"
}
EOF
```

11. Move the files to the network configuration directory:

```
sudo mv 172-20-bridge.conf 99-loopback.conf /etc/cni/net.d/
```

12. Store the worker's name in a variable:

```
NAME=k8s-cluster-from-ground-up
WORKER_NAME=${NAME}-$(curl -s http://169.254.169.254/latest/user-data/ \
  | tr "|" "\n" | grep "^name" | cut -d"=" -f2)
echo "${WORKER_NAME}"
```

13. Move the certificates and `kubeconfig` file to their respective configuration directories:

```
sudo mv ${WORKER_NAME}-key.pem ${WORKER_NAME}.pem /var/lib/kubelet/
sudo mv ${WORKER_NAME}.kubeconfig /var/lib/kubelet/kubeconfig
sudo mv kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
sudo mv ca.pem /var/lib/kubernetes/
```

14. Create the `kubelet-config.yaml` file 

Ensure the needed variables exist:

```
NAME=k8s-cluster-from-ground-up
WORKER_NAME=${NAME}-$(curl -s http://169.254.169.254/latest/user-data/ \
  | tr "|" "\n" | grep "^name" | cut -d"=" -f2)
echo "${WORKER_NAME}"
```

```
cat <<EOF | sudo tee /var/lib/kubelet/kubelet-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/var/lib/kubernetes/ca.pem"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  - "10.32.0.10"
resolvConf: "/etc/resolv.conf"
runtimeRequestTimeout: "15m"
tlsCertFile: "/var/lib/kubelet/${WORKER_NAME}.pem"
tlsPrivateKeyFile: "/var/lib/kubelet/${WORKER_NAME}-key.pem"
EOF
```

Let us talk about the configuration file `kubelet-config.yaml` and the actual configuration for a bit. Before creating the systemd file for **kubelet**, it is recommended to create the `kubelet-config.yaml` and set the configuration there rather than using multiple startup flags in systemd. You will simply point to the `yaml` file.

The config file specifies where to find certificates, the DNS server, and authentication information. As you already know, `kubelet` is responsible for the containers running on the node, regardless if the runtime is Docker or Containerd; as long as the containers are being created through Kubernetes, `kubelet` manages them. If you run any `docker` or `cri` commands directly on a worker to create a container, bear in mind that Kubernetes is not aware of it, therefore `kubelet` will not manage those. Kubelet's major responsibility is to always watch the containers in its care, by default every 20 seconds, and ensuring that they are always running. Think of it as a process watcher.

The `clusterDNS` is the address of the DNS server. As of Kubernetes v1.12, CoreDNS is the recommended DNS Server, hence we will go with that, rather than using legacy **kube-dns**.

**Note:** *The CoreDNS Service is named `kube-dns`(When you see **kube-dns**, just know that it is using **CoreDNS**). This is more of a backward compatibility reasons for workloads that relied on the legacy **kube-dns** Service name.*

In Kubernetes, Pods are able to find each other using service names through the internal DNS server. Every time a service is created, it gets registered in the DNS server.

In Linux, the `/etc/resolv.conf` file is where the DNS server is configured. If you want to use Google's public DNS server (8.8.8.8) your /etc/resolv.conf file will have following entry:

`nameserver 8.8.8.8`

In Kubernetes, the `kubelet` process on a worker node configures each pod. Part of the configuration process is to create the file **/etc/resolv.conf** and specify the correct DNS server.

15.    Configure the `kubelet` systemd service

```
cat <<EOF | sudo tee /etc/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=containerd.service
Requires=containerd.service
[Service]
ExecStart=/usr/local/bin/kubelet \\
  --config=/var/lib/kubelet/kubelet-config.yaml \\
  --cluster-domain=cluster.local \\
  --container-runtime=remote \\
  --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock \\
  --image-pull-progress-deadline=2m \\
  --kubeconfig=/var/lib/kubelet/kubeconfig \\
  --network-plugin=cni \\
  --register-node=true \\
  --v=2
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF
```

16.   Create the `kube-proxy.yaml` file


```
cat <<EOF | sudo tee /var/lib/kube-proxy/kube-proxy-config.yaml
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: "/var/lib/kube-proxy/kubeconfig"
mode: "iptables"
clusterCIDR: "172.31.0.0/16"
EOF
```

17.  Configure the Kube Proxy systemd service

```
cat <<EOF | sudo tee /etc/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes
[Service]
ExecStart=/usr/local/bin/kube-proxy \\
  --config=/var/lib/kube-proxy/kube-proxy-config.yaml
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF
```


18. Reload configurations and start both services

```
{
  sudo systemctl daemon-reload
  sudo systemctl enable containerd kubelet kube-proxy
  sudo systemctl start containerd kubelet kube-proxy
}
```
Now you should have the worker nodes joined to the cluster, and in a **READY** state.

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project21/Ready-worker-nodes.png" width="936px" height="550px">

**Troubleshooting Tips**: If you have issues at this point. Consider the below:

1. Use `journalctl -u <service name>` to get the log output and read what might be wrong with starting up the service. You can redirect the output into a file and analyse it.
2. Review your PKI setup again. Ensure that the certificates you generated have the hostnames properly configured.
3. It is okay to start all over again. Each time you attempt the solution is an opportunity to learn something.

### Congratulations!

You have created your first Kubernetes cluster From-Ground-Up! It was not an easy task, but you have learned how different components of K8s work together - it will help you not just in creation of clusters in the real work experience, but will also help you with sound skills to maintain and troubleshoot them further.

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project21/kube-hero.png" width="936px" height="550px">
Proceed to the next exciting PBL projects to practice more Kubernetes and other cool technologies with us!

