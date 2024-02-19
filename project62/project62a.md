
# Dive into Kubernetes Logging with Hands-on Practice

## Intoduction

Are you curious about what's happening within your Kubernetes cluster? This hands-on project will equip you with the knowledge and tools to unlock the secrets hidden in your logs. Imagine yourself as a detective, wielding powerful commands to uncover the stories your pods are telling.

## Prerequisites:

* **Kubectl**: Your key to interacting with Kubernetes. Install it following the guide for your operating system: [https://kubernetes.io/docs/tasks/tools/](https://kubernetes.io/docs/reference/kubectl/)

* **Kubeconfig**: This acts as your access code to the cluster. Retrieve it from your cluster administrator.

**Setting the stage:**

Choosing the right Kubernetes cluster to explore is like picking the right path on a map. Let's tell kubectl which cluster you want to investigate.

**Optional Setup (If using AWS EKS):**

* **Terraform**: For infrastructure provisioning (https://developer.hashicorp.com/terraform/install)

* **AWS CLI:** To interact with AWS services (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

* **Kubectl for EKS:** Install version 1.27 following the EKS documentation (https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

* **Key Pair:** Create a key pair named "ed-office" on the AWS Console

**Clone Git Repository:**

```
git clone https://gitlab.com/bml4/terraform/-/tree/main/eks/eks-using-custom?ref_type=heads
cd eks/eks-using-custom

```

```
cd eks/eks-using-custom
```
Follow the **aws configure** prompt

```
aws configure
AWS Access Key ID [****************7PWB]: AKIAX6K6BBFPLM4QKHBG
AWS Secret Access Key [****************S/nN]: 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
Default region name [us-east-1]:
Default output format [none]:
```
```
aws get-caller-identity

```

```
terraform init
terraform -version
terraform apply

```

**Check the Connection:** Is everything working? 

At the client side you need to generate certificate to connect to the api server.

The Authority certificate is automatically created on the server side.
The Cluster IAm role is managed by AWS.

```
aws eks update-kubeconfig --name ed-eks-01 --region us-east-1
Added new context arn:aws:eks:us-east-1:546194917726:cluster/ed-eks-01 to C:\Users\prin\.kube\config

```
The generated client certificate is kept in the home directory of the client system.

```
cat ~/.kube/config
```
Run kubectl get nodes to see if you can connect and list the available nodes in your cluster. Think of them as the busy bees keeping your system running!

```
kubectl get nodes
NAME                           STATUS   ROLES    AGE   VERSION
ip-192-168-1-30.ec2.internal   Ready    <none>   36m   v1.22.17-eks-0a21954
ip-192-168-2-32.ec2.internal   Ready    <none>   35m   v1.22.17-eks-0a21954

```
**Deploy a pod**

Create a file in your vscode folder, name it **pod.yaml** and paste the below and read more about [pod](https://kubernetes.io/docs/concepts/workloads/pods/).

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app:nginx
    env: sandbox
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80 
```

```
kubectl apply -f pod.yaml
pod/nginx created
```

```
kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          2m34s

```

**Unlock the Pod Logs**: Now that you're connected, it's time to see what's happening inside those pods. 

Use kubectl logs pod_name to view the logs of a specific pod. Think of it like reading a diary to see what's going on inside.

```
kubectl logs nginx

```