##### Advanced label matching

As Kubernetes mature as a technology, so does its features and improvements to k8s objects. `ReplicationControllers` do not meet certain complex business requirements when it comes to using `selectors`. Imagine if you need to select Pods with multiple lables that represents things like:

 - **Application tier:** such as Frontend, or Backend
 - **Environment:** such as Dev, SIT, QA, Preprod, or Prod

So far, we used a simple selector that just matches a key-value pair and check only 'equality':

```
  selector:
    app: nginx-pod
```

But in some cases, we want ReplicaSet to manage our existing containers that match certain criteria, we can use the same simple label matching or we can use some more complex conditions, such as:

```
 - in
 - not in
 - not equal
 - etc...
```

Let us look at the following manifest file:

```
apiVersion: apps/v1
kind: ReplicaSet
metadata: 
  name: nginx-rs
spec:
  replicas: 3
  selector:
    matchLabels:
      env: prod
    matchExpressions:
    - { key: tier, operator: In, values: [frontend] }
  template:
    metadata:
      name: nginx
      labels: 
        env: prod
        tier: frontend
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest
        ports:
        - containerPort: 80
          protocol: TCP
```

In the above spec file, under the selector, **matchLabels** and **matchExpression** are used to specify the key-value pair. The **matchLabel** works exactly the same way as the equality-based selector, and the matchExpression is used to specify the set based selectors. This feature is the main differentiator between **ReplicaSet** and previously mentioned obsolete **ReplicationController**. 

Get the replication set:
 
```
❯ kubectl get rs nginx-rs -o wide
NAME       DESIRED   CURRENT   READY   AGE     CONTAINERS        IMAGES         SELECTOR
nginx-rs   3         3         3       5m34s   nginx-container   nginx:latest   env=prod,tier in (frontend)
```

#### Using AWS Load Balancer to access your service in Kubernetes.

***Note:*** *You will only be able to test this using AWS EKS. You don not have to set this up in current project yet. In the next project, you will update your Terraform code to build an EKS cluster.*

You have previously accessed the Nginx service through **ClusterIP**, and **NodeIP**, but there is another service type - [**Loadbalancer**](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer). This type of service does not only create a **Service** object in K8s, but also provisions a real external Load Balancer (e.g. [Elastic Load Balancer - ELB](https://aws.amazon.com/elasticloadbalancing/) in AWS)

To get the experience of this service type, update your service manifest and use the **LoadBalancer** type. Also, ensure that the selector references the Pods in the replica set. 

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: LoadBalancer
  selector:
    tier: frontend
  ports:
    - protocol: TCP
      port: 80 # This is the port the Loadbalancer is listening at
      targetPort: 80 # This is the port the container is listening at
```

Apply the configuration:
```
kubectl apply -f nginx-service.yaml
```

Get the newly created service :

```
kubectl get service nginx-service
```

**output:**

```
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP                                                                  PORT(S)        AGE
nginx-service   LoadBalancer   10.100.71.130   aab159950f39e43d39195e23c77417f8-1167953448.eu-central-1.elb.amazonaws.com   80:31388/TCP   5d18h
```

An ELB resource will be created in your AWS console.

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project22/Loadbalancer-service-description.png" width="936px" height="550px">
A Kubernetes component in the control plane called **[Cloud-controller-manager](https://kubernetes.io/docs/concepts/architecture/cloud-controller)** is responsible for triggeriong this action. It connects to your specific cloud provider's (AWS) APIs and create resources such as Load balancers. It will ensure that the resource is appropriately tagged:

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project22/Loadbalancer-service-type.png" width="936px" height="550px">
Get the output of the entire `yaml` for the service. You will some additional  information about this service in which you did not define them in the yaml manifest. Kubernetes did this for you.

```
kubectl get service nginx-service -o yaml
```

**output:**

```
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"name":"nginx-service","namespace":"default"},"spec":{"ports":[{"port":80,"protocol":"TCP","targetPort":80}],"selector":{"app":"nginx-pod"},"type":"LoadBalancer"}}
  creationTimestamp: "2021-06-18T16:24:21Z"
  finalizers:
  - service.kubernetes.io/load-balancer-cleanup
  name: nginx-service
  namespace: default
  resourceVersion: "21824260"
  selfLink: /api/v1/namespaces/default/services/nginx-service
  uid: c12145d6-a8b5-491d-95ff-8e2c6296b46c
spec:
  clusterIP: 10.100.153.44
  externalTrafficPolicy: Cluster
  ports:
  - nodePort: 31388
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    tier: frontend
  sessionAffinity: None
  type: LoadBalancer
status:
  loadBalancer:
    ingress:
    - hostname: ac12145d6a8b5491d95ff8e2c6296b46-588706163.eu-central-1.elb.amazonaws.com
