
# Logging in Kubernetes

Welcome to the comprehensive hands-on project on "**Logging in kubernetes**."
Are you ready to embark on a quest to unlock the secrets of your cluster's operations?
Think of this project as your key to unlocking its secrets! We'll show you how to use kubectl, a handy tool, to peek into the lives of your kubernetes pods and understand what's going on.

## Before we start:

Make sure you have [Kubectl](https://kubernetes.io/docs/reference/kubectl/) installed on your computer. It's like a magic wand for interacting with Kubernetes! You can find instructions for your operating system here: https://kubernetes.io/docs/tasks/tools/
You'll also need a special password called a "kubeconfig" to access your cluster. Think of it as the secret handshake to get in.

Ready to begin? Let's go!

**Set the Stage:** Imagine choosing the right path on a map. We need to tell kubectl which Kubernetes cluster you want to explore.

- Install [Terraform](https://developer.hashicorp.com/terraform/install)
- Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- Install [Kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html) with version 1.27.
- create key-pair with the name **ed-office** from the **AWS Console**

Clone [terraform repo]((https://gitlab.com/bml4/terraform/-/tree/main/eks/eks-using-custom?ref_type=heads))
 
 Edit the EKS version to 1.27.

 The Kubectl must be compatible with kubernetes version.

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