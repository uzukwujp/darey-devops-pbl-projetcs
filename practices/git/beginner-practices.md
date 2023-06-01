# Exercise 1: Initializing a Repository and Making Commits

### Create a new directory on your local machine
```
mkdir darey-devops-repo
```

### Navigate to the directory
```
cd darey-devops-repo
```

### Initialize a new Git repository
```
git init
```

### Configure Git with your username and email

```
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

# Check the status of your repository

```
git status
```

Now, create a new file inside the repository, such as index.html. (Use Linux commands to create this file) After creating the file, use the following git commands:

### Add the file to the staging area

```
git add index.html
```

- Write some content inside the file

### Check the status to see the changes being staged
```
git status
```

### Make a commit with a descriptive message
```
git commit -m "Initial commit"
```

### Check the status to verify that the commit was made

```
git status
```

### Repeat the process of creating files, adding them to the staging area, making commits, and checking the status as needed.


# Exercise 2: Working with Branches



### Create a new branch
```
git branch darey-new-feature
```


### Switch to the new branch
```
git checkout darey-new-feature
```

### Check the status to see the branch switch
```
git status
```

Make some changes to files in the branch, such as modifying index.html. Then, add and commit the changes:


### Add the modified file
```
git add index.html
```

### Check the status to see the changes being staged
```
git status
```

### Make a commit
```
git commit -m "Implement new feature"
```

### Check the status to verify that the commit was made
```
git status
```

### Switch back to the main branch:
```
git checkout main
```

### Check the status to see the branch switch
```
git status
```

### Merge the changes from the branch into the main branch:
```
git merge darey-new-feature
```

### Check the status to verify that the merge was successful

```
git status
```

### Resolve any merge conflicts if necessary and check the status again.

# Exercise 3: Collaboration and Remote Repositories

### First, create a new repository on a remote Git hosting platform like GitHub or GitLab. Then, clone the remote repository to your local machine: Ensure to select "https" and not "ssh"

```
git clone <remote-repo-url>
```

### Check the status to see the cloned repository
```
git status
```

#### Make some changes to files in the local repository and commit them:

### Add the modified file(s)
```
git add .
```

### Check the status to see the changes being staged
```
git status
```

### Make a commit
```
git commit -m "Update files"
```

### Check the status to verify that the commit was made
```
git status
```

### Push the changes to the remote repository:
```
git push origin main
```

### Check the status to verify that the push was successful

```
git status
```

### Simulate another collaborator working on your  repository. Clone the repository into another folder on your local machine. Make changes, commit them, and push them to the remote repository as well.


- To pull the changes from the remote repository to your local repository:
```
git pull origin main
```

### Check the status to see the changes pulled from the remote repository
```
git status
```

# Exercise 4: Branch Management and Tagging

### Create a new branch
```
git branch new-branch
```

### Switch to the new branch
```
git checkout new-branch
```

### Check the status to see the branch switch
```
git status
```

Make several commits on the branch to implement changes. Then, push the branch to the remote repository
