
### Continue Infrastructure Automation with Terraform

Let us continue from where we stopped in [Project 16](https://www.darey.io/docs/project-16-introduction/).

Based on our knowledge from the previous project, we can continue creating AWS resources!

### Networking

#### Private subnets & best practices

Create 4 private subnets keeping in mind the following principles:

- Make sure you use variables or `length()` function to determine the number of AZs.
- Use variables and `cidrsubnet()` function to allocate `vpc_cidr` for subnets.
- Keep variables and resources in separate files for better code structure and readability.
- Tag all the resources you have created so far. Explore how to use `format()` and `count` functions to automatically tag subnets with its respective number.

#### A little bit more about Tagging

Tagging is a straightforward but very powerful concept that helps you manage your resources more efficiently:

* Resources are better organized in 'virtual' groups.
* They can be easily filtered and searched from console or programmatically. 
* Billing team can easily generate reports and determine how much each part of infrastructure costs.(by department, by type, by environment, etc.)
* You can easily determine resources that are not being used and take actions accordingly. 
* If there are different teams in the organisation using the same account, tagging can help differentiate who owns what resources.

**Note:**  You can add multiple tags as a default set, for example:

```
tags = {
  Environment      = "production" 
  Owner-Email     = "infradev-segun@darey.io"
  Managed-By      = "Terraform"
  Billing-Account = "1234567890"
}
```

Now you can tag all your resources using the format below

```
tags = merge(
    var.tags,
    {
      Name = "Name of the resource"
    },
  )
```

The great thing about this is; anytime we need to make a change to the tags, we simply do that in one single place.

But, our key-value pairs are hard coded. So, go ahead and work out a fix for that. Simply create variables for each value and use `var.variable_name` as the value to each of the keys. 
Apply the same best practices for all other resources you are going to create.

#### Internet Gateways & `format()` function

Create an Internet Gateway in a separate Terraform file `internet_gateway.tf`

```
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = format("%s-%s!", aws_vpc.main.id,"IG")
    } 
  )
}
```

Did you notice how we have used `format()` function to dynamically generate a unique name for this resource? The first part of the `%s` takes the interpolated value of `aws_vpc.main.id` while the second `%s` appends a literal string `IG` and finally an exclamation mark is added in the end.

If any of the resources being created is either using the `count` function or creating multiple resources using a loop, then a key-value pair that needs to be unique must be handled differently. 

For example, each of our subnets should have a unique name in the tag section. Without the `format()` function, this would not be possible. With the `format` function, each private subnet's tag will look like this.

```
Name = PrivateSubnet-0
Name = PrivateSubnet-1
Name = PrivateSubnet-2
```
Lets try and see that in action.

```
  tags = merge(
    var.tags,
    {
      Name = format("PrivateSubnet-%s", count.index)
    } 
  )
```

#### NAT Gateways

Create 1 NAT Gateways and 1 Elastic IP (EIP) addresses

Now use similar approach to create the NAT Gateways in a new file called `natgateway.tf`. 

**Note:** We need to create an Elastic IP for the NAT Gateway, and you can see the use of `depends_on` to indicate that the Internet Gateway resource must be available before this should be created. Although Terraform does a good job to manage dependencies, in most cases, it is good to be explicit.

You can read more on dependencies [here](https://www.terraform.io/docs/language/meta-arguments/depends_on.html)

```
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]

  tags = merge(
    var.tags,
    {
      Name = format("%s-EIP", var.name)
    },
  )
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]

  tags = merge(
    var.tags,
    {
      Name = format("%s-Nat", var.name)
    },
  )
}

```
