#### Expose a Service on a server's public IP address & static port

Sometimes, it may be needed to directly access the application using the public IP of the server (when we speak of a K8s cluster we can replace 'server' with 'node') the Pod is running on. This is when the [**NodePort**](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport) service type comes in handy.

A **Node port** service type exposes the service on a static port on the node's IP address. NodePorts are in the `30000-32767` range by default, which means a NodePort is unlikely to match a service’s intended port (for example, 80 may be exposed as 30080).

Update the nginx-service `yaml` to use a NodePort Service.

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx-pod
  ports:
    - protocol: TCP
      port: 80
      nodePort: 30080
```

What has changed is:

1. Specified the type of service (Nodeport)
2. Specified the NodePort number to use.

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project22/Nodeport-service.png" width="936px" height="550px">
To access the service, you must:

- Allow the inbound traffic in your EC2's Security Group to the NodePort range `30000-32767`
- Get the public IP address of the node the Pod is running on, append the nodeport and access the app through the browser. 

You must understand that the port number `30080` is a port on the node in which the Pod is scheduled to run. If the Pod ever gets rescheduled elsewhere, that the same port number will be used on the new node it is running on. So, if you have multiple Pods running on several nodes at the same time - they all will be exposed on respective nodes' IP addresses with a static port number. 

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project22/Nodeport-service-browser.png" width="936px" height="550px">
Read some more information regarding Services in Kubernetes in [this article](https://medium.com/avmconsulting-blog/service-types-in-kubernetes-24a1587677d6).

#### How Kubernetes ensures desired number of Pods is always running?

When we define a Pod manifest and appy it - we create a Pod that is running until it's terminated for some reason (e.g., error, Node reboot or some other reason), but what if we want to declare that we always need at least 3 replicas of the same Pod running at all times? Then we must use an [**ResplicaSet (RS)**](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/) object - it's purpose is to  maintain a stable set of Pod replicas running at any given time. As such, it is often used to guarantee the availability of a specified number of identical Pods.

**Note:** In some older books or documents you might find the old version of a similar object - [`ReplicationController (RC)`](https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/), it had similar purpose, but did not support [set-base label selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#set-based-requirement) and it is now recommended to use ReplicaSets instead, since it is the next-generation RC.

Let us delete our nginx-pod Pod:

```
kubectl delete -f nginx-pod.yaml
```

**Output:**
```
pod "nginx-pod" deleted
```

##### Create a ReplicaSet

Let us create a `rs.yaml` manifest for a ReplicaSet object:

```
#Part 1
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-rs
spec:
  replicas: 3
  selector:
    app: nginx-pod
#Part 2
  template:
    metadata:
      name: nginx-pod
      labels:
         app: nginx-pod
    spec:
      containers:
      - image: nginx:latest
        name: nginx-pod
        ports:
        - containerPort: 80
          protocol: TCP

```

```
kubectl apply -f rs.yaml
```

The manifest file of ReplicaSet consist of the following fields:

- apiVersion: This field specifies the version of kubernetes Api to which the object belongs. ReplicaSet belongs to **apps/v1** apiVersion.
- kind: This field specify the type of object for which the manifest belongs to. Here, it is **ReplicaSet**.
- metadata: This field includes the metadata for the object. It mainly includes two fields: name and labels of the ReplicaSet.
- spec: This field specifies the **label selector** to be used to select the Pods, number of replicas of the Pod to be run and the container or list of containers which the Pod will run. In the above example, we are running 3 replicas of nginx container.


Let us check what Pods have been created:

```
kubectl get pods
```

```
NAME              READY   STATUS    RESTARTS   AGE     IP               NODE                                              NOMINATED NODE   READINESS GATES
nginx-pod-j784r   1/1     Running   0          7m41s   172.50.197.5     ip-172-50-197-52.eu-central-1.compute.internal    <none>           <none>
nginx-pod-kg7v6   1/1     Running   0          7m41s   172.50.192.152   ip-172-50-192-173.eu-central-1.compute.internal   <none>           <none>
nginx-pod-ntbn4   1/1     Running   0          7m41s   172.50.202.162   ip-172-50-202-18.eu-central-1.compute.internal    <none>           <none>
```

Here we see three `ngix-pods` with some random suffixes (e.g., `-j784r`) - it means, that these Pods were created and named automatically by some other object (higher level of abstraction) such as ReplicaSet.

Try to delete one of the Pods:

```
kubectl delete po nginx-pod-j784r
```

**Output:**
```
pod "nginx-pod-j784r" deleted
```

```
❯ kubectl get pods
NAME              READY   STATUS    RESTARTS   AGE
nginx-rc-7xt8z   1/1     Running   0          22s
nginx-rc-kg7v6   1/1     Running   0          34m
nginx-rc-ntbn4   1/1     Running   0          34m
```

You can see, that we still have all 3 Pods, but one has been recreated (can you differentiate the new one?)

Explore the ReplicaSet created:

```
kubectl get rs -o wide
```

**Output:**
```
NAME        DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES         SELECTOR
nginx-rs   3         3         3       34m   nginx-pod    nginx:latest   app=nginx-pod
```

Notice, that ReplicaSet understands which Pods to create by using **SELECTOR** key-value pair.

##### Get detailed information of a ReplicaSet

To display detailed information about any Kubernetes object, you can use 2 differen commands:

- kubectl **describe** %object_type% %object_name% (e.g. `kubectl describe rs nginx-rs`) 
- kubectl **get** %object_type% %object_name% -o yaml (e.g. `kubectl describe rs nginx-rs -o yaml`)

Try both commands in action and see the difference. Also try **get** with `-o json` instead of `-o yaml` and decide for yourself which output option is more readable for you. 

##### Scale ReplicaSet up and down:

In general, there are 2 approaches of [Kubernetes Object Management](https://kubernetes.io/docs/concepts/overview/working-with-objects/object-management/): _imperative_ and _declarative_.

Let us see how we can use both to scale our Replicaset up and down:

**Imperative:**

We can easily scale our ReplicaSet up by specifying the desired number of replicas in an imperative command, like this:

```
❯ kubectl scale rs nginx-rs --replicas=5
replicationcontroller/nginx-rc scaled
```

```
❯ kubectl get pods
NAME             READY   STATUS    RESTARTS   AGE
nginx-rc-4kgpj   1/1     Running   0          4m30s
nginx-rc-4z2pn   1/1     Running   0          4m30s
nginx-rc-g4tvg   1/1     Running   0          6s
nginx-rc-kmh8m   1/1     Running   0          6s
nginx-rc-zlgvp   1/1     Running   0          4m30s
```

Scaling down will work the same way, so scale it down to 3 replicas.

**Declarative:**

Declarative way would be to open our `rs.yaml` manifest, change desired number of replicas in respective section

```
spec:
  replicas: 3
```

and applying the updated manifest:

```
kubectl apply -f rs.yaml
```

There is another method - **'ad-hoc'**, it is definitely not the best practice and we do not recommend using it, but you can edit an existing ReplicaSet with following command:

```
kubectl edit -f rs.yaml
```
