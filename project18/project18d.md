## Terraform Modules and best practices to structure your .tf codes

By this time, you might have realized how difficult is to navigate through all the Terraform blocks if they are all written in a single long `.tf` file. As a DevOps engineer, you must produce reusable and comprehensive IaC code structure, and one of the tool that Terraform provides out of the box is [**Modules**](https://www.terraform.io/docs/language/modules/index.html).

Modules serve as containers that allow to logically group Terraform codes for similar resources in the same domain (e.g., Compute, Networking, AMI, etc.). One **root module** can call other **child modules** and insert their configurations when applying Terraform config. This concept makes your code structure neater, and it allows different team members to work on different parts of configuration at the same time. 

You can also create and publish your modules to [Terraform Registry](https://registry.terraform.io/browse/modules) for others to use and use someone's modules in your projects.

Module is just a collection of .tf and/or .tf.json files in a directory. 

You can refer to existing child modules from your **root module** by specifying them as a source, like this:

```
module "network" {
  source = "./modules/network"
}
```

Note that the path to 'network' module is set as relative to your working directory.

Or you can also directly access resource outputs from the modules, like this:

```
resource "aws_elb" "example" {
  # ...

  instances = module.servers.instance_ids
}
```

In the example above, you will have to have module 'servers' to have output file to expose variables for this resource.

### Refactor your project using Modules

Let us review the [repository](https://github.com/darey-devops/PBL-project-17.git) of project 17, you will notice that we had a single lsit of long file for creating all of our resources, but that is not the best way to go about it because it maks our code base vey hard to read and understand, and making future changes can bring a lot of pain.

**QUICK TASK FOR YOU:** Break down your Terraform codes to have all resources in their respective modules. Combine resources of a similar type into directories within a 'modules' directory, for example, like this:

```
- modules
  - ALB
  - EFS
  - RDS
  - Autoscaling
  - compute
  - VPC
  - security
```

Each module shall contain following files:

```
- main.tf (or %resource_name%.tf) file(s) with resources blocks
- outputs.tf (optional, if you need to refer outputs from any of these resources in your root module)
- variables.tf (as we learned before - it is a good practice not to hard code the values and use variables)
```

It is also recommended to configure `providers` and `backends` sections in separate files.

**NOTE:** It is not compulsory to use this naming convention.

After you have given it a try, you can check out this [repository](https://github.com/darey-devops/PBL-project-18.git)

 It is not compulsory to use this naming convention for guidiance or to fix your errors.

In the configuration sample from the repository, you can observe two examples of referencing the module: 

a. Import module as a `source` and have access to its variables via `var` keyword:

```
module "VPC" {
  source = "./modules/VPC"
  region = var.region
  ...
}
```

b. Refer to a module's output by specifying the full path to the output variable by using `module.%module_name%.%output_name%` construction:

```
subnets-compute = module.network.public_subnets-1
```
