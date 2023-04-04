#### Connecting to the MySQL server from a second container running the MySQL client utility

The good thing about this approach is that you do not have to install any client tool on your laptop, and you do not need to connect directly to the container running the MySQL server.

Run the MySQL Client Container:

```
docker run --network tooling_app_network --name mysql-client -it --rm mysql mysql -h mysqlserverhost -u <user-created-from-the-SQL-script> -p
```

Flags used:

- `--name` gives the container a name
- `-it` runs in interactive mode and Allocate a pseudo-TTY
- `--rm` automatically removes the container when it exits
- `--network` connects a container to a network
- `-h` a MySQL flag specifying the MySQL server Container hostname
- `-u` user created from the SQL script
- `-p` password specified for the user created from the SQL script
 

#### Prepare database schema 

Now you need to prepare a database schema so that the Tooling application can connect to it.

1. Clone the Tooling-app repository from [here](https://github.com/darey-devops/tooling)

```
git clone https://github.com/darey-devops/tooling.git
```

2. On your terminal, export the location of the SQL file

```
export tooling_db_schema=~/tooling/html/tooling_db_schema.sql
```

You can find the `tooling_db_schema.sql` in the `html` folder of cloned repo.

3. Use the SQL script to create the database and prepare the schema. With the `docker exec` command, you can execute a command in a running container.

```
docker exec -i mysql-server mysql -uroot -p$MYSQL_PW < $tooling_db_schema
```

4. Update the `db_conn.php` file with connection details to the database

```
$servername = "mysqlserverhost";
$username = "<user>";
$password = "<client-secret-password>";
$dbname = "toolingdb";
```

5. Run the Tooling App

Containerization of an application starts with creation of a file with a special name - 'Dockerfile' (without any extensions). This can be considered as a 'recipe' or 'instruction' that tells Docker how to pack your application into a container. In this project, you will build your container from a pre-created `Dockerfile`, but as a DevOps, you must also be able to write Dockerfiles. 

You can watch [this video](https://www.youtube.com/watch?v=hnxI-K10auY) to get an idea how to create your `Dockerfile` and build a container from it.

And on [this page](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/), you can find official Docker best practices for writing Dockerfiles.

So, let us containerize our Tooling application; here is the plan:

- Make sure you have checked out your Tooling repo to your machine with Docker engine
- First, we need to build the Docker image the tooling app will use. The Tooling repo you cloned above has a `Dockerfile` for this purpose. Explore it and make sure you understand the code inside it.
- Run `docker build` command
- Launch the container with `docker run`
- Try to access your application via port exposed from a container

Let us begin:

Ensure you are inside the folder that has the `Dockerfile` and build your container:

```
docker build -t tooling:0.0.1 .
```
In the above command, we specify a parameter `-t`, so that the image can be tagged `tooling"0.0.1` - Also, you have to notice the `.` at the end. This is important as that tells Docker to locate the `Dockerfile` in the current directory you are running the command. Otherwise, you would need to specify the absolute path to the `Dockerfile`.

6. Run the container:

```
docker run --network tooling_app_network -p 8085:80 -it tooling:0.0.1
```

Let us observe those flags in the command.

- We need to specify the `--network` flag so that both the Tooling app and the database can easily connect on the same virtual network we created earlier.
- The `-p` flag is used to map the container port with the host port. Within the container, `apache` is the webserver running and, by default, it listens on port 80. You can confirm this with the `CMD ["start-apache"]` section of the Dockerfile. But we cannot directly use port 80 on our host machine because it is already in use. The workaround is to use another port that is not used by the host machine. In our case, port 8085 is free, so we can map that to port 80 running in the container.

**Note:** *You will get an error. But you must troubleshoot this error and fix it. Below is your error message.*

```
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.18.0.3. Set the 'ServerName' directive globally to suppress this message
```
**Hint:** *You must have faced this error in some of the past projects. It is time to begin to put your skills to good use. Simply do a google search of the error message, and figure out where to update the configuration file to get the error out of your way.*

If everything works, you can open the browser and type `http://localhost:8085`

You will see the login page.

![](https://dareyio-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project20/Tooling-Login.png)

The default email is `test@gmail.com`, the password is `12345` or you can check users' credentials stored in the `toolingdb.user` table.
