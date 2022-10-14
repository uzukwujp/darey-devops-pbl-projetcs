#### Testing Backend Code without Frontend using RESTful API

So far we have written backend part of our `To-Do` application, and configured a database, but we do not have a frontend UI yet. We need ReactJS code to achieve that. But during development, we will need a way to test our code using RESTfulL API. Therefore, we will need to make use of some API development client to test our code. 

In this project, we will use [Postman](https://www.getpostman.com/) to test our API.
Click **[Install Postman](https://www.getpostman.com/downloads/)** to download and install postman on your machine.

Click  **[HERE](https://www.youtube.com/watch?v=FjgYtQK_zLE)** to learn how perform [CRUD operartions](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) on Postman 

You should test all the API endpoints and make sure they are working. For the endpoints that require body, you should send JSON back with the necessary fields since it’s what we setup in our code.

Now open your Postman, create a POST request to the API `http://<PublicIP-or-PublicDNS>:5000/api/todos`. This request sends a new task to our To-Do list so the application could store it in the database.

**Note:** make sure your set header key `Content-Type` as `application/json`
![Alt text](https://darey.io/wp-content/uploads/2021/02/postman_header.png "PostMan")

Check the image below:
![Alt text](https://darey.io/wp-content/uploads/2021/02/post-request.jpg "PostMan")

Create a GET request to your API on `http://<PublicIP-or-PublicDNS>:5000/api/todos`. This request retrieves all existing records from out To-do application (backend requests these records from the database and sends it us back as a response to GET request).

![Alt text](https://darey.io/wp-content/uploads/2021/02/get-request.jpg "get request")


**Optional task:** Try to figure out how to send a DELETE request to delete a task from out To-Do list.

**Hint:** To delete a task - you need to send its ID as a part of DELETE request.

By now you have tested backend part of our To-Do application and have made sure that it supports all three operations we wanted:
- [x] Display a list of tasks - HTTP GET request
- [x] Add a new task to the list - HTTP POST request
- [x] Delete an existing task from the list - HTTP DELETE request
