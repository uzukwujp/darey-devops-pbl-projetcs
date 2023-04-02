# Simple To-Do application on MERN Web Stack 

In this project, you are tasked to implement a web solution based on **MERN** stack in AWS Cloud.

**MERN** Web stack consists of following components:

1. [**M**ongoDB](https://www.mongodb.com): A document-based, No-SQL database used to store application data in a form of documents.

2. [**E**xpressJS](https://expressjs.com): A server side Web Application framework for Node.js.

3. [**R**eactJS](https://reactjs.org): A frontend framework developed by Facebook. It is based on [JavaScript](https://www.javascript.com), used to build User Interface (UI) components.

4. [**N**ode.js](https://nodejs.org/en/): A JavaScript runtime environment. It is used to run JavaScript on a machine rather than in a browser.


<img src="https://darey.io/wp-content/uploads/2021/02/MERN-stack.png"  width="936px" height="550px">


As shown on the illustration above, a user interacts with the ReactJS UI components at the application front-end residing in the browser. This frontend is served by the application backend residing in a server, through ExpressJS running on top of NodeJS.

Any interaction that causes a data change request is sent to the NodeJS based Express server, which grabs data from the MongoDB database if required, and returns the data to the frontend of the application, which is then presented to the user.

#### Side Self Study

1. Make a research what types of [Database Management Systems (DBMS) exist and what each type is more suitable for](https://www.alooma.com/blog/types-of-modern-databases). Be able to explain the difference between Relational DBMS and NoSQL (of a different kind).
2. Get yourself familiar with a concept of [Web Application Frameworks](https://en.wikipedia.org/wiki/Web_framework). Get to know what server-side (backend) and client-side (forntend) frameworks exist and what they are used for.
3. [Practice basic JavaScript syntax just for fun](https://www.w3schools.com/js/js_intro.asp).
4. Explore what [RESTful API](https://restfulapi.net) is and what it is used for in Web development.
5. Read what [Cascading Style Sheets (CSS)](https://en.wikipedia.org/wiki/CSS) is used for and browse [basic syntax and properties](https://www.w3schools.com/css/css_intro.asp).

#### Instructions On How To Submit Your Work For Review And Feedback

To submit your work for review and feedback - follow [**this instruction**](https://starter-pbl.darey.io/en/latest/submission.html).

#### Step 0 - Preparing prerequisites

In order to complete this project you will need an AWS account and a virtual server with Ubuntu Server OS.

If you do not have an AWS account - go back to **[Project 1 Step 0](https://starter-pbl.darey.io/en/latest/project1.html)** to sign in to AWS free tier account and create a new EC2 Instance of t2.micro family with **Ubuntu Server 20.04 LTS (HVM) image**. Remember, you can have multiple EC2 instances, but make sure you **TERMINATE** the ones you are not working with at the moment to save available free hours.

**Hint #1:** When you create your EC2 Instances, you can add Tag "Name" to it with a value that corresponds to a current project you are working on - it will be reflected in the name of the EC2 Instance. Like this:

<img src="https://darey.io/wp-content/uploads/2021/02/EC2_tag.png"  width="936px" height="550px">


**Hint #2 (for Windows users only):** In previous projects we used Putty and Git Bash to connect to our EC2 Instances. 

In this project and going forward, we are going to explore the usage [windows terminal](https://docs.microsoft.com/en-us/windows/terminal/install).

Watch this videos to learn how to set up windows terminal on your pc;

- [windows installatatiosn part 1](https://youtu.be/R-qcpehB5HY)

- [windows installatatiosn part 2](https://youtu.be/jsNIlK5s6pI)




You can also watch this [video](https://youtu.be/g8XiC9Q2EEE) to set up your mobaxterm.

## Note: **Use ubuntu 20.04 for implementation of this Project**

#### Task

To deploy a simple **To-Do** application that creates To-Do lists like this:

<img src="https://drive.google.com/uc?export=view&id=1lVpIHgDj6hUknNZu4yHO-Nrr4OyiO2fs"  width="936px" height="550px">









