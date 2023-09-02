#### Step 7 - Run first Ansible test

Now, it is time to execute `ansible-playbook` command and verify if your playbook actually works: 


1. Setup your VSCode to connect to your instance as demonstrated by the video above. Now run your playbook using the command:

```
cd ansible-config-mgt
```
```
ansible-playbook -i inventory/dev.yml playbooks/common.yml
```

ansible-playbook -i inventory/dev.yml playbooks/common.yml


**Note:** Make sure you're in your `ansible-config-mgt` directory before you run the above command.

You can go to each of the servers and check if `wireshark` has been installed by running `which wireshark` or `wireshark --version`

 <img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project11/wireshark.png" title="version" width="936px" height="550px">
  
Your updated with Ansible architecture now looks like this:

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project11/ansible_architecture.png" width="936px" height="550px">
#### Optional step - Repeat once again

Update your ansible playbook with some new Ansible tasks and go through the full `checkout -> change codes -> commit -> PR -> merge -> build -> ansible-playbook` cycle again to see how easily you can manage a servers fleet of any size with just one command!

#### Congratulations

You have just automated your routine tasks by implementing your first Ansible project! There is more exciting projects ahead, so lets keep it moving!

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project11/greatjob11.png" width="936px" height="550px">

