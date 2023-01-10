### When to use `Workspaces` or `Directory`?

To separate environments with significant configuration differences, use a directory structure. Use workspaces for environments that do not greatly deviate from each other, to avoid duplication of your configurations. Try both methods in the sections below to help you understand which will serve your infrastructure best.

For now, you can read more about both alternatives [here](https://learn.hashicorp.com/tutorials/terraform/organize-configuration) and try both methods yourself, but we will explore them better in next projects.

### Security Groups refactoring with `dynamic block`

For repetitive blocks of code you can use [`dynamic blocks`](https://www.terraform.io/docs/language/expressions/dynamic-blocks.html) in Terraform, to get to know more how to use them - watch [this video]( https://youtu.be/tL58Qt-RGHY).

Refactor Security Groups creation with `dynamic blocks`.

### EC2 refactoring with `Map` and `Lookup`

Remember, every piece of work you do, always try to make it dynamic to accommodate future changes. [Amazon Machine Image (AMI)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) is a regional service which means it is only available in the region it was created. But what if we change the region later, and want to dynamically pick up AMI IDs based on the available AMIs in that region? This is where we will introduce [`Map`](https://www.terraform.io/docs/language/functions/map.html) and [`Lookup`](https://www.terraform.io/docs/language/functions/lookup.html) functions.

`Map` uses a `key` and `value` pairs as a data structure that can be set as a default type for variables. 

```
variable "images" {
    type = "map"
    default = {
        us-east-1 = "image-1234"
        us-west-2 = "image-23834"
    }
}
```

To select an appropriate AMI per region, we will use a lookup function which has following syntax: `lookup(map, key, [default])`. 

**Note:** A default value is better to be used to avoid failure whenever the map data has no key.

```
resource "aws_instace" "web" {
    ami  = "${lookup(var.images, var.region), "ami-12323"}
}
```

Now, the lookup function will load the variable `images` using the first parameter. But it also needs to know which of the key-value pairs to use. That is where the second parameter comes in. The key `us-east-1` could be specified, but then we will not be doing anything dynamic there, but if we specify the variable for region, it simply resolves to one of the keys. That is why we have used `var.region` in the second parameter.

### Conditional Expressions

If you want to make some decision and choose some resource based on a condition - you shall use [Terraform Conditional Expressions](https://www.terraform.io/docs/language/expressions/conditionals.html).

In general, the syntax is as following: `condition ? true_val : false_val`

Read following snippet of code and try to understand what it means:

```
resource "aws_db_instance" "read_replica" {
  count               = var.create_read_replica == true ? 1 : 0
  replicate_source_db = aws_db_instance.this.id
}
```

- `true` #condition equals to 'if true'
- `?` #means, set to '1`
- `:` #means, otherwise, set to '0'