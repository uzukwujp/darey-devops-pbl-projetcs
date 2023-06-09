#### Persisting Data for Pods

Deployments are stateless by design. Hence, any data stored inside the Pod's container does not persist when the Pod dies. 

If you were to update the content of the `index.html` file inside the container, and the Pod dies, that content will be lost since a new Pod will replace the dead one.

Let us try that:

1. Scale the Pods down to 1 replica.

```
NAME                                READY   STATUS        RESTARTS   AGE
nginx-deployment-56466d4948-58nqx   0/1     Terminating   0          45m
nginx-deployment-56466d4948-5z4c2   1/1     Terminating   0          45m
nginx-deployment-56466d4948-5zdbx   0/1     Terminating   0          62m
nginx-deployment-56466d4948-78j9c   1/1     Terminating   0          45m
nginx-deployment-56466d4948-gj4fd   1/1     Terminating   0          45m
nginx-deployment-56466d4948-gsrpz   0/1     Terminating   0          45m
nginx-deployment-56466d4948-kg9hp   1/1     Terminating   0          45m
nginx-deployment-56466d4948-qs29b   0/1     Terminating   0          45m
nginx-deployment-56466d4948-sfft6   0/1     Terminating   0          45m
nginx-deployment-56466d4948-sg4np   0/1     Terminating   0          45m
nginx-deployment-56466d4948-tg9j8   1/1     Running       0          62m
nginx-deployment-56466d4948-ttn5t   1/1     Terminating   0          62m
nginx-deployment-56466d4948-vfmjx   0/1     Terminating   0          45m
nginx-deployment-56466d4948-vlgbs   1/1     Terminating   0          45m
nginx-deployment-56466d4948-xctfh   0/1     Terminating   0          45m
```

```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-56466d4948-tg9j8   1/1     Running   0          64m
```

2. Exec into the running container (figure out the command yourself)

3. Install `vim` so that you can edit the file

```
apt-get update
apt-get install vim
```

4. Update the content of the file and add the code below `/usr/share/nginx/html/index.html`

```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to DAREY.IO!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to DAREY.IO!</h1>
<p>I love experiencing Kubernetes</p>

<p>Learning by doing is absolutely the best strategy at 
<a href="https://darey.io/">www.darey.io</a>.<br/>
for skills acquisition
<a href="https://darey.io/">www.darey.io</a>.</p>

<p><em>Thank you for learning from DAREY.IO</em></p>
</body>
</html>
```

5. Check the browser - You should see this
   
<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project22/Dareyio-web-pod.png" width="936px" height="550px">
6. Now, delete the only running Pod so that a new one is automatically recreated.

```
 kubectl delete po nginx-deployment-56466d4948-tg9j8
pod "nginx-deployment-56466d4948-tg9j8" deleted
```

7. Refresh the web page - You will see that the content you saved in the container is no longer there. That is because Pods do not store data when they are being recreated - that is why they are called `ephemeral` or `stateless`. (*But not to worry, we will address this with persistent volumes in the next project*)
  
<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project22/Nginx-page.png" width="936px" height="550px">
Storage is a critical part of running containers, and Kubernetes offers some powerful primitives for managing it. **Dynamic volume provisioning**, a feature unique to Kubernetes, which allows storage volumes to be created on-demand. Without dynamic provisioning, DevOps engineers must manually make calls to the cloud or storage provider to create new storage volumes, and then create **PersistentVolume** objects to represent them in Kubernetes. The dynamic provisioning feature eliminates the need for DevOps to pre-provision storage. Instead, it automatically provisions storage when it is requested by users.

To make the data persist in case of a Pod's failure, you will need to configure the Pod to use **Volumes**:

**Clean up the deployment**

```
kubectl delete deployment nginx-deployment
```
In the next project, 

- You will understand how persistence work in Kubernetes using Volumes.
- You will use `eksctl` to create a Kubernetes EKS cluster in AWS, and begin to use some powerful features such as **PV**, **PVCs**, **ConfigMaps**. 
- Experience Dynamic provisioning of volumes to make your Pods stateful, using Kubernetes Statefulset

Keep it up!

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project22/k8s_medal.png" width="936px" height="550px">