#### Optional Step - Configure Local DNS Names Resolution

Sometimes it is tedious to remember and switch between IP addresses, especially if you have a lot of servers under your management.
What we can do, is to configure local domain name resolution. The easiest way is to use `/etc/hosts` file, although this approach is not very scalable, but it is very easy to configure and shows the concept well. So let us configure IP address to domain name mapping for our LB.

```
#Open this file on your LB server

sudo vi /etc/hosts

#Add 2 records into this file with Local IP address and arbitrary name for both of your Web Servers

<WebServer1-Private-IP-Address> Web1
<WebServer2-Private-IP-Address> Web2
```

Now you can update your LB config file with those names instead of IP addresses.

```
BalancerMember http://Web1:80 loadfactor=5 timeout=1
BalancerMember http://Web2:80 loadfactor=5 timeout=1
```

You can try to `curl` your Web Servers from LB locally `curl http://Web1` or `curl http://Web2` - it shall work.

Remember, this is only internal configuration and it is also local to your LB server, these names will neither be 'resolvable' from other servers internally nor from the Internet.

#### Target Architecture

Now your set up looks like this:

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project8/project8_final.png" width="936px" height="550px">

#### Congratulations! 

You have just implemented a Load balancing Web Solution for your DevOps team.

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project8/proj_8_complete.jpg" width="936px" height="550px">

