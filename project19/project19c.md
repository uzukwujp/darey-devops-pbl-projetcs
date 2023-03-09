#### Practice Task №1

1. Configure 3 branches in your `terraform-cloud` repository for `dev`, `test`, `prod` environments
2. Make necessary configuration to trigger runs automatically only for `dev` environment
2. Create an Email and Slack notifications for certain events (e.g. started `plan` or errored run) and test it
3. Apply `destroy` from Terraform Cloud web console

### Public Module Registry vs Private Module Registry

Terraform has a quite strong community of contributors (individual developers and 3rd party companies) that along with HashiCorp maintain a [Public Registry](https://www.terraform.io/docs/registry/index.html), where you can find reusable configuration packages ([modules](https://www.terraform.io/docs/registry/modules/use.html)). We strongly encourage you to explore modules shared to the public registry, specifically for this project - you can check out [this AWS provider registy page](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest). 

As your Terraform code base grows, your DevOps team might want to create you own library of reusable components - [Private Registry](https://www.terraform.io/docs/registry/private.html) can help with that.

#### Practice Task №2 Working with Private repository

1. Create a simple Terraform repository (you can clone one [from here](https://github.com/hashicorp/learn-private-module-aws-s3-webapp)) that will be your module
2. Import the module into your private registry
3. Create a configuration that uses the module
4. Create a workspace for the configuration
5. Deploy the infrastructure
6. Destroy your deployment

**Note:** First, try to approach this task oun your own, but if you have any difficulties with it, refer to [this tutorial](https://learn.hashicorp.com/tutorials/terraform/module-private-registry).



### Congratulations!
![](https://darey.io/wp-content/uploads/2021/07/terraform_cup.png)
![](https://dareyio-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project19/terraform_cup.png)

![](https://darey.io/wp-content/uploads/2021/07/terraform_cup.png)

You have learned how to effectively use managed version of Terraform - Terraform Cloud. You have also practiced in finding modules in a Public Module Registry as well as build and deploy your own modules to a Private Module Registry.

Move ahead to the next project!
