---
layout: default
title: Working with multiple git remotes
tags: git remote multiple
---

This post discusses useful git commands when working with multiple git remotes such as to share code with distributed teams.

We are all familiar with the clone command

```bash
git clone repository_url
```

This creates a local working copy of the remote, identified by the short name origin. You can see all the remote repositories in your working copy thus

```bash
git remote -v
```

The following command fetches commits from origin

```bash
git pull
```

The following command pushes local commits to origin

```bash
git push
```

What if you want to share your copy of the repository so that another team can work on it? Maybe to a new remote repository shared with that team?

This can be done as follows

```bash
git remote add repo_short_name repository_url
git push repo_short_name master
```

You can pull changes from the new repository

```bash
git pull repo_short_name master
```

And push them to origin (origin is assumed if not specified)

```bash
git push origin
```

If a remote has conflicting commits that you want to favor

```bash
git pull -s recursive -X theirs repo_short_name master
```

Pull and rebase on top of remote

```bash
git pull --rebase repo_short_name master
```

For more information on working with remote repositories see [chapter 2](https://git-scm.com/book/ch2-5.html) of the free [Git book](https://git-scm.com/book).

Once you have mastered the command line, you can do all of the same things using a Git client such as the free [SourceTree](https://www.sourcetreeapp.com/) app from the folks at Atlassian.
