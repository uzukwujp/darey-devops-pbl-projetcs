### Migrate your `.tf` codes to Terraform Cloud

Le us explore how we can migrate our codes to Terraform Cloud and manage our AWS infrastructure from there:

1. Create a Terraform Cloud account

Follow [this link](https://app.terraform.io/signup/account), create a new account, verify your email and you are ready to start

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project19/terraform_cloud_welcome.png" width="936px" height="550px">
Most of the features are free, but if you want to explore the difference between free and paid plans - you can check it on [this page](https://www.hashicorp.com/products/terraform/pricing).

2. Create an organization

Select "Start from  scratch", choose a name for your organization and create it.

3. Configure a workspace

Before we begin to configure our workspace - watch [this part of the video](https://youtu.be/m3PlM4erixY?t=287) to better understand the difference between `version control workflow`, `CLI-driven workflow` and `API-driven workflow` and other configurations that we are going to implement.

We will use `version control workflow` as the most common and recommended way to run Terraform commands triggered from our git repository.

Create a new repository in your GitHub and call it `terraform-cloud`, push your Terraform codes developed in the previous projects to the repository.

Choose `version control workflow` and you will be promped to connect your GitHub account to your workspace - follow the prompt and add your newly created repository to the workspace.

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project19/terraform_cloud_github.png" width="936px" height="550px">
Move on to "Configure settings", provide a description for your workspace and leave all the rest settings default, click "Create workspace".

4. Configure variables

Terraform Cloud supports two types of variables: environment variables and Terraform variables. Either type can be marked as sensitive, which prevents them from being displayed in the Terraform Cloud web UI and makes them write-only.

Set two environment variables: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, set the values that you used in [Project 16](https://expert-pbl.darey.io/en/latest/project16.html). These credentials will be used to privision your AWS infrastructure by Terraform Cloud.

After you have set these 2 environment variables - yout Terraform Cloud is all set to apply the codes from GitHub and create all necessary AWS resources.

5. Now it is time to run our Terrafrom scripts, but in our previous project which was [project 18](https://www.darey.io/docs/automate-infrastructure-with-iac-using-terraform-part-3-refactoring/), we talked about using Packer to build our images, and Ansible to configure the infrastructure, so for that we are going to make few changes to  our existing [respository](https://github.com/darey-devops/PBL-project-18.git) from Project 18.

The files that would be Addedd is;
- AMI: for building packer images
- Ansible: for Ansible scripts to configure the infrastucture


Before you proceed ensure you have the following tools installed on your local machine;

- [packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

Refer to this [repository](https://github.com/darey-devops/PBL-project-19.git) for guidiance on how to refactor your enviroment to meet the new changes above and ensure you go through the `README.md` file.


6. Run `terraform plan` and `terraform apply` from web console

Switch to "Runs" tab and click on "Queue plan manualy" button. If planning has been successfull, you can proceed and confirm Apply - press "Confirm and apply", provide a comment and "Confirm plan"

Check the logs and verify that everything has run correctly. Note that Terraform Cloud has generated a unique state version that you can open and see the codes applied and the changes made since the last run.


7. Test automated `terraform plan`

By now, you have tried to launch plan and apply manually from Terraform Cloud web console. But since we have an integration with GitHub, the process can be triggered automatically. Try to change something in any of `.tf` files and look at "Runs" tab again - `plan` must be launched automatically, but to `apply` you still need to approve manually. Since provisioning of new Cloud resources might incur significant costs. Even though you can configure "Auto apply", it is always a good idea to verify your `plan` results before pushing it to `apply` to avoid any misconfigurations that can cause 'bill shock'.


**Note:** First, try to approach this project on your own, but if you hit any blocker and could not move forward with the project, refer to [this video](https://youtu.be/nCemvjcKuIA)

