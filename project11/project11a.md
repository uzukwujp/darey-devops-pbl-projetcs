# Ansible Configuration Management - Automate Project 7 to 10 

You have been implementing some interesting projects up until now, and that is awesome.

In Projects 7 to 10 you had to perform a lot of manual operations to set up virtual servers, install and configure required software and deploy your web application.

This Project will make you appreciate DevOps tools even more by making most of the routine tasks automated with [Ansible](https://en.wikipedia.org/wiki/Ansible_(software)) [Configuration Management](https://www.redhat.com/en/topics/automation/what-is-configuration-management#:~:text=Configuration%20management%20is%20a%20process,in%20a%20desired%2C%20consistent%20state.&text=Managing%20IT%20system%20configurations%20involves,building%20and%20maintaining%20those%20systems.), at the same time you will become confident with writing code using declarative languages such as [`YAML`](https://en.wikipedia.org/wiki/YAML).

Let us get started!

#### Instructions On How To Submit Your Work For Review And Feedback

To submit your work for review and feedback - follow [**this instruction**](https://starter-pbl.darey.io/en/latest/submission.html).

#### Ansible Client as a Jump Server (Bastion Host)

A [**Jump Server**](https://en.wikipedia.org/wiki/Jump_server) (sometimes also referred as [**Bastion Host**](https://en.wikipedia.org/wiki/Bastion_host)) is an intermediary server through which access to internal network can be provided. If you think about the current architecture you are working on, ideally, the webservers would be inside a secured network which cannot be reached directly from the Internet. That means, even DevOps engineers cannot `SSH` into the Web servers directly and can only access it through a Jump Server - it provides better security and reduces [attack surface](https://en.wikipedia.org/wiki/Attack_surface).

On the diagram below the Virtual Private Network (VPC) is divided into [two subnets](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html) - Public subnet has public IP addresses and Private subnet is only reachable by private IP addresses.

![](https://dareyio-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project11/bastion.png)

When you get to [Project 15](https://dareyio-pbl-expert.readthedocs-hosted.com/en/latest/project15.html), you will see a Bastion host in proper action. But for now, we will develop **Ansible** scripts to simulate the use of a `Jump box/Bastion host` to access our Web Servers.

#### Tasks

- Install and configure Ansible client to act as a Jump Server/Bastion Host
- Create a simple Ansible playbook to automate servers configuration





