### Packaging containerised applications into Helm Charts

In Project 22, you experienced the use of manifest files to define and deploy resources like pods, deployments, and services into Kubernetes cluster. Here, you will do the same thing except that it will not be passed through `kubectl`. In the real world, Helm is one of the most popular tools used to deploy resources into kubernetes. That is because it has a rich set of features that allows deployments to be packaged as a unit. Rather than have multiple YAML files managed individually - which can quickly become messy.

A Helm chart is a definition of the resources that are required to run an application in Kubernetes. Instead of having to think about all of the various deployments/services/volumes/configmaps/ etc that make up your application, you can use a command like

```
helm install stable/mysql
```
and Helm will make sure all the required resources are installed. In addition you will be able to tweak helm configuration by setting a single variable to a particular value and more or less resources will be deployed. For example, enabling slave for MySQL so that it can have read only replicas.

Behind the scenes, a helm chart is essentially a bunch of YAML manifests that define all the resources required by the application. Helm takes care of creating the resources in Kubernetes (where they don't exist) and removing old resources.

#### Lets begin to gradually walk through how to use Helm (Credit - https://andrewlock.net/series/deploying-asp-net-core-applications-to-kubernetes/) @igor please update the texts as much as possible to reduce plagiarism

1. Parameterising YAML manifests using Helm templates

Let's consider that our Tooling app have been Dockerised into an image called `tooling-app`, and that you wish to deploy with Kubernetes. Without helm, you would create the YAML manifests defining the deployment, service, and ingress, and apply them to your Kubernetes cluster using `kubectl apply`. Initially, your application is version 1, and so the Docker image is tagged as `tooling-app:1.0.0`. A simple deployment manifest might look something like the following:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tooling-app-deployment
  labels:
    app: tooling-app
spec:
  replicas: 3
  strategy: 
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
  selector:
    matchLabels:
      app: tooling-app
  template:
    metadata:
      labels:
        app: tooling-app
    spec:
      containers:
      - name: tooling-app
        image: "tooling-app:1.0.0"
        ports:
        - containerPort: 80
```
Now lets imagine that the developers develops another version of the toolin app, version 1.1.0. How do you deploy that? Assuming nothing needs to be changed with the service or other kubernetes objects, it may be as simple as copying the deployment manifest and replacing the image defined in the spec section. You would then re-apply this manifest to the cluster, and the deployment would be updated, performing a [rolling-update](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/).

The main problem with this is that all of the values specific to the tooling app – the labels and the image names etc – are mixed up with the entire definition of the manifest.

Helm tackles this by splitting the configuration of a chart out from its basic definition. For example, instead of hard coding the name of your app or the specific container image into the manifest, you can provide those when you install the "chart" (More on this later) into the cluster.

For example, a simple templated version of the tooling app deployment might look like the following:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-deployment
  labels:
    app: "{{ template "name" . }}"
spec:
  replicas: 3
  strategy: 
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
  selector:
    matchLabels:
      app: "{{ template "name" . }}"
  template:
    metadata:
      labels:
        app: "{{ template "name" . }}"
    spec:
      containers:
      - name: "{{ template "name" . }}"
        image: "{{ .Values.image.name }}:{{ .Values.image.tag }}"
        ports:
        - containerPort: 80
```

This example demonstrates a number of features of Helm templates:

The template is based on YAML, with {{ }} mustache syntax defining dynamic sections.
Helm provides various variables that are populated at install time. For example, the {{.Release.Name}} allows you to change the name of the resource at runtime by using the release name. Installing a Helm chart creates a release (this is a Helm concept rather than a Kubernetes concept).
You can define helper methods in external files. The {{template "name"}} call gets a safe name for the app, given the name of the Helm chart (but which can be overridden). By using helper functions, you can reduce the duplication of static values (like tooling-app), and hopefully reduce the risk of typos.

You can manually provide configuration at runtime. The {{.Values.image.name}} value for example is taken from a set of default values, or from values provided when you call helm install. There are many different ways to provide the configuration values needed to install a chart using Helm. Typically, you would use two approaches:

A values.yaml file that is part of the chart itself. This typically provides default values for the configuration, as well as serving as documentation for the various configuration values.

When providing configuration on the command line, you can either supply a file of configuration values using the `-f` flag. We will see a lot more on this later on.


**Now lets setup Helm and begin to use it.**

According to the official documentation [here](https://helm.sh/docs/intro/install/), there are different options to installing Helm. But we will build the source code to create the binary. 

1. [Download the `tar.gz` file from the project's Github release page](https://github.com/helm/helm/releases). Or simply use `wget` to download version `3.6.3` directly

```
wget https://github.com/helm/helm/archive/refs/tags/v3.6.3.tar.gz
```

2. Unpack the `tar.gz`  file
```
tar -zxvf v3.6.3.tar.gz 
```

3. cd into the unpacked directory 
```
cd helm-3.6.3
```
4. Build the source code using `make` utility

```
make build
```

If you do not have `make` installed or for any other reason, you cannot install the tool, simply use the official documentation  [here](https://helm.sh/docs/intro/install/) for other options.

5. Helm binary will be in the `bin` folder. Simply move it to the `bin` directory on your system. You cna check other tools to know where that is. fOr example, check where `pwd` utility is being called from by running `which pwd`. Assuming the output is `/usr/local/bin`. You can move the `helm` binary there.

```
sudo mv bin/helm /usr/local/bin/
```

6. Check that Helm is installed

`helm version`
```
version.BuildInfo{Version:"v3.6+unreleased", GitCommit:"13f07e8adbc57b0e3f96b42340d6f44bdc8d5016", GitTreeState:"dirty", GoVersion:"go1.15.5"}
```

#### Deploy Jenkins with Helm

Before we begin to develop our own helm charts, lets make use of publicly available charts to deploy all the tools that we need.

One of the amazing things about helm is the fact that you can deploy applications that are already packaged from a public helm repository directly with very minimal configuration. An example is **Jenkins**.

1. Visit [Artifact Hub](https://artifacthub.io/packages/search) to find packaged applications as Helm Charts
2. Search for Jenkins
3. Add the repository to helm so that you can easily download and deploy
```
helm repo add jenkins https://charts.jenkins.io
```
4. Update helm repo
```
helm repo update 
```
5. Install the chart 
```
helm install [RELEASE_NAME] jenkins/jenkins --kubeconfig [kubeconfig file]
```
You should see an output like this 

```
NAME: jenkins
LAST DEPLOYED: Sun Aug  1 12:38:53 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
1. Get your 'admin' user password by running:
  kubectl exec --namespace default -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo
2. Get the Jenkins URL to visit by running these commands in the same shell:
  echo http://127.0.0.1:8080
  kubectl --namespace default port-forward svc/jenkins 8080:8080

3. Login with the password from step 1 and the username: admin
4. Configure security realm and authorization strategy
5. Use Jenkins Configuration as Code by specifying configScripts in your values.yaml file, see documentation: http:///configuration-as-code and examples: https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos

For more information on running Jenkins on Kubernetes, visit:
https://cloud.google.com/solutions/jenkins-on-container-engine

For more information about Jenkins Configuration as Code, visit:
https://jenkins.io/projects/jcasc/


NOTE: Consider using a custom image with pre-installed plugins
```

6. Check the Helm deployment

```
helm ls --kubeconfig [kubeconfig file]
```
Output:
```
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
jenkins default         1               2021-08-01 12:38:53.429471 +0100 BST    deployed        jenkins-3.5.9   2.289.3 
```

7. Check the pods

```
kubectl get pods --kubeconfig [kubeconfig file]
```
Output: 
```
NAME        READY   STATUS    RESTARTS   AGE
jenkins-0   2/2     Running   0          6m14s
```

8. Describe the running pod (review the output and try to understand what you see)
```
kubectl describe pod jenkins-0 --kubeconfig [kubeconfig file]
```

9. Check the logs of the running pod

```
kubectl logs jenkins-0 --kubeconfig [kubeconfig file]
```

You will notice an output with an error

```
error: a container name must be specified for pod jenkins-0, choose one of: [jenkins config-reload] or one of the init containers: [init]
```

This is because the pod has a [Sidecar container](https://www.magalix.com/blog/the-sidecar-pattern) alongside with the Jenkins container. As you can see fromt he error output, there is a list of containers inside the pod `[jenkins config-reload]` i.e `jenkins` and `config-reload` containers. The job of the config-reload is mainly to help Jenkins to reload its configuration without recreating the pod.

Therefore we need to let `kubectl` know, which pod we are interested to see its log. Hence, the command will be updated like:
```
kubectl logs jenkins-0 -c jenkins --kubeconfig [kubeconfig file]
```

10. Now lets avoid calling the `[kubeconfig file]` everytime. Kubectl expects to find the default kubeconfig file in the location `~/.kube/config`. But what if you already have another cluster using that same file? It doesn't make sense to overwrite it. What you will do is to merge all the kubeconfig files together using a kubectl plugin called `[konfig](https://github.com/corneliusweig/konfig)` and select whichever one you need to be active.

      1. Install a package manager for kubectl called [krew](https://krew.sigs.k8s.io/docs/user-guide/setup/install/) so that it will enable you to install plugins to extend the functionality of kubectl. Read more about it `[Here](https://github.com/kubernetes-sigs/krew)` 
     
      2. Install the `[konfig plugin](https://github.com/corneliusweig/konfig)` 
          ```
          kubectl krew install konfig
          ```
      3. Import the kubeconfig into the default kubeconfig file. Ensure to accept the prompt to overide.
          ```
          sudo kubectl konfig import --save  [kubeconfig file]
          ```
      4. Show all the contexts - Meaning all the clusters configured in your kubeconfig. If you have more than 1 Kubernetes clusters configured, you will see them all in the output.
          ```
          kubectl config get-contexts
          ```
      5. Set the current context to use for all kubectl and helm commands
          ```
          kubectl config use-context [name of EKS cluster]
          ```
      6. Test that it is working without specifying the `--kubeconfig` flag
          ```
          kubectl get po
          ```
          Output:
          ```
          NAME        READY   STATUS    RESTARTS   AGE
          jenkins-0   2/2     Running   0          84m
          ```
      7. Display the current context. This will let you know the context in which you are using to interact with Kubernetes.
          ```
          kubectl config current-context
          ```

11. Now that we can use `kubectl` without the `--kubeconfig` flag, Lets get access to the Jenkins UI. (*In later projects we will further configure Jenkins. For now, it is to set up all the tools we nee*d)
    1.  There are some commands that was provided on the screen when Jenkins was installed with Helm. See number 5 above. Get the password to the `admin` user
          ```
          kubectl exec --namespace default -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo
          ```
    2. Use port forwarding to access Jenkins from the UI 
          ```
          kubectl --namespace default port-forward svc/jenkins 8080:8080
          ```
          <img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project24/Jenkins-Port-forward.png" width="936px" height="550px">
    3. Go to the browser `localhost:8080` and authenticate with the username and password from number 1 above
          <img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project24/Jenkins-UI.png" width="936px" height="550px">

#### Now setup the following tools using Helm

This section will be quite challenging for you because you will need to spend some time to research the charts, read their documentations and understand how to get an application running in your cluster by simply running a helm install command.

1. Artifactory
2. Hashicorp Vault
3. Prometheus
4. Grafana
5. Elasticsearch ELK using [ECK](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-install-helm.html)

Succesfully installing all the 5 tools is a great experience to have. But, joining the [Masterclass](darey.io/masterclass) you will be able to see how this should be done end to end.

In the next project, you will have experience;

1. Deploying Ingress Controller
2. Configuring Ingress for all the tools and applications running in the cluster
3. Implementing TLS with applications running inside Kubernetes using Cert-manager
