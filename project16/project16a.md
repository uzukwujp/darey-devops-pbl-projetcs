# Automate Infrastructure With IaC using Terraform Part 1

After you have built AWS infrastructure for 2 websites manually, it is time to automate the process using Terraform. 

Let us start building the same set up with the power of Infrastructure as Code (IaC)

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project16/tooling_project_16.png" width="936px" height="550px">

#### Instructions On How To Submit Your Work For Review And Feedback

To submit your work for review and feedback - follow [**this instruction**](https://starter-pbl.darey.io/en/latest/submission.html).

### Prerequisites before you begin writing Terraform code

* You must have completed [**Terraform course**](https://propitixhomes.udemy.com/course/terraform-certified/) from the Learning dashboard
* Create an IAM user, name it `terraform` (*ensure that the user has only programatic access to your AWS account*) and grant this user `AdministratorAccess` permissions.
* Copy the secret access key and access key ID. Save them in a notepad temporarily.
* Configure programmatic access from your workstation to connect to AWS using the access keys copied above and a [Python SDK (boto3)](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html). You must have [Python 3.6](https://www.python.org/downloads/) or higher on your workstation.

If you are on Windows, use `gitbash`, if you are on a Mac, you can simply open a `terminal`. Read [here](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html) to configure the Python SDK properly. 

For easier authentication configuration - use [AWS CLI](https://aws.amazon.com/cli/) with `aws configure` command.

* Create an [S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html) to store Terraform state file. You can name it something like `<yourname>-dev-terraform-bucket` (*Note: S3 bucket names must be unique unique within a region partition, you can read about S3 bucken naming [in this article](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)*). We will use this bucket from Project-17 onwards.

When you have configured authentication and installed `boto3`, make sure you can programmatically access your AWS account by running following commands in `>python`:

```
import boto3
s3 = boto3.resource('s3')
for bucket in s3.buckets.all():
    print(bucket.name)
```
You shall see your previously created S3 bucket name - `<yourname>-dev-terraform-bucket`

### The secrets of writing quality Terraform code

The secret recipe of a successful Terraform projects consists of:

- Your understanding of your goal (desired AWS infrastructure end state)
- Your knowledge of the `IaC` technology used (in this case - Terraform)
- Your ability to effectively use up to date Terraform documentation [here](https://www.terraform.io/docs/configuration)

As you go along completing this project, you will get familiar with [Terraform-specific terminology](https://www.terraform.io/docs/glossary.html), such as: 

- [Attribute](https://www.terraform.io/docs/glossary.html#attribute)
- [Resource](https://www.terraform.io/docs/glossary.html#resource)
- [Interpolations](https://www.terraform.io/docs/glossary.html#interpolation)
- [Argument](https://www.terraform.io/docs/glossary.html#argument)
- [Providers](https://www.terraform.io/docs/providers/index.html)
- [Provisioners](https://www.terraform.io/docs/language/resources/provisioners/index.html)
- [Input Variables](https://www.terraform.io/docs/glossary.html#variables)
- [Output Variables](https://www.terraform.io/docs/glossary.html#output-values)
- [Module](https://www.terraform.io/docs/glossary.html#module)
- [Data Source](https://www.terraform.io/docs/glossary.html#data-source)
- [Local Values](https://www.terraform.io/docs/configuration-0-11/locals.html)
- [Backend](https://www.terraform.io/docs/glossary.html#backend)  

Make sure you understand them and know when to use each of them. 

Another concept you must know is [`data type`](https://en.wikipedia.org/wiki/Data_type). This is a general programing concept, it refers to how data represented in a programming language and defines how a compiler or interpreter can use the data. Common data types are:

- Integer
- Float
- String
- Boolean, etc.

#### Best practices

* Ensure that every resource is tagged using multiple key-value pairs. You will see this in action as we go along.
* Try to write reusable code, avoid hard coding values wherever possible. (For learning purpose, we will start by hard coding, but gradually refactor our work to follow best practices).




