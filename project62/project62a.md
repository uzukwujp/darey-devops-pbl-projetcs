
# Dive into Kubernetes Logging with Hands-on Practice

## Intoduction

Are you curious about what's happening within your Kubernetes cluster? This hands-on project will equip you with the knowledge and tools to unlock the secrets hidden in your logs. Imagine yourself as a detective, wielding powerful commands to uncover the stories your pods are telling.

## Prerequisites:

* **Kubectl**: Your key to interacting with Kubernetes. Install it following the guide for your operating system: [https://kubernetes.io/docs/tasks/tools/](https://kubernetes.io/docs/reference/kubectl/)

* **Kubeconfig**: This acts as your access code to the cluster. Retrieve it from your cluster administrator.

**Setting the stage:**

Choosing the right Kubernetes cluster to explore is like picking the right path on a map. Let's tell kubectl which cluster you want to investigate.

**Optional Setup (If using AWS EKS):**

This guide walks you through setting up and interacting with your AWS EKS cluster using Terraform and kubectl.
* **AWS Account**: With neccessary permissions.

* **Terraform**: For infrastructure provisioning (https://developer.hashicorp.com/terraform/install)

* **AWS CLI:** To interact with AWS services (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

* **Kubectl for EKS:** Install version 1.27 following the EKS documentation (https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

* **Key Pair:** Create a key pair named "ed-office" on the AWS Console

**Git Clone and Configure:**

Start by cloning the terraform repository and navigating to the appropriate directory:

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

**Infrastructure Provisioning with Terraform**

Initialize Terraform and review the proposed plan:
```
terraform init
terraform plan
```
If everything looks good, proceed with applying the configuration:

```
terraform plan
```
**Update Kubeconfig and Verify Connection:**

After successful provisioning, update your kubeconfig to access the cluster:

```
aws eks update-kubeconfig --name ed-eks-01 --region us-east-1

```
The generated client certificate is kept in the home directory of the client system.

```
cat ~/.kube/config
```

Verify the connection by listing the available nodes:

```
kubectl get nodes
```
**Deploy a sample pod**
Create a file named [pod.yaml](https://kubernetes.io/docs/concepts/workloads/pods/) containing the following Pod definition: 

**YAML**

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

Deploy the Pod using kubectl:

```
kubectl apply -f pod.yaml
```

Check if the Pod is running successfully:

```
kubectl get pods

```

**View Pod Logs:**

Utilize kubectl to view the logs of your deployed Pod:

```
kubectl logs nginx

```