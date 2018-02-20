---
layout: default
title: git branch
tags: git branch
---

This post lists some useful Git commands related to branching and merging. _remote_ is used as a generic placeholder for remote name below. It may be origin. _branch_ is used for branch name.

List all branches

```bash
git branch -v
```

List all remote branches

```bash
git branch -r -v
```

See status log with branch refs

```bash
git log --decorate=full
```

Pull changes in specified remote branch, merge and commit into current branch

```bash
git pull remote branch
```

Fetch changes from remote branch into FETCH_HEAD, but continue on current branch

```bash
git fetch remote branch
```

Switch to FETCH_HEAD branch

```bash
git checkout FETCH_HEAD
```

Create a new branch with specified name from current start point

```bash
git checkout -b branch
```

Switch to master branch of origin

```bash
git checkout master
```

Merge and commit changes in specified branch into the current branch

```bash
git merge remote/branch
```

Merge changes in specified branch, result available in working tree to commit (history is not preserved)

```bash
git merge --squash remote/branch
```

Run your favorite merge tool to resolve conflicts (I use [meld](http://meldmerge.org/), [on Mac OS X](https://yousseb.github.io/meld/))

```bash
git mergetool -t meld
```

Diff of file with version on HEAD (or branch name)

```bash
git diff [--cached] HEAD file
```

Delete a local branch

```bash
git branch -d branch
```

Delete remote branch in cloned repo (can restore from origin with pull)

```bash
git branch -d -r remote/branch
```

Permanently delete branch ref from remote (use caution)

```bash
git push remote --delete branch
## OR
git push remote :branch
```

Create a new branch at current start point, but continue on current branch

```bash
git branch branch
```

Checkout and switch to a branch, or start tracking and switch to a remote branch with same name

```bash
git checkout branch
```

Push branch to remote (add -f to force update)

```bash
git push [-f] remote branch
```

Push all branches to remote

```bash
git push --all remote
```

Track the specified remote branch as upstream

```bash
git branch -u remote/branch
```

Reset to previous commit on current branch

```bash
git reset HEAD~
```
