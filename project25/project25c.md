Deploying Ingress Controller and managing Ingress Resources
============================

Before we discuss what ingress controllers are, it will be important to start off understanding about the **Ingress** resource.

An ingress is an API object that manages external access to the services in a kubernetes cluster. It is capable to provide load balancing, SSL termination and name-based virtual hosting. In otherwords, Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource.

Here is a simple example where an Ingress sends all its traffic to one Service:

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/ingress.svg" width="936px" height="550px">
*image credit:* kubernetes.io

An ingress resource for Artifactory would like like below

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: artifactory
spec:
  ingressClassName: nginx
  rules:
  - host: "tooling.artifactory.sandbox.svc.darey.io"
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: artifactory
            port:
              number: 8082
```

- An Ingress needs `apiVersion`, `kind`, `metadata` and `spec` fields
- The name of an Ingress object must be a valid DNS subdomain name
- Ingress frequently uses annotations to configure some options depending on the Ingress controller.
- Different Ingress controllers support different annotations. Therefore it is important to be up to date with the ingress controller's specific documentation to know what annotations are supported.
- It is recommended to always specify the ingress class name with the spec `ingressClassName: nginx`. This is how the Ingress controller is selected, especially when there are multiple configured ingress controllers in the cluster.
- The domain `darey.io` should be replaced with your own domain. 

## Ingress controller

If you deploy the yaml configuration specified for the ingress resource without an ingress controller, it will not work. In order for the Ingress resource to work, the cluster must have an ingress controller running.

Unlike other types of controllers which run as part of the kube-controller-manager. Such as the **Node Controller**, **Replica Controller**, **Deployment Controller**, **Job Controller**, or **Cloud Controller**. Ingress controllers are not started automatically with the cluster. 

Kubernetes as a project supports and maintains [AWS](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/), [GCE](https://github.com/kubernetes/ingress-gce/blob/master/README.md#readme), and [NGINX](https://github.com/kubernetes/ingress-nginx/blob/main/README.md#readme) ingress controllers.

There are many other 3rd party Ingress controllers that provide similar functionalities with their own unique features, but the 3 mentioned earlier are currently supported and maintained by Kubernetes. Some of these other 3rd party Ingress controllers include but not limited to the following;

- [AKS Application Gateway Ingress Controller](https://docs.microsoft.com/en-gb/azure/application-gateway/tutorial-ingress-controller-add-on-existing) (**Microsoft Azure**)
- [Istio](https://istio.io/latest/docs/tasks/traffic-management/ingress/kubernetes-ingress/)
- [Traefik](https://doc.traefik.io/traefik/providers/kubernetes-ingress/)
- [Ambassador](https://www.getambassador.io/)
- [HA Proxy Ingress](https://haproxy-ingress.github.io/)
- [Kong](https://docs.konghq.com/kubernetes-ingress-controller/)
- [Gloo](https://docs.solo.io/gloo-edge/latest/)

An example comparison matrix of some of the controllers can be found [here](https://kubevious.io/blog/post/comparing-top-ingress-controllers-for-kubernetes#comparison-matrix). Understanding their unique features will help businesses determine which product works well for their respective requirements.

It is possible to deploy any number of ingress controllers in the same cluster. That is the essence of an **ingress class**. By specifying the spec `ingressClassName` field on the ingress object, the appropriate ingress controller will be used by the ingress resource.

Lets get into action and see how all of these fits together.

### Deploy Nginx Ingress Controller

On this project, we will deploy and use the **Nginx Ingress Controller**. It is always the default choice when starting with Kubernetes projects. It is reliable and easy to use.

Since this controller is maintained by Kubernetes, there is an official guide the installation process. Hence, we wont be using **artifacthub.io** here. Even though you can still find ready to go charts there, it just makes sense to always use the [official guide](https://kubernetes.github.io/ingress-nginx/deploy/) in this scenario.

Using the **Helm** approach, according to the official guide;

1. Install Nginx Ingress Controller in the `ingress-nginx` namespace
```
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

**Notice**:  

This command is idempotent:

- if the ingress controller is not installed, it will install it,
- if the ingress controller is already installed, it will upgrade it.

- **Self Challenge Task** - Delete the installation after running above command. Then try to re-install it using a slightly different method you are already familiar with. Ensure NOT to use the flag `--repo`
- **Hint** - Run the `helm repo add command` before installation

