### VPC | Subnets | Security Groups

#### Let us create a directory structure

Open your Visual Studio Code and:

* Create a folder called `PBL`
* Create a file in the folder, name it `main.tf`

Your setup should look like this.

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project16/terraform1.png" width="936px" height="550px">
#### Provider and VPC resource section

Set up Terraform CLI as per [this instruction](https://learn.hashicorp.com/tutorials/terraform/install-cli).

* Add `AWS` as a provider, and a resource to create a VPC in the `main.tf` file.
* Provider block informs Terraform that we intend to build infrastructure within AWS. 
* Resource block will create a VPC.

```
provider "aws" {
  region = "eu-central-1"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block                     = "172.16.0.0/16"
  enable_dns_support             = "true"
  enable_dns_hostnames           = "true"
  enable_classiclink             = "false"
  enable_classiclink_dns_support = "false"
}
```

**Note:** You can change the configuration above to create your VPC in other region that is closer to you. The same applies to all configuration snippets that will follow.

* The next thing we need to do, is to download necessary plugins for Terraform to work. These plugins are used by `providers` and `provisioners`. At this stage, we only have `provider` in our `main.tf` file. So, Terraform will just download plugin for AWS provider.
* Lets accomplish this with `terraform init` command as seen in the below demonstration.

![](https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project16/Terraform1.gif)
***Observations***: 
- Notice that a new directory has been created: `.terraform\...`. This is where Terraform keeps plugins. Generally, it is safe to delete this folder. It just means that you must execute `terraform init` again, to download them.

Moving on, let us create the only resource we just defined. `aws_vpc`. But before we do that, we should check to see what terraform intends to create before we tell it to go ahead and create it.

* Run `terraform plan`
* Then, if you are happy with changes planned, execute `terraform apply`

![](https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project16/Terraform2.gif)

***Observations***: 

1. A new file is created `terraform.tfstate` This is how Terraform keeps itself up to date with the exact state of the infrastructure. It reads this file to know what already exists, what should be added, or destroyed based on the entire terraform code that is being developed. 
2. If you also observed closely, you would realise that another file gets created during planning and apply. But this file gets deleted immediately. `terraform.tfstate.lock.info` This is what Terraform uses to track, who is running its code against the infrastructure at any point in time. This is very important for teams working on the same Terraform repository at the same time. The lock prevents a user from executing Terraform configuration against the same infrastructure when another user is doing the same - it allows to avoid duplicates and conflicts.
   
Its content is usually like this. (We will discuss more about this later)

```
    {
        "ID":"e5e5ad0e-9cc5-7af1-3547-77bb3ee0958b",
        "Operation":"OperationTypePlan","Info":"",
        "Who":"dare@Dare","Version":"0.13.4",
        "Created":"2020-10-28T19:19:28.261312Z",
        "Path":"terraform.tfstate"
    }
```

It is a `json` format file that stores information about a user: user's `ID`, what operation he/she is doing, timestamp, and location of the `state` file.