```

1. A clusterIP key is updated in the manifest and assigned an IP address. Even though you have specified a `Loadbalancer` service type, internally it still requires a clusterIP to route the external traffic through.
2. In the ports section, `nodePort` is still used. This is because Kubernetes still needs to use a dedicated port on the worker node to route the traffic through. Ensure that port range `30000-32767` is opened in your inbound Security Group configuration.
3. More information about the provisioned balancer is also published in the `.status.loadBalancer` field.

```
status:
  loadBalancer:
    ingress:
    - hostname: ac12145d6a8b5491d95ff8e2c6296b46-588706163.eu-central-1.elb.amazonaws.com
```

Copy and paste the load balancer's address to the browser, and you will access the Nginx service

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project22/Nginx-load-balancer-browser.png" width="936px" height="550px">
#### Do not Use Replication Controllers - Use Deployment Controllers Instead

Kubernetes is loaded with a lot of features, and with its vibrant open source community, these features are constantly evolving and adding up. 

Previously, you have seen the improvements from **ReplicationControllers (RC)**, to **ReplicaSets (RS)**. In this section you will see another K8s object which is highly recommended over Replication objects (RC and RS).

A [**Deployment**](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) is another layer above ReplicaSets and Pods, newer and more advanced level concept than ReplicaSets. It manages the deployment of ReplicaSets and allows for easy updating of a ReplicaSet as well as the ability to roll back to a previous version of deployment. It is declarative and can be used for rolling updates of micro-services, ensuring there is no downtime.

Officially, it is highly recommended to use **Deplyments** to manage replica sets rather than using replica sets directly.

Let us see Deployment in action.

1. Delete the ReplicaSet

```
kubectl delete rs nginx-rs
```

2. Understand the layout of the `deployment.yaml` manifest below. Lets go through the 3 separated sections:

```
# Section 1 - This is the part that defines the deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    tier: frontend

# Section 2 - This is the Replica set layer controlled by the deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: frontend

# Section 3 - This is the Pod section controlled by the deployment and selected by the replica set in section 2.
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

3. Putting them altogether

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    tier: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

```
kubectl apply -f deployment.yaml
```

Run commands to get the following

1. Get the Deployment
```
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           39s
```

2. Get the ReplicaSet
```
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-56466d4948   3         3         3       24s
```

3. Get the Pods 
```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-56466d4948-5zdbx   1/1     Running   0          12s
nginx-deployment-56466d4948-tg9j8   1/1     Running   0          12s
nginx-deployment-56466d4948-ttn5t   1/1     Running   0          12s
```

4. Scale the replicas in the Deployment to 15 Pods
```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-56466d4948-58nqx   1/1     Running   0          6s
nginx-deployment-56466d4948-5z4c2   1/1     Running   0          6s
nginx-deployment-56466d4948-5zdbx   1/1     Running   0          17m
nginx-deployment-56466d4948-78j9c   1/1     Running   0          6s
nginx-deployment-56466d4948-gj4fd   1/1     Running   0          6s
nginx-deployment-56466d4948-gsrpz   1/1     Running   0          6s
nginx-deployment-56466d4948-kg9hp   1/1     Running   0          6s
nginx-deployment-56466d4948-qs29b   1/1     Running   0          6s
nginx-deployment-56466d4948-sfft6   1/1     Running   0          6s
nginx-deployment-56466d4948-sg4np   1/1     Running   0          6s
nginx-deployment-56466d4948-tg9j8   1/1     Running   0          17m
nginx-deployment-56466d4948-ttn5t   1/1     Running   0          17m
nginx-deployment-56466d4948-vfmjx   1/1     Running   0          6s
nginx-deployment-56466d4948-vlgbs   1/1     Running   0          6s
nginx-deployment-56466d4948-xctfh   1/1     Running   0          6s
```

5. Exec into one of the Pod's container to run Linux commands
```
kubectl exec -it nginx-deployment-56466d4948-78j9c bash
```

List the files and folders in the Nginx directory
```
root@nginx-deployment-56466d4948-78j9c:/# ls -ltr /etc/nginx/
total 24
-rw-r--r-- 1 root root  664 May 25 12:28 uwsgi_params
-rw-r--r-- 1 root root  636 May 25 12:28 scgi_params
-rw-r--r-- 1 root root 5290 May 25 12:28 mime.types
-rw-r--r-- 1 root root 1007 May 25 12:28 fastcgi_params
-rw-r--r-- 1 root root  648 May 25 13:01 nginx.conf
lrwxrwxrwx 1 root root   22 May 25 13:01 modules -> /usr/lib/nginx/modules
drwxr-xr-x 1 root root   26 Jun 18 22:08 conf.d
```

Check the content of the default Nginx configuration file
```
root@nginx-deployment-56466d4948-78j9c:/# cat  /etc/nginx/conf.d/default.conf 
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
```

Now, as we have got acquainted with most common Kubernetes workloads to deploy applications: 

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project22/k8s_workloads.png" width="936px" height="550px">
it is time to explore how Kubernetes is able to manage persistent data.
