## Jenkins Pipelines for Terraform

Here comes the real meat of this project where you will experience CI/CD pipeline for Terraform.

The first question that may come to your mind is "why do we need to have CI/CD for our infrastructure?", "I thought CI/CD is for the software code that developers write?" - Well you are correct if you have thought of those questions. But treating the  infrastructure in which the software is being operated can also be treated in similar manner, especially now that we can have the entire infrastructure as code through "Terraform".

Treating our infrastructure the same way we would treat our software presents a set of benefits such as:

1. Automating the release of features into our cloud infrastructure
2. Experiencing a fast feedback loop for infrastructure changes
3. Continous testing of our infrastructure
4. Collaboration and Team Productivity
5. Rapid Release Cycle and
6. Risk Reduction in production

Now lets go through the entire process and see how it can be achieved with Jenkins.

### Set up Git repository with Terraform code

The use case we will satisfy is that 

1. Your terraform code has an existing set of resources that it creates in your preferred cloud provider.
2. You as a DevOps engineer intend to create an additional resource by updating the code base with the new resource that needs to be created.

Therefore, the first logical thing to have is an existing terraform code. 

If you don't have your own code, you can simply use this github link and fork the repository into your own github account https://github.com/darey-devops/terraform-aws-pipeline.git 
    - It creates Networking later
    - It provisions kubernetes cluster using EKS

Then do the following to test that the code can create existing resources;

1. The `provider.tf` file has an S3 backend configuration. You will need to create your own bucket and update the code
    - Create an S3 bucket in your AWS account
    - Update the bucket name from the backend configuration
2. Push your latest changes to Github
3. Run terraform init, plan and apply and confirm everything works fine



### Connect the Github repository to Jenkins

