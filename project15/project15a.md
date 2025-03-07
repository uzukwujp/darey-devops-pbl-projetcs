AWS Cloud Solution For 2 Company Websites Using A Reverse Proxy Technology 
============================================

**WARNING**: This infrastructure set up is **NOT** covered by AWS free tier. Therefore, ensure to **DELETE  ALL** the resources created immediately after finishing the project. Monthly cost may be shockingly high if resources are not deleted. Also, it is strongly recommended to set up a budget and configure notifications when your spendings reach a predefined limit. Watch [this video](https://www.youtube.com/watch?v=fvz0cphjHjg) to learn how to configure AWS budget.

#### Instructions On How To Submit Your Work For Review And Feedback

To submit your work for review and feedback - follow [**this instruction**](https://starter-pbl.darey.io/en/latest/submission.html).

#### Let us Get Started

You have been doing great work so far - implementing different Web Solutions and getting hands on experience with many great DevOps tools. In previous projects you used basic [Infrastructure as a Service (IaaS)](https://en.wikipedia.org/wiki/Infrastructure_as_a_service) offerings from AWS such as [EC2 (Elastic Compute Cloud)](https://en.wikipedia.org/wiki/Amazon_Elastic_Compute_Cloud) as rented Virtual Machines and [EBS (Elastic Block Store)](https://en.wikipedia.org/wiki/Amazon_Elastic_Block_Store), you have also learned how to configure [Key pairs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) and basic [Security Groups](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html).

But the power of Clouds is not only in being able to rent Virtual Machines - it is much more than that. From now on, you will start gradually study different Cloud concepts and tools on example of AWS, but do not be worried, your knowledge will not be limited to only AWS specific concepts - overall principles are common across most of the major Cloud Providers (e.g., [Microsoft Azure](https://azure.microsoft.com/en-us/) and [Google Cloud Platform](https://cloud.google.com)).

***NOTE:*** The next few projects will be implemented manually. Before you begin to automate infrastructure in the cloud, it is very important that you can build the solution manually. Otherwise, programming your automation may become frustrating very quickly.

You will build a secure infrastructure inside AWS [VPC (Virtual Private Cloud)](https://en.wikipedia.org/wiki/Amazon_Virtual_Private_Cloud) network for a fictitious company (*Choose an interesting name for it*) that uses [**WordPress CMS**](https://wordpress.com) for its main business website, and a **Tooling Website** (`https://github.com/<your-name>/tooling`) for their DevOps team. As part of the company's desire for improved security and performance, a decision has been made to use a [reverse proxy technology from **NGINX**](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/) to achieve this. 

Cost, Security, and Scalability are the major requirements for this project. Hence, implementing the architecture designed below, ensure that infrastructure for both websites, WordPress and Tooling, is resilient to Web Server's failures, can accomodate to increased traffic and, at the same time, has reasonable cost.

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project15/tooling_project_15.png" width="936px" height="550px">
#### Starting Off Your AWS Cloud Project

There are few requirements that must be met before you begin:

1. Properly configure your AWS account and Organization Unit [Watch How To Do This Here](https://youtu.be/9PQYCc_20-Q)

    * Create an [AWS Master account](https://aws.amazon.com/free/). (*Also known as Root Account*)
    * Within the Root account, create a sub-account and name it **DevOps**. (You will need another email address to complete this) 
    * Within the Root account, create an **AWS Organization Unit (OU)**. Name it **Dev**. (We will launch Dev resources in there)
    * Move the **DevOps** account into the ***Dev*** **OU**.
    * Login to the newly created AWS account using the new email address.

2. Create a free domain name for your fictitious company at Freenom domain registrar [here](https://www.freenom.com).

3. Create a hosted zone in AWS, and map it to your free domain from Freenom. [Watch how to do that here](https://youtu.be/IjcHp94Hq8A) 

***NOTE*** : As you proceed with configuration, ensure that all resources are appropriately tagged, for example:

* Project: `<Give your project a name>`
* Environment: `<dev>`
* Automated: `<No>` (If you create a recource using an automation tool, it would be `<Yes>`)