2. A few pods should start in the ingress-nginx namespace:

```
kubectl get pods --namespace=ingress-nginx
```

3. After a while, they should all be running. The following command will wait for the ingress controller pod to be up, running, and ready:

```
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

4. Check to see the created load balancer in AWS.
```
   kubectl get service -n ingress-nginx
```
Output:
```
NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP                                                              PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   172.16.11.35    a38db84e7d2104dc4b743ee6df1e667b-954094141.eu-west-2.elb.amazonaws.com   80:32516/TCP,443:31942/TCP   50s
ingress-nginx-controller-admission   ClusterIP      172.16.94.137   <none>                                                                   443/TCP                      50s
```

The `ingress-nginx-controller` service that was created is of the type `LoadBalancer`. That will be the load balancer to be used by all applications which require external access, and is using this ingress controller.

If you go ahead to AWS console, copy the address in the **EXTERNAL-IP** column, and search for the loadbalancer, you will see an output like below.

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/ingress-classic-load-balancer.png" width="936px" height="550px">

5. Check the IngressClass that identifies this ingress controller.

```
kubectl get ingressclass -n ingress-nginx
```
Output:
```
NAME    CONTROLLER             PARAMETERS   AGE
nginx   k8s.io/ingress-nginx   <none>       105s
```

### Deploy Artifactory Ingress

Now, it is time to configure the ingress so that we can route traffic to the Artifactory internal service, through the ingress controller's load balancer.

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/ingress.svg" width="936px" height="550px">
Notice the `spec` section with the configuration that selects the ingress controller using the **ingressClassName** 

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: artifactory
spec:
  ingressClassName: nginx
  rules:
  - host: "tooling.artifactory.sandbox.svc.darey.io"
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: artifactory
            port:
              number: 8082
```

```
kubectl apply -f <filename.yaml> -n tools
```

Output:
```
NAME          CLASS   HOSTS                                   ADDRESS                                                                  PORTS   AGE
artifactory   nginx   tooling.artifactory.sandbox.svc.darey.io   a38db84e7d2104dc4b743ee6df1e667b-954094141.eu-west-2.elb.amazonaws.com   80      5s
```

Now, take note of

- CLASS - The nginx controller class name `nginx`
- HOSTS - The hostname to be used in the browser `tooling.artifactory.sandbox.svc.darey.io`
- ADDRESS - The loadbalancer address that was created by the ingress controller

## Configure DNS

If anyone were to visit the tool, it would be very inconvenient sharing the long load balancer address. Ideally, you would create a DNS record that is human readable and can direct request to the balancer. This is exactly what has been configured in the ingress object `- host: "tooling.artifactory.sandbox.svc.darey.io"` but without a DNS record, there is no way that host address can reach the load balancer.

The `sandbox.svc.darey.io` part of the domain is the configured **HOSTED ZONE** in AWS. So you will need to configure Hosted Zone in AWS console or as part of your infrastructure as code using terraform. 

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/hosted-zone.png" width="936px" height="550px">
If you purchased the domain directly from AWS, the hosted zone will be automatically configured for you. But if your domain is registered with a different provider such as **freenon** or **namechaep**, you will have to create the hosted zone and update the name servers.

### Create Route53 record

Within the hosted zone is where all the necessary DNS records will be created. Since we are working on Artifactory, lets create the record to point to the ingress controller's loadbalancer. There are 2 options. You can either use the *CNAME* or AWS *Alias*

#### **CNAME Method**

1. Select the **HOSTED ZONE** you wish to use, and click on the create record button
   
  <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/create-r53-record-1.png" width="936px" height="550px">
2. Add the subdomain `tooling.artifactory`, and select the record type `CNAME`
  <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/create-r53-record--cname.png" width="936px" height="550px">
3. Successfully created record
   <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/create-r53-record-cname-2.png" width="936px" height="550px">
4. Confirm that the DNS record has been properly propergated. Visit https://dnschecker.org and check the record. Ensure to select CNAME. The search should return green ticks for each of the locations on the left.
   ![](https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/dns-checker.png)

#### **AWS Alias Method**

