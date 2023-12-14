#### Create [MySQL RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html) 

Let us create the RDS itself using this snippet of code in the `rds.tf` file:


```
# This section will create the subnet group for the RDS instance using the private subnet
resource "aws_db_subnet_group" "ACS-rds" {
  name       = "acs-rds"
  subnet_ids = [aws_subnet.private[2].id, aws_subnet.private[3].id]

 tags = merge(
    var.tags,
    {
      Name = "ACS-rds"
    },
  )
}


# create the RDS instance with the subnets group
resource "aws_db_instance" "ACS-rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "daviddb"
  username               = var.master-username
  password               = var.master-password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.ACS-rds.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.datalayer-sg.id]
  multi_az               = "true"
}

```
Before applying, please note that we gave reference to some variables in our resources that have not been declared in the `variables.tf` file. Go through the entire code and spot these variables and declare them in the `variables.tf` file. 

If you have done that well, your file should look like this one below.

```
variable "region" {
  type = string
  description = "The region to deploy resources"
}

variable "vpc_cidr" {
  type = string
  description = "The VPC cidr"
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_dns_hostnames" {
  dtype = bool
}

variable "enable_classiclink" {
  type = bool
}

variable "enable_classiclink_dns_support" {
  type = bool
}

variable "preferred_number_of_public_subnets" {
  type        = number
  description = "Number of public subnets"
}

variable "preferred_number_of_private_subnets" {
  type        = number
  description = "Number of private subnets"
}

variable "name" {
  type    = string
  default = "ACS"

}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}


variable "ami" {
  type        = string
  description = "AMI ID for the launch template"
}


variable "keypair" {
  type        = string
  description = "key pair for the instances"
}

variable "account_no" {
  type        = number
  description = "the account number"
}


variable "master-username" {
  type        = string
  description = "RDS admin username"
}

variable "master-password" {
  type        = string
  description = "RDS master password"
}
```
We are almost done but we need to update the last file which is `terraform.tfvars` file. In this file we are going to declare the values for the variables in our `varibales.tf` file.

Open the `terraform.tfvars` file and add the code below:

```
region = "us-east-1"

vpc_cidr = "172.16.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

preferred_number_of_public_subnets = "2"

preferred_number_of_private_subnets = "4"

environment = "production"

ami = "ami-0b0af3577fe5e3532"

keypair = "devops"

# Ensure to change this to your acccount number
account_no = "123456789"


db-username = "david"


db-password = "devopspbl"


tags = {
  Enviroment      = "production" 
  Owner-Email     = "infradev-segun@darey.io"
  Managed-By      = "Terraform"
  Billing-Account = "1234567890"
}
```


At this point, you shall have pretty much all the infrastructure elements ready to be deployed automatically.
Try to plan and apply your Terraform codes, explore the resources in AWS console and make sure you destroy them right away to avoid massive costs.

### Additional tasks

In addition to regular project submissions, include the following:

1. Summarise your understanding on Networking concepts like **IP Address, Subnets, CIDR Notation, IP Routing, Internet Gateways, NAT**
2. Summarise your understanding of the [OSI Model](https://en.wikipedia.org/wiki/OSI_model),  [TCP/IP suite](https://en.wikipedia.org/wiki/Internet_protocol_suite) and how [they are connected](https://en.wikipedia.org/wiki/Internet_protocol_suite#Comparison_of_TCP/IP_and_OSI_layering) - research beyond the provided articles, watch different YouTube videos to fully understand the concept around OSI and how it is related to the Internet and end-to-end Web Solutions. You do not need to memorise the layers - just understand the idea around it.
3. Explain the difference between `assume role policy` and `role policy`

### Congratulations!

Now you have fully automated creation of AWS Infrastructure for 2 websites with Terraform. In the next project, we will further enhance our codes by refactoring and introducing more exciting Terraform concepts! Go ahead and continue your PBL journey with us!
<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project17/awesome_17.jpg" width="936px" height="550px">