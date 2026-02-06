# Template Repository

Please use this Repository to create all other Repositories. This ensures we follow correct code/configuration structure.

*Please read this entire document ensuring that all steps are completed.*

## Creating New Repository

### Create Code Repository

Please follow the steps to create a code repository:

- [ ] Open the template repository
- [ ] Click "*Use this template*"
- [ ] **Do Not** tick the "*Include all branches*" box
- [ ] Select the organisation where your new repository will be placed
- [ ] Give the repository a useful name, that relates to the project (*ie - python-suduko-solver*)
- [ ] Give the repository a suitable description that describes its purpose (*ie - Repository to store code to solve a suduko puzzle*)

### Create Template Repository

Please follow the steps to create a template repository:

- [ ] Open the template repository
- [ ] Click "*Use this template*"
- [ ] **Do Not** tick the "*Include all branches*" box
- [ ] Select the organisation where your new repository will be placed
- [ ] Give the repository a useful name, that relates to the project (*ie - python-template*)
- [ ] Give the repository a suitable description that describes its purpose (*ie - Template repository for python projects*)
- [ ] Go into settings on the repository and tick the "*Template repository*" button

## Clone Repository

### Create Local Folder Structure

On your computer, create the following folder structure:

```text
C:\
├── GitRepo
    ├── GitHub
        ├── Organisation1
        ├── Organisation2
    ├── GitLab
    ├── DevOps
```

*For Example:*

```text
C:\
├── GitRepo
    ├── GitHub
        ├── curtis-personal-templates
```

### Run Repository Clone

Open the gitbash app and run the following to clone your repository:

```bash
cd <local organisation location for repository>
git clone https://github.com/<organisation-name>/<repo-name>.git
```

*Example:*

```bash
cd C:\\GitRepo\GitHub\curtis-personal-templates
git clone https://github.com/curtis-personal-templates/test.git

```

This will automatically create you a folder in C:\ with your repository name. *Please see the below example of the directory structure:*

```text
C:\
├── GitRepo
    ├── GitHub
        ├── curtis-personal-templates
            ├── general-template
```

## Branching Approach

The following approach should be used when creating and using git branches:

- development
- feature/\<feature-name>
- release/\<release-version>
- hotfix/\<hotfix-version>

*For Example:*

- development
- feature/**login**
- feature/**payment-processing**
- release/**v1.0.0**
- release/**v1.0.2**
- hotfix/**bug-fix-123**
- hotfix/**bug-fix-124**

## Update README Files

Now that you have cloned the Repository and completed all steps in this document, update the README files so we have the correct files loading by default:

- [ ] Rename the README.md file to COMPLETE_README.md
- [ ] Rename the README_Template.md file to README.md
- [ ] Review README.md and update the document with details of the new repository
- [ ] Update all the "[ ]" fields to "[X]" to mark as complete
- [ ] Save and push the updated README files to GitHub