1. In the create record section, type in the record name, and toggle the `alias` button to enable an alias. An alias is of the `A` DNS record type which basically routes directly to the load balancer. In the `choose endpoint` bar, select `Alias to Application and Classic Load Balancer`
 
  <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/create-r53-record-alias-1.png" width="936px" height="550px">

2. Select the region and the load balancer required. You will not need to type in the load balancer, as it will already populate.

  <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/create-r53-record-alias-2.png" width="936px" height="550px">

For detailed read on selecting between CNAME and Alias based records, read the [official documentation](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-choosing-alias-non-alias.html)

### Visiting the application from the browser

So far, we now have an application running in Kubernetes that is also accessible externally. That means if you navigate to https://tooling.artifactory.sandbox.svc.darey.io/ (*replace the full URL with your domain*), it should load up the artifactory application. 

Using Chrome browser will show something like the below. It shows that the site is indeed reachable, but insecure. This is because Chrome browsers do not load insecure sites by default. It is insecure because it either does not have a trusted TLS/SSL certificate, or it doesn't have any at all.

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/insecure-web.png" width="936px" height="550px">
Nginx Ingress Controller does configure a default TLS/SSL certificate. But it is not trusted because it is a self signed certificate that browsers are not aware of.

To confirm this,

1. Click on the **Not Secure** part of the browser.
   
<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/insecure-web-2.png" width="936px" height="550px">
2. Select the **Certificate is not valid** menu
    <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/insecure-web-3.png" width="936px" height="550px">
3. You will see the details of the certificate. There you can confirm that yes indeed there is encryption configured for the traffic, the browser is just not cool with it.
    
   <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/insecure-web-4.png" width="936px" height="550px">
Now try another browser. For example Internet explorer or Safari

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/insecure-web-5.png" title="Safari" width="936px" height="550px">
<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/insecure-web-6.png" title="Microsoft Edge" width="936px" height="550px">


### Explore Artifactory Web UI
Now that we can access the application externally, although insecure, its time to login for some exploration. Afterwards we will make it a lot more secure and access our web application on any browser.

1. Get the default username and password - Run a helm command to output the same message after the initial install
    
```
helm test artifactory -n tools
```
Output:
```
NAME: artifactory
LAST DEPLOYED: Sat May 28 09:26:08 2022
NAMESPACE: tools
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Congratulations. You have just deployed JFrog Artifactory!

1. Get the Artifactory URL by running these commands:

   NOTE: It may take a few minutes for the LoadBalancer IP to be available.
         You can watch the status of the service by running 'kubectl get svc --namespace tools -w artifactory-artifactory-nginx'
   export SERVICE_IP=$(kubectl get svc --namespace tools artifactory-artifactory-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
   echo http://$SERVICE_IP/

2. Open Artifactory in your browser
   Default credential for Artifactory:
   user: admin
   password: password
```

2. Insert the username and password to load the Get Started page
  <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/artifactory-get-started-1.png" width="936px" height="550px">

3. Reset the admin password
    
    <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/artifactory-get-started-2.png" width="936px" height="550px"> 

4. Activate the Artifactory License. You will need to purchase a license to use Artifactory enterprise features. 
    
   <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/artifactory-get-started-3.png" width="936px" height="550px">

5. For learning purposes, you can apply for a free trial license. [Simply fill the form here](https://jfrog.com/start-free/) and a license key will be delivered to your email in few minutes.
   
 <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/Artifactory-License.png" width="936px" height="550px">

  <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/artifactory-get-started-4.png" width="936px" height="550px"> 

6. In exactly 1 minute, the license key had arrived. Simply copy the key and apply to the console.

  <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/artifactory-get-started-5.png" width="936px" height="550px">  

7. Set the Base URL. Ensure to use `https`
  
  <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/artifactory-get-started-6.png" width="936px" height="550px"> 

8. Skip the Proxy setting 
  <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/artifactory-get-started-7.png" width="936px" height="550px">
   
9. Skip creation of repositories for now. You will create them yourself later on.
      
  <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/artifactory-get-started-8.png" width="936px" height="550px">

10. finish the setup
     
   <img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/artifactory-get-started-9.png" width="936px" height="550px"> 
  
<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project25/artifactory-get-started-11.png" width="936px" height="550px">

Next, its time to fix the TLS/SSL configuration so that we will have a trusted **HTTPS** URL
