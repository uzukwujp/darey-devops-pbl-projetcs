#### Step 2: Install MongoDB

MongoDB stores data in flexible, `JSON-like` documents. Fields in a database can vary from document to document and data structure can be changed over time. For our example application, we are adding book records to MongoDB that contain book name, isbn number, author, and number of pages.


Import the Public Key used by Package Management System

```
sudo apt-get install gnupg curl
```

```
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
```

Create a List file For MongoDB

**For Ubuntu 20.04**

```
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
```

**For Ubuntu 22.04**

```
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
```

Reload Local Packages

```
sudo apt-get update
```


Install MongoDB

```
sudo apt-get install -y mongodb-org
```

Start and Enable The Mongod Service

```
sudo systemctl start mongod

sudo systemctl enable mongod
```

Verify that the service is up and running

```
sudo systemctl status mongod
```


Install '[body-parser](https://www.npmjs.com/package/body-parser) package

We need 'body-parser' package to help us process JSON files passed in requests to the server.

```
sudo npm install body-parser
```
 
Create a folder named 'Books' 

```
mkdir Books && cd Books
```

In the Books directory, Initialize npm project 

```
npm init
```

Add a file to it named server.js 

```
vi server.js
```

Copy and paste the web server code below into the `server.js` file.

```
var express = require('express');
var bodyParser = require('body-parser');
var app = express();
app.use(express.static(__dirname + '/public'));
app.use(bodyParser.json());
require('./apps/routes')(app);
app.set('port', 3300);
app.listen(app.get('port'), function() {
    console.log('Server up: http://localhost:' + app.get('port'));
});
```
