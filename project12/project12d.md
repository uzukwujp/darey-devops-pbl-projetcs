#### Step 4 - Reference 'Webserver' role 

Within the `static-assignments` folder, create a new assignment for **uat-webservers** `uat-webservers.yml`. This is where you will reference the role.

```
---
- hosts: uat-webservers
  roles:
     - webserver
```

Remember that the entry point to our ansible configuration is the `site.yml` file. Therefore, you need to refer your `uat-webservers.yml` role inside `site.yml`.

So, we should have this in `site.yml`

```
---
- hosts: all
- import_playbook: ../static-assignments/common.yml

- hosts: uat-webservers
- import_playbook: ../static-assignments/uat-webservers.yml

```

#### Step 5 - Commit & Test

Commit your changes, create a Pull Request and merge them to `master` branch, make sure webhook triggered two consequent Jenkins jobs, they ran successfully and copied all the files to your `Jenkins-Ansible` server into `/home/ubuntu/ansible-config-mgt/` directory.

Now run the playbook against your `uat` inventory and see what happens:

**NOTE:** Before running your playbook, ensure you have tunneled into your `Jenkins-Ansible` server via ssh-agent
For windows users, see this [video](https://youtu.be/OplGrY74qog)
For Linux users, see this [video](https://www.youtube.com/watch?v=RRRQLgAfcJw&list=PLtPuNR8I4TvlBxy8IUXUDnmtlKawRsWH_&index=15)

```
cd /home/ubuntu/ansible-config-mgt

ansible-playbook -i /inventory/uat.yml playbooks/site.yaml
```

You should be able to see both of your UAT Web servers configured and you can try to reach them from your browser:

`http://<Web1-UAT-Server-Public-IP-or-Public-DNS-Name>/index.php`

or

`http://<Web1-UAT-Server-Public-IP-or-Public-DNS-Name>/index.php`

Your Ansible architecture now looks like this:
<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project12/project12_architecture.png" width="936px" height="550px">

In Project 13, you will see the difference between **Static** and **Dynamic** assignments.

#### Congratulations!

You have learned how to deploy and configure UAT Web Servers using Ansible `imports` and `roles`!

<img src="https://darey-io-pbl-projects-images.s3.eu-west-2.amazonaws.com/project12/good_job12.jpg" width="936px" height="550px">