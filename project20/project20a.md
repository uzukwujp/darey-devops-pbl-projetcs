Migration to the Сloud with containerization. Part 1 - Docker & Docker Compose
============================================

Until now, you have been using VMs (AWS EC2) in Amazon Virtual Private Cloud (AWS VPC) to deploy your web solutions, and it works well in many cases. You have learned how easy to spin up and configure a new EC2 manually or with such tools as Terraform and Ansible to automate provisioning and configuration. You have also deployed two different websites on the same VM; this approach is scalable, but to some extent; imagine what if you need to deploy many small applications (it can be web front-end, web-backend, processing jobs, monitoring, logging solutions, etc.) and some of the applications will require various OS and runtimes of different versions and conflicting dependencies - in such case you would need to spin up serves for each group of applications with the exact OS/runtime/dependencies requirements. When it scales out to tens/hundreds and even thousands of applications (e.g., when we talk of microservice architecture), this approach becomes very tedious and challenging to maintain.

In this project, we will learn how to solve this problem and begin to practice the technology that revolutionized application distribution and deployment back in 2013! We are talking of Containers and imply [Docker](https://en.wikipedia.org/wiki/Docker_(software)). Even though there are other application containerization technologies, Docker is the standard and the default choice for shipping your app in a container!

**Side self study**: Before starting to work with this project, it is very important to understand what Docker is and what it is used for. To get a sufficient level of theoretical knowledge it is recommended to take Docker course on [Darey.io learning portal dashboard](https://darey.io/dashboard/) before you continue with this project.

Once you have finished the Docker course, you can proceed with this practical project!

#### Instructions On How To Submit Your Work For Review And Feedback

To submit your work for review and feedback - follow [**this instruction**](https://starter-pbl.darey.io/en/latest/submission.html).

#### Install Docker and prepare for migration to the Cloud

First, we need to install [Docker Engine](https://docs.docker.com/engine/), which is a client-server application that contains:

- A server with a long-running daemon process `dockerd`.
- APIs that specify interfaces that programs can use to talk to and instruct the Docker daemon.
- A command-line interface (CLI) client `docker`.

You can learn how to install Docker Engine on your PC [here](https://docs.docker.com/engine/install/)

Before we proceed further, let us understand why we even need to move from VM to Docker.

As you have already learned - unlike a VM, Docker allocated not the whole guest OS for your application, but only isolated minimal part of it - this isolated container has all that your application needs and at the same time is lighter, faster, and can be shipped as a Docker image to multiple physical or virtual environments, as long as this environment can run Docker engine. This approach also solves the environment incompatibility issue. It is a well-known problem when a developer sends his application to you, you try to deploy it, deployment fails, and the developer replies, _"- It works on my machine!"_. With Docker - if the application is shipped as a container, it has its own environment isolated from the rest of the world, and it will always work the same way on any server that has Docker engine.


```
      ¯\_(ﭣ)_/¯
 IT WORKS ON MY MACHINE
```

Now, when we understand the benefits we can get by using Docker containerization, let us learn what needs to be done to migrate to Docker. Read [this excellent article for some insight](https://www.accenture.com/us-en/blogs/software-engineering-blog/miha-kralj-cloud-containers).

As a part of this project, you will use a CI tool that is already well-known by you **Jenkins** - for Continous Integration (CI). So, when it is time to write `Jenkinsfile`, update your Terraform code to spin up an EC2 instance for Jenkins and run Ansible to install & configure it.

To begin our migration project from VM based workload, we need to implement a [Proof of Concept (POC)](https://en.wikipedia.org/wiki/Proof_of_concept). In many cases, it is good to start with a small-scale project with minimal functionality to prove that technology can fulfill specific requirements. So, this project will be a precursor before you can move on to deploy enterprise-grade microservice solutions with Docker. And so, Project 21 through to 30 will gradually introduce concepts and technologies as we move from POC onto enterprise level deployments.

You can start with your own workstation or spin up an EC2 instance to install Docker engine that will host your Docker containers.

Remember our Tooling website? It is a PHP-based web solution backed by a MySQL database - all technologies you are already familiar with and which you shall be comfortable using by now.

So, let us migrate the Tooling Web Application from a VM-based solution into a containerized one.



