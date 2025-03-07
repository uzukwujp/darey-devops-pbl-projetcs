##### Install ExpressJS

Remember that Express is a framework for Node.js, therefore a lot of things developers would have programmed is already taken care of out of the box. Therefore it simplifies development, and abstracts a lot of low level details. For example, Express helps to define routes of your application based on HTTP methods and URLs.

To use express, install it using npm:

```
$ npm install express
```

Now create a file `index.js` with the command below

```
$ touch index.js
```

Run `ls` to confirm that your index.js file is successfully created

Install the `dotenv` module

```
npm install dotenv
```

Open the index.js file with the command below

```
$ vim index.js
```

Type the code below into it and save. Do not get overwhelmed by the code you see. For now, simply paste the code into the file.


```
const express = require('express');
require('dotenv').config();

const app = express();

const port = process.env.PORT || 5000;

app.use((req, res, next) => {
res.header("Access-Control-Allow-Origin", "\*");
res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
next();
});

app.use((req, res, next) => {
res.send('Welcome to Express');
});

app.listen(port, () => {
console.log(`Server running on port ${port}`)
});
```
Notice that we have specified to use port `5000` in the code. This will be required later when we go on the browser.

Use `:w` to save in vim and use `:qa` to exit vim

Now it is time to start our server to see if it works. Open your terminal in the same directory as your index.js file and type:

```
$ node index.js
```

If every thing goes well, you should see **Server running on port 5000** in your terminal.



<img src="https://darey.io/wp-content/uploads/2021/02/node-index.png" title="index" width="936px" height="550px">



Now we need to open this port in EC2 Security Groups. Refer to **[Project 1](https://starter-pbl.darey.io/en/latest/project1.html)** Step 1 – Installing the Nginx Web Server. There we created an inbound rule to open TCP port 80, you need to do the same for port 5000, like this:


<img src="https://darey.io/wp-content/uploads/2021/02/Port_5000.png" title="index" width="936px" height="550px">


Open up your browser and try to access your server's Public IP or Public DNS name followed by port 5000:

```
http://<PublicIP-or-PublicDNS>:5000
```

Quick reminder how to get your server's Public IP and public DNS name:
1) You can find it in your AWS web console in EC2 details
2) Run `curl -s http://169.254.169.254/latest/meta-data/public-ipv4` for Public IP address or `curl -s http://169.254.169.254/latest/meta-data/public-hostname` for Public DNS name.

```
Welcome to Express
```

<img src="https://darey.io/wp-content/uploads/2021/02/welcome_express.png" title="index" width="936px" height="550px">


##### Routes
There are three actions that our To-Do application needs to be able to do: 

1. Create a new task
2. Display list of all tasks
3. Delete a completed task

Each task will be associated with some particular endpoint and will use different standard [HTTP request methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods): POST, GET, DELETE.

For each task, we need to create [`routes`](https://expressjs.com/en/guide/routing.html) that will define various endpoints that the `To-do` app will depend on. So let us create a folder `routes`

```
$ mkdir routes
```

**Tip:** You can open multiple shells in Putty or Linux/Mac to connect to the same EC2

Change directory to `routes` folder.

```
$ cd routes
```

Now, create a file `api.js` with the command below

```
touch api.js
```

Open the file with the command below

```
vim api.js
```

Copy below code in the file. (*Do not be overwhelmed with the code*)

```
const express = require ('express');
const router = express.Router();

router.get('/todos', (req, res, next) => {

});

router.post('/todos', (req, res, next) => {

});

router.delete('/todos/:id', (req, res, next) => {

})

module.exports = router;
```
Moving forward let create Models directory.