#### Part 2 - Register a new domain name and configure secured connection using SSL/TLS certificates

Let us make necessary configurations to make connections to our Tooling Web Solution secured!

In order to get a valid SSL certificate - you need to register a new domain name, you can do it using any [Domain name registrar](https://en.wikipedia.org/wiki/Domain_name_registrar) - a company that manages reservation of domain names. The most popular ones are: [Godaddy.com](https://godaddy.com/), [Domain.com](https://www.domain.com), [Bluehost.com](https://www.bluehost.com/).

1. Register a new domain name with any registrar of your choice in any domain zone (e.g. `.com`, `.net`, `.org`, `.edu`, `.info`, `.xyz` or any other)

2. Assign an Elastic IP to your Nginx LB server and associate your domain name with this Elastic IP

You might have noticed, that every time you restart or stop/start your EC2 instance - you get a new public IP address. When you want to associate your domain name - it is better to have a static IP address that does not change after reboot. Elastic IP is the solution for this problem, learn how to allocate an Elastic IP and associate it with an EC2 server [on this page](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html).

3. Update [A record](https://www.cloudflare.com/learning/dns/dns-records/dns-a-record/) in your registrar to point to Nginx LB using Elastic IP address

Learn how associate your domain name to your Elastic IP on [this page](https://medium.com/progress-on-ios-development/connecting-an-ec2-instance-with-a-godaddy-domain-e74ff190c233).

**Side Self Study:** Read about different [DNS record types](https://www.cloudflare.com/learning/dns/dns-records/) and learn what they are used for.

Check that your Web Servers can be reached from your browser using new domain name using HTTP protocol - `http://<your-domain-name.com>`

4. Configure Nginx to recognize your new domain name 

Update your `nginx.conf` with `server_name www.<your-domain-name.com>` instead of `server_name www.domain.com`

5. Install [certbot](https://certbot.eff.org) and request for an SSL/TLS certificate

Make sure [`snapd`](https://snapcraft.io/snapd) service is active and running

```
sudo systemctl status snapd
```

Install certbot

```
sudo snap install --classic certbot
```

Request your certificate (just follow the certbot instructions - you will need to choose which domain you want your certificate to be issued for, domain name will be looked up from `nginx.conf` file so make sure you have updated it on step 4).

```
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --nginx
```

Test secured access to your Web Solution by trying to reach `https://<your-domain-name.com>`

You shall be able to access your website by using HTTPS protocol (that uses TCP port 443) and see a padlock pictogram in your browser's search string.
Click on the padlock icon and you can see the details of the certificate issued for your website.

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project10/cert_details.png" width="936px" height="550px">

6. Set up periodical renewal of your SSL/TLS certificate

By default, LetsEncrypt certificate is valid for 90 days, so it is recommended to renew it at least every 60 days or more frequently.

You can test renewal command in `dry-run` mode

```
sudo certbot renew --dry-run
```

Best pracice is to have a scheduled job that to run `renew` command periodically. Let us configure a `cronjob` to run the command twice a day.

To do so, lets edit the crontab file with the following command:

```
crontab -e
```

Add following line:

```
* */12 * * *   root /usr/bin/certbot renew > /dev/null 2>&1
```

You can always change the interval of this cronjob if twice a day is too often by adjusting schedule expression. 

**Side Self Study:** Refresh your cron configuration knowledge by watching [this video](https://youtu.be/4g1i0ylvx3A).

You can also use this handy [online cron expression editor](https://crontab.guru).

#### Congratulations! 

You have just implemented an Nginx Load Balancing Web Solution with secured HTTPS connection with periodically updated SSL/TLS certificates.

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project10/well_done_10.png" width="936px" height="550px">
