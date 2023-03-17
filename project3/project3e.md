##### MongoDB Database

We need a database where we will store our data. For this we will make use of **mLab**. mLab provides MongoDB database as a service solution ([DBaaS](https://en.wikipedia.org/wiki/Cloud_database)), so to make life easy, you will need to sign up for a shared clusters free account, which is ideal for our use case. [Sign up here](https://www.mongodb.com/atlas-signup-from-mlab). Follow the sign up process, select **AWS** as the cloud provider, and choose a region near you.

Complete a get started checklist as shown on the image below

<img src="https://darey.io/wp-content/uploads/2021/02/MLab-dashboard.png" title="Mlab" width="936px" height="550px">

Allow access to the MongoDB database from anywhere (*Not secure, but it is ideal for testing*)

**IMPORTANT NOTE**
In the image below, make sure you change the time of deleting the entry from 6 Hours to 1 Week


<img src="https://darey.io/wp-content/uploads/2021/02/MogoDB-Network-Access.png" title="MongoDB" width="936px" height="550px">

Create a MongoDB database and collection inside mLab

<img src="https://darey.io/wp-content/uploads/2021/02/Mongo-create-DB-1.png" title="MongoDB" width="936px" height="550px">

<img src="https://darey.io/wp-content/uploads/2021/02/Mongo-create-DB-2.png " title="MongoDB" width="936px" height="550px">

In the `index.js` file, we specified `process.env` to access environment variables, but we have not yet created this file. So we need to do that now.

Create a file in your `Todo` directory and name it `.env`. 

```
touch .env
vi .env
```

Add the connection string to access the database in it, just as below:

```
DB = 'mongodb+srv://<username>:<password>@<network-address>/<dbname>?retryWrites=true&w=majority'
```

Ensure to update `<username>`, `<password>`, `<network-address>` and `<database>` according to your setup

Here is how to get your connection string

<img src="https://darey.io/wp-content/uploads/2021/02/Mongo-connect1.png " title="Mongo Connect" width="936px" height="550px">
<img src="https://darey.io/wp-content/uploads/2021/02/Mongo-connect2.png " title="Mongo Connect" width="936px" height="550px">
<img src="https://darey.io/wp-content/uploads/2021/02/Mongo-connect3.png " title="Mongo Connect" width="936px" height="550px">



Now we need to update the `index.js` to reflect the use of `.env` so that Node.js can connect to the database.

Simply delete existing content in the file, and update it with the entire code below.

To do that using `vim`, follow below steps

1. Open the file with `vim index.js`
2. Press `esc` 
3. Type `:`
4. Type `%d`
5. Hit 'Enter'

The entire content will be deleted, then,

6. Press `i` to enter the *insert* mode in *vim*
7. Now, paste the entire code below in the file.

```
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const routes = require('./routes/api');
const path = require('path');
require('dotenv').config();

const app = express();

const port = process.env.PORT || 5000;

//connect to the database
mongoose.connect(process.env.DB, { useNewUrlParser: true, useUnifiedTopology: true })
.then(() => console.log(`Database connected successfully`))
.catch(err => console.log(err));

//since mongoose promise is depreciated, we overide it with node's promise
mongoose.Promise = global.Promise;

app.use((req, res, next) => {
res.header("Access-Control-Allow-Origin", "\*");
res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
next();
});

app.use(bodyParser.json());

app.use('/api', routes);

app.use((err, req, res, next) => {
console.log(err);
next();
});

app.listen(port, () => {
console.log(`Server running on port ${port}`)
});
```

Using environment variables to store information is considered more secure and best practice to separate configuration and secret data from the application, instead of writing connection strings directly inside the `index.js` application file. 

Start your server using the command:

```
node index.js
```

You shall see a message **'Database connected successfully'**, if so - we have our backend configured. Now we are going to test it.

