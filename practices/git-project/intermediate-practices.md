Exercise 1: Branching and Merging

Create a new branch named "feature/login" and switch to it.

bash
Copy code
git branch feature/login
git checkout feature/login
Make changes to a file and commit the changes.

bash
Copy code
# Make changes to the file
# ...

# Add the modified file to the staging area
git add filename

# Commit the changes
git commit -m "Implement login feature"
Switch back to the main branch.

bash
Copy code
git checkout main
Create a new branch named "feature/registration" and switch to it.

bash
Copy code
git branch feature/registration
git checkout feature/registration
Make changes to another file and commit the changes.

bash
Copy code
# Make changes to the file
# ...

# Add the modified file to the staging area
git add filename

# Commit the changes
git commit -m "Implement registration feature"
Merge the "feature/login" branch into the "feature/registration" branch.

bash
Copy code
git merge feature/login
Resolve any merge conflicts if necessary.

bash
Copy code
# Open the files with conflicts and resolve the conflicts manually
# ...

# Add the resolved files to the staging area
git add filename

# Commit the merge changes
git commit -m "Merge feature/login into feature/registration"
Push the merged changes to the remote repository.

bash
Copy code
git push origin feature/registration
Exercise 2: Reverting Changes

Create a new branch named "bugfix/error" and switch to it.

bash
Copy code
git branch bugfix/error
git checkout bugfix/error
Make changes to a file and commit the changes.

bash
Copy code
# Make changes to the file
# ...

# Add the modified file to the staging area
git add filename

# Commit the changes
git commit -m "Fix error"
Realize the changes introduced an error and need to be reverted.

bash
Copy code
# Revert the last commit, creating a new commit that undoes the changes
git revert HEAD
Push the changes to the remote repository.

bash
Copy code
git push origin bugfix/error
Exercise 3: Git Stash

Create a new branch named "feature/new-feature" and switch to it.

bash
Copy code
git branch feature/new-feature
git checkout feature/new-feature
Make changes to files and stage some of the changes.

bash
Copy code
# Make changes to files
# ...

# Add some changes to the staging area
git add file1

# Check the status
git status
Stash the remaining changes without committing them.

bash
Copy code
git stash

# Check the status to verify that changes are stashed
git status
Switch back to the main branch.

bash
Copy code
git checkout main
Create a new branch named "bugfix/issue" and switch to it.

bash
Copy code
git branch bugfix/issue
git checkout bugfix/issue
Apply the stashed changes.

bash
Copy code
git stash apply





User
continue
ChatGPT
Commit the changes and push them to the remote repository.
bash
Copy code
# Add the modified files to the staging area
git add file1

# Commit the changes
git commit -m "Implement new feature"

# Push the changes to the remote repository
git push origin bugfix/issue
Exercise 4: Managing Tags

Create a lightweight tag named "v1.0" at the current commit.

bash
Copy code
git tag v1.0

# Push the tag to the remote repository
git push origin v1.0
Create an annotated tag named "v1.1" with a tag message.

bash
Copy code
git tag -a v1.1 -m "Release v1.1"

# Push the tag to the remote repository
git push origin v1.1
List all available tags in the repository.

bash
Copy code
git tag

# To see more details about the tags
git show v1.0
git show v1.1
Delete the "v1.0" tag.

bash
Copy code
git tag -d v1.0

# Remove the tag from the remote repository
git push origin --delete v1.0
Exercise 5: Working with Remote Branches

Clone a remote repository to your local machine.

bash
Copy code
git clone <remote-repo-url>
Create a new branch named "feature/awesome-feature" and switch to it.

bash
Copy code
git branch feature/awesome-feature
git checkout feature/awesome-feature
Make changes to files and commit the changes.

bash
Copy code
# Make changes to files
# ...

# Add the modified files to the staging area
git add .

# Commit the changes
git commit -m "Implement awesome feature"
Push the branch to the remote repository.

bash
Copy code
git push origin feature/awesome-feature
Open a pull request for the branch on the remote repository.

Visit the repository's website and open a pull request for the "feature/awesome-feature" branch.
Review and merge the pull request using the repository's interface.

Once the pull request is reviewed and approved, merge it using the provided options on the website.
Remember to use git status, git log, and git diff commands at different stages to check the status, view commit history, and see differences in your repository. These exercises will help strengthen your Git skills and provide practical experience with branching, merging, reverting changes, using stash, managing tags, and collaborating with remote repositories.