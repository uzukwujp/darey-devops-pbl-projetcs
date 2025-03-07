#### Step 3 — Installing PHP

You have Apache installed to serve your content and MySQL installed to store and manage your data. [PHP](https://www.php.net) is the component of our setup that will process code to display dynamic content to the end user. In addition to the `php` package, you’ll need `php-mysql`, a PHP module that allows PHP to communicate with MySQL-based databases. You’ll also need `libapache2-mod-php` to enable Apache to handle PHP files. Core PHP packages will automatically be installed as dependencies.

To install these 3 packages at once, run:

```
$ sudo apt install php libapache2-mod-php php-mysql
```

Once the installation is finished, you can run the following command to confirm your PHP version:

```
php -v
```

```
PHP 7.4.3 (cli) (built: Oct  6 2020 15:47:56) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies
```

At this point, your LAMP stack is completely installed and fully operational.

- [x] **L**inux (Ubuntu)
- [x] **A**pache HTTP Server
- [x] **M**ySQL
- [x] **P**HP

To test your setup with a PHP script, it’s best to set up a proper [Apache Virtual Host](https://httpd.apache.org/docs/2.4/vhosts/) to hold your website’s files and folders. Virtual host allows you to have multiple websites located on a single machine and users of the websites will not even notice it.

![](https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project1/VirtualHost.png)

We will configure our first Virtual Host in the next step.