1. Install Jenkins GitHub Plugin:

 - Open Jenkins in your web browser (http://localhost:8080).

- Navigate to "Manage Jenkins" -> "Plugins".
![Alt text](images/jenkins-plugin.png)

- Click on Available plugins
  ![Alt text](images/available-jenkins-plugins.png)

- Scroll down and select the "Github Integration" plugin for installation

  ![Alt text](images/jenkins-github-integration-plugin.png)
  
- If everything is successful, then click to restart Jenkins

![Alt text](images/restart-jenkins.png)

**Note**: You may need to refresh your browser if the restart takes a long time. If this happens, your docker container may exit and Jenkins will no longer load in your browser.

- Go to your terminal and check the status of the container using `docker ps -a` command
   
```
docker ps -a
CONTAINER ID   IMAGE                  COMMAND                  CREATED        STATUS                     PORTS                       NAMES
800f8f48466b   jenkins-server         "/usr/bin/tini -- /u…"   7 days ago     Exited (5) 8 minutes ago                               jenkins-server
   ```


- Take the container ID and simply restart it

```
docker restart 800f8f48466b
```

- Check the status of the container again and it should be back up.
- Then go back to the browser and access Jenkins.

- Back in Jenkins UI, navigate to the **"Installed plugins"** section and you should now see the newly installed plugin and it is enabled
  ![Alt text](images/installed-github-plugin-jenkins.png)

This plugin basically connects Jenkins, with GitHub. It allows Jenkins to automatically perform tasks like building and testing code whenever changes are made in a GitHub repository.

Next is to configure github credentials in Jenkins so that Jenkins can authenticate to the repository.

## Install more plugins

To ensure a seamless and efficient pipeline within Jenkins, It is recommended to install additional essential plugins: the Terraform and the AWS Credentials plugin.

- Terraform Plugin:

The Terraform plugin for Jenkins enables seamless integration of Terraform into Jenkins pipelines. With this plugin, you can manage the installation of mutliple terraform versions, update terraform modules and do much more as documented in the official site https://plugins.jenkins.io/terraform/

- AWS Credentials Plugin:

The AWS Credentials plugin is essential for securely managing and utilizing AWS (Amazon Web Services) credentials within Jenkins. This plugin facilitates the secure storage and retrieval of AWS access and secret keys, ensuring that Jenkins jobs and pipelines can securely interact with AWS services during the execution of various tasks and deployments, including terraform runs. You can read more about the plugin here https://plugins.jenkins.io/aws-credentials/


## Configure GitHub Credentials in Jenkins:
   Jenkins needs to know how to connect to Github, otherwise in real world cases where repositories are private, it won't know how to access the repository. Hence, the first thing we need to do is to store the github credentials in Jenkins.
   
    - In Github, navigate to your profile -> Click on "Settings" -> then scroll down to -> "Developer Settings"
  
    ![Alt text](images/github-developer-settings.png)

   - Generate an access token 
    ![Alt text](images/generate-github-access-token-1.png)
    ![Alt text](images/generate-github-access-token-2.png)
    ![Alt text](images/generate-github-access-token-3.png)

  - Copy the access token and save in a notepad for use later
  ![Alt text](images/copy-access-token.png)


    - In Jenkins, navigate to "Manage Jenkins" -> Click on "Credentials"

        ![Alt text](images/jenkins-credentials.png)
    - Click on the arrow next to "global" and select "Add credentials"
        ![Alt text](images/add-jenkiins-credentials.png)
     - Select username and password. Use the Access token generated earlier as your password, and specify the anything descriptive as your ID
        ![Alt text](images/jenkins-credential-password.png)
    - In the credentials section, you will be able to see the created credential
        ![Alt text](images/jenkiins-credentials-view.png)
    - Create a second credential for AWS secret and access key. If you have installed the AWS credentials plugin, you will see the "AWS Credentials" Kind as shown below. Simply add the AWS secret and access key generated from AWS console.  If you need a reminder on how to create an IAM user Access and secrete key in AWS console, [click here](https://youtu.be/HuE-QhrmE1c)
        ![Alt text](images/aws-credentials.png)



1. Set Up a Jenkins Multibranch Pipeline:

- From the Jenkins dashboard, click on "New Item"
  ![Alt text](image.png)

- Give it a name and description
  ![Alt text](image-1.png)

- Select the type of source of the code and the Jenkinsfile

  ![Alt text](image-2.png)

- Select the credentials to be used to connect to Github from Jenkins
  ![Alt text](image-3.png)

- Add the repository URL. Ensure you have forked it from https://github.com/darey-devops/terraform-aws-pipeline.git/

  ![Alt text](image-4.png)

- Leave everything at default and hit save 
  ![Alt text](image-5.png)

- You will immediately see the scanning of the repository for branches, and the Jenkinsfile 
  ![Alt text](image-6.png)

- The terraform-cicd pipeline and main branch scanned
  ![Alt text](image-7.png)

- Pipeline run and Console output
  ![Alt text](image-8.png)


- Click on "Build now" for a second run and check the console output

  ![Alt text](image-9.png)


- Show the plan and decide to proceed to apply or abort
  ![Alt text](image-10.png)


## Now lets talk about the Jenkinsfile:

The Jenkinsfile pipeline automates the process of code checkout, planning infrastructure changes with Terraform, and conditionally applying those changes. It's designed to ensure that changes to infrastructure (managed by Terraform) are reviewed and applied systematically, with an additional manual check before applying changes to critical environments like production.

Let's break down each section. Open the Jenkins file in a separate tab and follow the next sections carefully.

### Pipeline

`pipeline { ... }`: This is the wrapper for the entire pipeline script. Everything that defines what the pipeline does is included within these braces.

### Agent

`agent any`: This line specifies that the pipeline can run on any available agent. In Jenkins, an agent is a worker that executes the job. 'Any' means it doesn't require a specific agent configuration.

### Environment

`environment { ... }`: This section is used to define environment variables that are applicable to all stages of the pipeline.

`TF_CLI_ARGS = '-no-color'`: Sets an environment variable for Terraform. It tells Terraform to not colorize its output, which can be useful for logging and readability in CI/CD environments. feel free to change this value as you wish

### Stages
`stages { ... }`: This block defines the various stages of the pipeline. Each stage is a step in the pipeline process.

#### Stage: Checkout
`stage('Checkout') { ... }`: This is the first stage, named 'Checkout'. It's typically used to check out source code from a version control system.

`checkout scm`: Checks out source code from the Source Control Management (SCM) system configured for the job (In this case, **Git**).



#### Stage: Terraform Plan

`stage('Terraform Plan') { ... }`: This stage is responsible for running a Terraform plan.

`withCredentials([aws(...)]) { ... }`: This block securely injects AWS credentials into the environment.

`sh 'terraform init'`: Initializes Terraform in the current directory.

`sh 'terraform plan -out=tfplan'`: Runs Terraform plan and outputs the plan to a file named 'tfplan'.


#### Stage: Terraform Apply
`stage('Terraform Apply') { ... }`: This stage applies the changes from Terraform plan to make infrastructure changes.

`when { ... }`: This block sets conditions for executing this stage.
`expression { env.BRANCH_NAME == 'main' }`: This condition checks if the pipeline is running on the `main` branch.

`expression { ... }`: Checks if the build was triggered by a user action.

`input message: 'Do you want to apply changes?', ok: 'Yes'`: A manual intervention step asking for confirmation before proceeding. If `yes` is clicked, it runs the `terraform init & apply` otherwise, the pipeline is aborted.

![Alt text](image-11.png)




# Task
## Enhance and Extend the Pipeline

### Objective: 
Update the existing pipeline script to include additional stages and improve the existing ones. This will encompass adding new functionality, improving code clarity, and ensuring best practices in CI/CD pipelines.

1. Create a new branch from the main branch and scan the Jenkins pipeline so that the new branch can be discoverred. 
   
2. In the new branch, Correct and Enhance the 'Terraform Apply' Stage The current **'Terraform Apply'** stage mistakenly contains a `sh 'terraform aply -out=tfplan'` command. Correct this to `sh 'terraform apply tfplan'`.

3. Add logging to track the progress of the pipeline within both Terraform plan & apply. Use the `echo` command to print messages before and after each execution so that in the console output everyone can understand what is happening at each stage.

4. Introduce a new stage in the pipeline script to validate the Terraform configurations using terraform validate command. Add the 'Lint Code' Stage, Place this stage before the 'Terraform Plan' stage.
The purpose of this stage is to validate the syntax, consistency, and correctness of Terraform configuration files in the directory it is run. It does not access any remote services.


5. Introduce a 'Cleanup' Stage

Add a final stage named 'Cleanup' that runs regardless of whether previous stages succeeded or failed (use the post directive).
In this stage, include commands to clean up any temporary files or state that the pipeline may have created. [Here is documentation ](https://www.jenkins.io/doc/book/pipeline/syntax/#post) on Jenkinsfile "Post" directive 

5. Implement Error Handling

Add error handling to the pipeline. For instance, if 'Terraform Apply' fails, the pipeline should handle this gracefully, perhaps by sending a notification or logging detailed error messages.

6. Document the Pipeline

Add comments to the pipeline script explaining each stage and important commands. This will make the pipeline more maintainable and understandable.

Deliverables

Updated Jenkins pipeline script incorporating the above enhancements.
A brief report explaining the changes made and why they are beneficial.
(Optional) Any challenges faced during the task and how they were overcome.

Congratulations!



