## Task 1: Shell Scripting Basics

### Write a shell script that takes two numbers as arguments and performs addition, subtraction, multiplication, and division on them. Display the results.

```
#!/bin/bash

num1=$1
num2=$2

# Addition
sum=$((num1 + num2))
echo "Sum: $sum"

# Subtraction
sub=$((num1 - num2))
echo "Subtraction: $sub"

# Multiplication
mul=$((num1 * num2))
echo "Multiplication: $mul"

# Division
div=$((num1 / num2))
echo "Division: $div"
To execute the script:
```

### Execute the script
```
chmod +x math_operations.sh
./math_operations.sh 10 5
```

## Task 2: File Manipulation with Shell Scripting

### Write a shell script that prompts the user for a directory name and creates a new directory with that name.

```
#!/bin/bash

echo "Enter directory name: "
read dirname

mkdir $dirname
echo "Directory created: $dirname"
To execute the script:
```

### Execute the script
```
chmod +x create_directory.sh
./create_directory.sh
```

### Create another script that lists all files in a given directory and displays their permissions and sizes.

```
#!/bin/bash

echo "Enter directory name: "
read dirname

ls -l $dirname
To execute the script:
```

### Execute the script

```
chmod +x list_files.sh
./list_files.sh
```

## Task 3: Nginx Configuration Practice


## Install Nginx on your Linux system using the package manager. For example, on Ubuntu, you can run:
```

sudo apt update
sudo apt install nginx
```

### After the installation, the Nginx configuration files are located in the /etc/nginx directory. Write an Nginx configuration file with server blocks to host multiple websites or applications.

### Create a new configuration file 

```
/etc/nginx/sites-available/example.conf with the following content:

```

```
server {
    listen 80;
    server_name example.com;

    location / {
        root /var/www/example;
        index index.html;
    }
}
```

### Enable the site by creating a symbolic link in the /etc/nginx/sites-enabled directory:
```

sudo ln -s /etc/nginx/sites-available/example.conf /etc/nginx/sites-enabled/
```

### Restart Nginx for the changes to take effect: (You can use systemctl command as well. service is the old version for systemctl but they do the same thing)

```
sudo service nginx restart
```

## Task 4: Shell Scripting Automation

### Write a shell script that automatically creates a backup of a directory by compressing its contents into a tarball.

```
#!/bin/bash

# Directory to backup
directory="/path/to/directory"

# Backup location
backup_dir="/path/to/backup"

# Create backup filename with timestamp
backup_file="backup_$(date +%Y%m%d%H%M%S).tar.gz"

# Create backup
tar -czf $backup_dir/$backup_file $directory

echo "Backup created: $backup_dir/$backup_file"
To execute the script:
```

### Execute the script
```
chmod +x create_backup.sh
./create_backup.sh
```