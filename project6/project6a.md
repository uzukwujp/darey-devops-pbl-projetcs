Web Solution With WordPress 
=====================================

You are progressing in practicing to implement web solutions using different technologies. As a DevOps engineer you will most probably encounter [PHP](https://www.php.net)-based solutions since, even in 2021, it is the dominant web programming language used by more websites than any other programming language.

In this project you will be tasked to prepare storage infrastructure on two Linux servers and implement a basic web solution using [WordPress](https://en.wikipedia.org/wiki/WordPress). WordPress is a free and open-source content management system written in **PHP** and paired with **MySQL** or **MariaDB** as its backend Relational Database Management System (RDBMS).

Project 6 consists of two parts:

1. Configure storage subsystem for Web and Database servers based on Linux OS. The focus of this part is to give you practical experience of working with disks, partitions and volumes in Linux.

2. Install WordPress and connect it to a remote MySQL database server. This part of the project will solidify your skills of deploying Web and DB tiers of Web solution.

As a DevOps engineer, your deep understanding of core components of web solutions and ability to troubleshoot them will play essential role in your further progress and development.

#### Three-tier Architecture

Generally, web, or mobile solutions are implemented based on what is called the **Three-tier Architecture**. 

**Three-tier Architecture** is a client-server software architecture pattern that comprise of 3 separate layers.

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project6/six.JPG" width="936px" height="550px">

1. **Presentation Layer** (PL): This is the user interface such as the client server or browser on your laptop. 
2. **Business Layer** (BL): This is the backend program that implements business logic. Application or Webserver
3. **Data Access or Management Layer** (DAL): This is the layer for computer data storage and data access. [Database Server](https://www.computerhope.com/jargon/d/database-server.htm) or File System Server such as [FTP server](https://titanftp.com/2018/09/11/what-is-an-ftp-server/), or [NFS Server](https://searchenterprisedesktop.techtarget.com/definition/Network-File-System)


In this project, you will have the hands-on experience that showcases **Three-tier Architecture** while also ensuring that the disks used to store files on the Linux servers are adequately partitioned and managed through programs such as `gdisk` and `LVM` respectively.

You will be working working with several storage and disk management concepts, to have a better understanding, watch following video:
[Disk management in Linux](https://darey.io/courses/step-12-logical-volume-management/lessons/lesson-1-storage-management/topic/create-linux-partitions-with-fdisk/)


**Note:** We are gradually introducing new AWS elements into our solutions, but do not be worried if you do not fully understand AWS Cloud Services yet, there are Cloud focused projects ahead where we will get into deep details of various Cloud concepts and technologies - not only AWS, but other Cloud Service Providers as well.

##### Your 3-Tier Setup

1. A Laptop or PC to serve as a client
2. An EC2 Linux Server as a web server (This is where you will install Wordpress)
3. An EC2 Linux server as a database (DB) server

***Use `RedHat` OS for this project***

By now you should know how to spin up an EC2 instanse on AWS, but if you forgot - refer to [Project1 Step 0](https://starter-pbl.darey.io/en/latest/project1.html#step-0-preparing-prerequisites).
In previous projects we used 'Ubuntu', but it is better to be well-versed with various Linux distributions, thus, for this projects we will use very popular distribution called ['RedHat'](https://www.redhat.com/en) (it also has a fully compatible derivative - [CentOS](https://www.centos.org))

**Note:** for Ubuntu server, when connecting to it via SSH/Putty or any other tool, we used `ubuntu` user, but for RedHat you will need to use `ec2-user` user. Connection string will look like `ec2-user@<Public-IP>`

Let us get started!

#### Instructions On How To Submit Your Work For Review And Feedback

To submit your work for review and feedback - follow [**this instruction**](https://starter-pbl.darey.io/en/latest/submission.html).




