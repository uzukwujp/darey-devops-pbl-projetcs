#### Step 4 - Access the routes with [AngularJS](https://angularjs.org/)

AngularJS provides a web framework for creating dynamic views in your web applications. In this tutorial, we use AngularJS to connect our web page with Express and perform actions on our book register. 

Change the directory back to 'Books' 

```
cd ../..
```

Create a folder named `public` 

```
mkdir public && cd public
```

Add a file named `script.js` 

```
vi script.js
```

Copy and paste the Code below (controller configuration defined) into the script.js file.

```
var app = angular.module('myApp', []);
app.controller('myCtrl', function($scope, $http) {
  $http( {
    method: 'GET',
    url: '/book'
  }).then(function successCallback(response) {
    $scope.books = response.data;
  }, function errorCallback(response) {
    console.log('Error: ' + response);
  });
  $scope.del_book = function(book) {
    $http( {
      method: 'DELETE',
      url: '/book/:isbn',
      params: {'isbn': book.isbn}
    }).then(function successCallback(response) {
      console.log(response);
    }, function errorCallback(response) {
      console.log('Error: ' + response);
    });
  };
  $scope.add_book = function() {
    var body = '{ "name": "' + $scope.Name + 
    '", "isbn": "' + $scope.Isbn +
    '", "author": "' + $scope.Author + 
    '", "pages": "' + $scope.Pages + '" }';
    $http({
      method: 'POST',
      url: '/book',
      data: body
    }).then(function successCallback(response) {
      console.log(response);
    }, function errorCallback(response) {
      console.log('Error: ' + response);
    });
  };
});
```
 
In 'public' folder, create a file named `index.html` 

```
vi index.html
```

Cpoy and paste the code below into index.html file.

```
<!doctype html>
<html ng-app="myApp" ng-controller="myCtrl">
  <head>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
    <script src="script.js"></script>
  </head>
  <body>
    <div>
      <table>
        <tr>
          <td>Name:</td>
          <td><input type="text" ng-model="Name"></td>
        </tr>
        <tr>
          <td>Isbn:</td>
          <td><input type="text" ng-model="Isbn"></td>
        </tr>
        <tr>
          <td>Author:</td>
          <td><input type="text" ng-model="Author"></td>
        </tr>
        <tr>
          <td>Pages:</td>
          <td><input type="number" ng-model="Pages"></td>
        </tr>
      </table>
      <button ng-click="add_book()">Add</button>
    </div>
    <hr>
    <div>
      <table>
        <tr>
          <th>Name</th>
          <th>Isbn</th>
          <th>Author</th>
          <th>Pages</th>

        </tr>
        <tr ng-repeat="book in books">
          <td>{{book.name}}</td>
          <td>{{book.isbn}}</td>
          <td>{{book.author}}</td>
          <td>{{book.pages}}</td>

          <td><input type="button" value="Delete" data-ng-click="del_book(book)"></td>
        </tr>
      </table>
    </div>
  </body>
</html>

```

Change the directory back up to 'Books'

```
cd ..
```

Start the server by running this command:

```
node server.js
```
The server is now up and running, we can connect it via port 3300. You can launch a separate Putty or SSH console to test what `curl` command returns locally. 

```
curl -s http://localhost:3300
```

It shall return an HTML page, it is hardly readable in the CLI, but we can also try and access it from the Internet.

For this - you need to open TCP port 3300 in your AWS Web Console for your EC2 Instance.

You are supposed to know how to do it, if you have forgotten - refer to [Project 1](https://starter-pbl.darey.io/en/latest/) (Step 1 — Installing Apache and Updating the Firewall)

Your Security group shall look like this:

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project4/open_port_3300.png" width="936px" height="550px">

Now you can access our Book Register web application from the Internet with a browser using Public IP address or Public DNS name.
 
Quick reminder how to get your server's Public IP and public DNS name:

1. You can find it in your AWS web console in EC2 details
2. Run `curl -s http://169.254.169.254/latest/meta-data/public-ipv4` for Public IP address or `curl -s http://169.254.169.254/latest/meta-data/public-hostname` for Public DNS name.

This is how your Web Book Register Application will look like in browser:
<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project4/books_register.png" width="936px" height="550px">

#### Congratulations!

You have now completed all 'PBL Progressive' projects and are ready to move on to more complex and fun ['PBL Professional' projects](https://professional-pbl.darey.io/en/latest/)!!!

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project4/celebrate.png" width="936px" height="550px">

