# Developer documentation

This document describes the best practices to be followed when working with 
[Git](https://git-scm.com/) and [GitLab](https://gitlab.com) in this project. 

!!! note

    We *strongly* suggest you use Git from the *command line*.
    Our suggestion is `zsh` with [Oh my ZSH!](https://ohmyz.sh/) on Unix
    and [Babun](http://babun.github.io/) on Windows.

## The Goals

The goals we want to achieve are

* to have a *codebase* that is manageable and *well documented*
* to communicate among the members of the team as conveniently as possible
* to know and document what each one of us is doing

To achieve these goals, we will use the features of Git and Gitlab.

## The recomended Workflow

!!! note

    A *workflow* is a way of doing things.
    It can help us or present a burden.

### Overview

1. Create an issue
3. Create a WIP merge request linking to the issue
4. Code, test, commit, code, test, commit, ... (in your branch)
5. Rebase your branch to `master`
6. Remove WIP from the merge request and invite someone to review your changes
7. Merge the code to `master`, remove the source branch and close the issue

### Create an issue

Issues should be the primary source for documenting the development process. 
Label issues apropriatelly and use milestones to group issues.

### Create a WIP merge request

[WIP merge request](https://about.gitlab.com/2016/01/08/feature-highlight-wip/)
is a way to create a merge request that can not be accidentally merged until is ready.
Creating a WIP merge requests will help others on your team to better understand
what it is that you are doing at the moment,
and what is the purpose of different branches.

!!! note

    If you make a merge request from issue, gitlab automatically makes it WIP, 
    creates a new branch and adds a link to the issue. The issue is automatically closed once the mere request is accepted.

!!! warning "Don't forget!"

    Checkout newly created branch, before you start coding
    ```
    git fetch
    git checkout 314-my-awesome-pi
    ```

### Code, test, commit, code

Now you can finaly start coding. 

!!! note "Remember to"

    * make incremental commits 
    * test the code with automated tests
    * write your own tests that test your new feature


### Rebase your branch onto `master`

Rebasing is similar to merging, but the order of commits is rearanged so that we get a linear history.
Make sure you read about
[Merging vs. Rebasing](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)
before you proceed.

!!! warning

    *Never rebase the `master` branch onto any other branch!!!*

To rebase your branch onto master

    git fetch origin master
    git checkout my-new-feature
    git rebase master

After rebase, the commits of your branch will simply follow the tip of `master` branch.

If Git can not merge automatically,
read the message carefully and proceed as suggested. 


!!! note

    If git complains with `error: failed to push some refs to ...` you c
    an use a switch `--force-with-lease` which is a safer variant of `--force`

!!! warning 

    *Never `push --force` to the origin!!!*


### Invite someone to review your changes

Remove WIP from the merge request and invite someone to review your changes
by mentioning them in a comment to the merge request.

!!! note "Remember to"

    * remove WIP from the title
    * mention the `@nicknames` of whoever you want to review the changes

### Merge the code to `master`, remove the source branch and close the issue


## Dos and don'ts

### Everything should be in Git
Every contribution in text format and especially *the code itself*
*should be put into the Git version control system*.

### Don't commit in `master`!

!!! tip "Don't commit in master"

    **Use branches!!!**

Create a branch and merge with `master` when your changes are ready.
The exceptions are minor chanages
(code that does not affect core functionality like printing to console, etc.)
or changes that do not touch the code itself,
like documentation, comments, print statements, indentation, etc.
*The `master` branch should always pass all tests.*

### Commit frequently

!!! tip

    Every change that is rounded should be committed.

If a change can be split into two separate changes that make sense on their own,
then do this.
Exceptions to the rule are the initial commits and commits of new features -
however, the next rule still applies.

### DOs and DON'Ts of commit messages

Don't:

* *Don't end the summary line with a period*
  as it is a title and these don't end with periods.

Do:

* *Use the imperative mode* when writing the summary line
  and describing what you have done,
  as if you were commanding someone -
  e.g., start the line with _Fix_, _Add_, _Change_
  instead of _Fixed_, _Added_, _Changed_;
* *Leave the second line blank*;
* *Line break the commit message* and make it readable
  without having to scroll horizontally (line = 80 characters).

!!! tip

    If you feel it's difficult to summarize what you are trying to commit,
    this may be due to the nature of the commit,
    which would be better split up into several separate commits.

## See also
    
 * GitHub's [Writing good commit messages](https://github.com/erlang/otp/wiki/writing-good-commit-messages) article 
 * [chapter 5 of the Git book](https://git-scm.com/book/ch5-2.html)