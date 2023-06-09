### Ansible Roles for CI Environment

Add two more roles to ansible:

1. [SonarQube](https://www.sonarqube.org) (Scroll down to the Sonarqube section to see instructions on how to set up and configure SonarQube manually)
2. [Artifactory](https://jfrog.com/artifactory/)

#### Why do we need SonarQube?

SonarQube is an open-source platform developed by SonarSource for continuous inspection of code quality, it is used to perform automatic reviews with static analysis of code to detect bugs, [code smells](https://en.wikipedia.org/wiki/Code_smell), and security vulnerabilities. [Watch a short description here](https://youtu.be/vE39Fg8pvZg). There is a lot more hands on work ahead with SonarQube and Jenkins. So, the purpose of SonarQube will be clearer to you very soon.

#### Why do we need Artifactory?

Artifactory is a product by [JFrog](https://jfrog.com) that serves as a binary repository manager. The binary repository is a natural extension to the source code repository, in that the outcome of your build process is stored. It can be used for certain other automation, but we will it strictly to manage our build artifacts.

[Watch a short description here](https://youtu.be/upJS4R6SbgM) *Focus more on the first 10.08 mins*


### Configuring Ansible For Jenkins Deployment

In previous projects, you have been launching Ansible commands manually from a CLI. Now, with Jenkins, we will start running Ansible from Jenkins UI.

To do this,

1. Navigate to Jenkins URL

2. Install & Open Blue Ocean Jenkins Plugin

3. Create a new pipeline 

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Create-Pipeline.png" width="936px" height="550px">

4. Select GitHub

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Select-Github.png" width="936px" height="550px">

5. Connect Jenkins with GitHub

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Create-Access-Token-To-Github.png" width="936px" height="550px">

6. Login to GitHub & Generate an Access Token

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Github-Access-Token.png" width="936px" height="550px">
<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Github-Generate-Token.png" width="936px" height="550px">

7. Copy Access Token

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Copy-Token.png" width="936px" height="550px">


8. Paste the token and connect

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/JEnkins-Paste-Token-And-Connect.png" width="936px" height="550px">

9. Create a new Pipeline

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Create-Pipeline.png" width="936px" height="550px">

At this point you may not have a [Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/) in the Ansible repository, so Blue Ocean will attempt to give you some guidance to create one. But we do not need that. We will rather create one ourselves. So, click on Administration to exit the Blue Ocean console.

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Exit-Blue-Ocean.png" width="936px" height="550px">

Here is our newly created pipeline. It takes the name of your GitHub repository. 

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Ansible-Pipeline.png" width="936px" height="550px">

### Let us create our `Jenkinsfile`

Inside the Ansible project, create a new directory `deploy` and start a new file `Jenkinsfile` inside the directory.

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Ansible-Folder-Structure.png" width="936px" height="550px">

Add the code snippet below to start building the `Jenkinsfile` gradually. This pipeline currently has just one stage called `Build` and the only thing we are doing is using the `shell script` module to echo `Building Stage`


```
pipeline {
    agent any


  stages {
    stage('Build') {
      steps {
        script {
          sh 'echo "Building Stage"'
        }
      }
    }
    }
}
```

Now go back into the Ansible pipeline in Jenkins, and select configure 

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Select-Configure.png" width="936px" height="550px">

Scroll down to `Build Configuration` section and specify the location of the **Jenkinsfile** at `deploy/Jenkinsfile`

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkinsfile-Location.png" width="936px" height="550px">

Back to the pipeline again, this time click "Build now"

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Build-Now.png" width="936px" height="550px">

This will trigger a build and you will be able to see the effect of our basic `Jenkinsfile` configuration by going through the console output of the build.

To really appreciate and feel the difference of Cloud Blue UI, it is recommended to try triggering the build again from Blue Ocean interface.

1. Click on Blue Ocean

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Click-Blue-Ocean.png" width="936px" height="550px">
2. Select your project
3. Click on the play button against the branch

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Ansible-Blue-Ocean-Start-Pipeline.png" width="936px" height="550px">
Notice that this pipeline is a multibranch one. This means, if there were more than one branch in GitHub, Jenkins would have scanned the repository to discover them all and we would have been able to trigger a build for each branch. 

Let us see this in action.

1. Create a new git branch and name it `feature/jenkinspipeline-stages`
2. Currently we only have the `Build` stage. Let us add another stage called `Test`. Paste the code snippet below and push the new changes to GitHub.
   
```
   pipeline {
    agent any

  stages {
    stage('Build') {
      steps {
        script {
          sh 'echo "Building Stage"'
        }
      }
    }

    stage('Test') {
      steps {
        script {
          sh 'echo "Testing Stage"'
        }
      }
    }
    }
}

```

4. To make your new branch show up in Jenkins, we need to tell Jenkins to scan the repository.

   1. Click on the "Administration" button
   
<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Ansible-Administration-Button.png" width="936px" height="550px">
   2. Navigate to the Ansible project and click on "Scan repository now"
      ![](https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Scan-Repository-Now.png)

   3. Refresh the page and both branches will start building automatically. You can go into Blue Ocean and see both branches there too.
   ![](https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Discover-New-Branch.png)

   4. In Blue Ocean, you can now see how the `Jenkinsfile` has caused a new step in the pipeline launch build for the new branch.

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Test-Stage-Blue-Ocean.png" width="936px" height="550px">

### A QUICK TASK FOR YOU! 

    1. Create a pull request to merge the latest code into the `main branch`
    2. After merging the `PR`, go back into your terminal and switch into the `main` branch.
    3. Pull the latest change.
    4. Create a new branch, add more stages into the Jenkins file to simulate below phases. (Just add an `echo` command like we have in `build` and `test` stages)
       1. Package 
       2. Deploy 
       3. Clean up
    5. Verify in Blue Ocean that all the stages are working, then merge your feature branch to the main branch
    6. Eventually, your main branch should have a successful pipeline like this in blue ocean
    
<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project14/Jenkins-Complete-Initial-Pipeline.png" width="936px" height="550px">
