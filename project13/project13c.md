#### Community Roles

Now it is time to create a role for MySQL database - it should install the MySQL package, create a database and configure users. But why should we re-invent the wheel? There are tons of roles that have already been developed by other open source engineers out there. These roles are actually production ready, and dynamic to accomodate most of Linux flavours. With Ansible Galaxy again, we can simply download a ready to use ansible role, and keep going.

#### Download Mysql Ansible Role 

You can browse available community roles [here](https://galaxy.ansible.com/home)

We will be using a [MySQL role developed by `geerlingguy`](https://galaxy.ansible.com/geerlingguy/mysql). 

**Hint:** To preserve your your GitHub in actual state after you install a new role - make a commit and push to master your 'ansible-config-mgt' directory. Of course you must have `git` installed and configured on `Jenkins-Ansible` server and, for more convenient work with codes, you can configure Visual Studio Code to work with this directory. In this case, you will no longer need webhook and Jenkins jobs to update your codes on `Jenkins-Ansible` server, so you can disable it - we will be using Jenkins later for a better purpose.

On `Jenkins-Ansible` server make sure that `git` is installed with `git --version`, then go to 'ansible-config-mgt' directory and run

```
git init
git pull https://github.com/<your-name>/ansible-config-mgt.git
git remote add origin https://github.com/<your-name>/ansible-config-mgt.git
git branch roles-feature
git switch roles-feature
```

Inside `roles` directory create your new MySQL role with `ansible-galaxy install geerlingguy.mysql` and rename the folder to `mysql`

```
mv geerlingguy.mysql/ mysql
```

Read `README.md` file, and edit roles configuration to use correct credentials for MySQL required for the `tooling` website. 

Now it is time to upload the changes into your GitHub:

```
git add .
git commit -m "Commit new role files into GitHub"
git push --set-upstream origin roles-feature
```

Now, if you are satisfied with your codes, you can create a Pull Request and merge it to `main` branch on GitHub.

#### Load Balancer roles

We want to be able to choose which Load Balancer to use, `Nginx` or `Apache`, so we need to have two roles respectively:

1. Nginx
2. Apache 

With your experience on Ansible so far you can: 

- Decide if you want to develop your own roles, or find available ones from the community
- Update both `static-assignment` and `site.yml` files to refer the roles


***Important Hints:***

- Since you cannot use both **Nginx** and **Apache** load balancer, you need to add a condition to enable either one - this is where you can make use of variables.

- Declare a variable in `defaults/main.yml` file inside the Nginx and Apache roles. Name each variables `enable_nginx_lb` and `enable_apache_lb` respectively. 
- Set both values to false like this `enable_nginx_lb: false` and `enable_apache_lb: false`.
- Declare another variable in both roles `load_balancer_is_required` and set its value to `false` as well
- Update both assignment and site.yml files respectively

`loadbalancers.yml` file
```
- hosts: lb
  roles:
    - { role: nginx, when: enable_nginx_lb and load_balancer_is_required }
    - { role: apache, when: enable_apache_lb and load_balancer_is_required }
```

`site.yml` file
```
     - name: Loadbalancers assignment
       hosts: lb
         - import_playbook: ../static-assignments/loadbalancers.yml
        when: load_balancer_is_required 
```

Now you can make use of `env-vars\uat.yml` file to define which loadbalancer to use in UAT environment by setting respective environmental variable to `true`.

You will activate load balancer, and enable `nginx` by setting these in the respective environment's env-vars file. 

```
enable_nginx_lb: true
load_balancer_is_required: true
```

The same must work with `apache` LB, so you can switch it by setting respective environmental variable to `true` and other to `false`.

To test this, you can update inventory for each environment and run Ansible against each environment. 

#### Congratulations! 

You have learned and practiced how to use Ansible configuration management tool to prepare UAT environment for Tooling web solution.

![](https://dareyio-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project13/great_job13.png)

#### Next project

Next project is a capstone project for this part of your **Project Based Learning** journey - it will require all previously gained knowledge and skills, and introduce more new and exciting concepts and DevOps tools! 

Get ready for new challenges ahead! Full Speed Forward!

![](https://dareyio-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project13/full-throttle-closeup_13.jpg)
