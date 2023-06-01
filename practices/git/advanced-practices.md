Exercise 1: Rewriting History

Create a new branch named "experimental" and switch to it.

bash
Copy code
git branch experimental
git checkout experimental
Make several commits, introducing new features or changes.

bash
Copy code
# Make changes to files
# ...

# Add the modified files to the staging area
git add .

# Commit the changes
git commit -m "Add feature A"

# Repeat the above steps for multiple commits
Use an interactive rebase to squash the last three commits into one.

bash
Copy code
git rebase -i HEAD~3
In the interactive rebase window, change the pick command to squash (or s) for the commits you want to squash into the previous commit.

Amend the commit message of the first commit.

bash
Copy code
git commit --amend
Update the commit message in your editor that opens.

Push the changes to the remote repository, replacing the existing branch.

bash
Copy code
git push origin experimental --force
Exercise 2: Resolving Complex Merge Conflicts

Create a new branch named "feature/complex" and switch to it.

bash
Copy code
git branch feature/complex
git checkout feature/complex
Make changes to a file on this branch and commit the changes.

bash
Copy code
# Make changes to the file
# ...

# Add the modified file to the staging area
git add filename

# Commit the changes
git commit -m "Implement complex feature"
Switch back to the main branch.

bash
Copy code
git checkout main
Make conflicting changes to the same file on the main branch and commit them.

bash
Copy code
# Make conflicting changes to the file
# ...

# Add the modified file to the staging area
git add filename

# Commit the changes
git commit -m "Make conflicting changes"
Attempt to merge the "feature/complex" branch into the main branch.

bash
Copy code
git merge feature/complex
This will result in a merge conflict.

Resolve the merge conflicts manually, keeping the desired changes.

bash
Copy code
# Open the files with conflicts and resolve the conflicts manually
# ...

# Add the resolved files to the staging area
git add filename

# Continue the merge process
git merge --continue
Commit the merge resolution and push the changes to the remote repository.

bash
Copy code
git commit -m "Resolve merge conflict"
git push origin main
Exercise 3: Working with Submodules

Create a new repository that will act as the main repository.

bash
Copy code
# Create a new repository on a remote Git hosting platform (e.g., GitHub)
# ...

# Clone the remote repository to your local machine
git clone <remote-main-repo-url>
cd main-repo
Add an existing repository as a submodule to the main repository.

bash
Copy code
git submodule add <submodule-repo-url> <submodule-directory>
Clone the main repository to your local machine.

bash
Copy code
git clone <remote-main-repo-url>
cd main-repo
Initialize and update the submodules within the main repository.

bash
Copy code




User
continue
ChatGPT
bash
Copy code
   git submodule init
   git submodule update
Make changes to the submodule and commit them.

bash
Copy code
cd submodule-directory

# Make changes to files within the submodule
# ...

# Add the modified files to the staging area
git add .

# Commit the changes within the submodule
git commit -m "Update submodule"

cd ..
Update the main repository to reflect the latest changes in the submodule.

bash
Copy code
git submodule update --remote
Push the changes to both the main repository and the submodule.

bash
Copy code
# Push the changes in the main repository
git push origin main

# Push the changes in the submodule
cd submodule-directory
git push origin main
Exercise 4: Advanced Branch Management

Create a new branch named "hotfix/bug" and switch to it.

bash
Copy code
git branch hotfix/bug
git checkout hotfix/bug
Make changes to fix a critical bug and commit the changes.

bash
Copy code
# Make changes to fix the bug
# ...

# Add the modified files to the staging area
git add .

# Commit the changes
git commit -m "Fix critical bug"
Push the branch to the remote repository.

bash
Copy code
git push origin hotfix/bug
Create a new branch named "release/v1.0" from the latest commit on the main branch.

bash
Copy code
git branch release/v1.0 main
Cherry-pick the bug fix commit from the "hotfix/bug" branch into the "release/v1.0" branch.

bash
Copy code
git cherry-pick <commit-hash>
Push the "release/v1.0" branch to the remote repository.

bash
Copy code
git push origin release/v1.0
Tag the latest commit on the "release/v1.0" branch as "v1.0".

bash
Copy code
git tag v1.0 release/v1.0

# Push the tag to the remote repository
git push origin v1.0
Exercise 5: Git Hooks

Create a new Git repository on your local machine.

bash
Copy code
mkdir my-repo
cd my-repo
git init
Set up a pre-commit hook that checks for code formatting before committing.

bash
Copy code
# Create a pre-commit hook file
touch .git/hooks/pre-commit

# Open the pre-commit hook file in an editor
nano .git/hooks/pre-commit
Inside the pre-commit hook file, add the code to run the code formatting check. For example, you can use a linter or a code formatter tool.

Create a new file with formatting issues and attempt to commit it.

bash
Copy code
# Create a new file with formatting issues
echo "print('Hello, World!')" > myfile.py

# Stage the file for commit
git add myfile.py

# Attempt to commit
git commit -m "Add myfile.py"
The pre-commit hook should prevent the commit due to formatting errors.

Observe the hook preventing the commit due to formatting errors.

Fix the formatting issues and commit the file.

bash
Copy code
# Fix the formatting issues in myfile.py
# ...

# Stage the file again




User
continue
ChatGPT
bash
Copy code
   git add myfile.py

   # Commit the file
   git commit -m "Add myfile.py"
Set up a post-commit hook that triggers an action after each commit.

bash
Copy code
# Create a post-commit hook file
touch .git/hooks/post-commit

# Open the post-commit hook file in an editor
nano .git/hooks/post-commit
Inside the post-commit hook file, add the code to perform the desired action after each commit. For example, you can send a notification, trigger a build process, or execute a script.

Customize the post-commit hook to send a notification or execute a script.

bash
Copy code
# Modify the post-commit hook file with the desired action
# ...
Remember to make the hook files executable by running chmod +x .git/hooks/pre-commit and chmod +x .git/hooks/post-commit to ensure they can be executed.

These advanced exercises provide hands-on experience with rewriting history, resolving complex merge conflicts, working with submodules, advanced branch management, and utilizing Git hooks. Practice these exercises to enhance your Git skills and gain a deeper understanding of its advanced functionalities.