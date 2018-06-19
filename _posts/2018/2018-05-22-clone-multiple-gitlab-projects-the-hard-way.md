---
layout: default
title: Clone multiple GitLab projects the hard way
tags: git gitlab clone
comments: true
---

We have this really big list of projects in a GitLab group/namespace hosted at&mdash;let's say&mdash;https://example.com/groups/bigone. I wanted to clone all the projects there, and do some additional housekeeping in the cloned repository such as configure the email address, and add another remote location.

Now, there are easy ways to do this using the [GitLab API](https://docs.gitlab.com/ce/api/README.html) and some coding, but we're trying to do this the hard way, remember?

Version 4 of the GitLab API can be accessed at https://example.com/api/v4.

The first step is to find the id of the group we're interested in

```text
https://example.com/api/v4/groups?search=bigone
```

Next, we list all the projects in the group using its id, 84 in this case

```text
https://example.com/api/v4/groups/84/projects?simple=true&order_by=name&sort=asc
```

I copied the JSON returned by the above query to Code, and reformatted it so it looks like

```json
[
    {
        "id": 846,
        "description": "Project 1",
        "name": "project1",
        "name_with_namespace": "bigone / project1",
        "path": "project1",
        "path_with_namespace": "bigone/project1",
        "created_at": "2018-02-15T15:32:17.966Z",
        "default_branch": "master",
        "tag_list": [],
        "ssh_url_to_repo": "git@example.com:bigone/project1.git",
        "http_url_to_repo": "https://example.com/bigone/project1.git",
        "web_url": "https://example.com/bigone/project1",
        "avatar_url": null,
        "star_count": 0,
        "forks_count": 0,
        "last_activity_at": "2018-02-16T20:48:08.377Z"
    },
    {
        "id": 680,
        "description": "Project 2",
        "name": "project2",
        "name_with_namespace": "bigone / project2",
        "path": "project2",
        "path_with_namespace": "bigone/project2",
        "created_at": "2017-10-25T14:29:55.195Z",
        "default_branch": null,
        "tag_list": [],
        "ssh_url_to_repo": "git@example.com:bigone/project2.git",
        "http_url_to_repo": "https://example.com/bigone/project2.git",
        "web_url": "https://example.com/bigone/project2",
        "avatar_url": null,
        "star_count": 0,
        "forks_count": 0,
        "last_activity_at": "2017-10-25T14:29:55.195Z"
    },
...
```

The above query only returns the first page, so I repeated the above query a few times&mdash;incrementing the page parameter&mdash;until I had a complete list of projects

```
https://example.com/api/v4/groups/84/projects?simple=true&order_by=name&sort=asc&page=2
```

Next, I used the [JSON Transform](https://marketplace.visualstudio.com/items?itemName=octref.vscode-json-transform) plugin of Code to [transform](http://jmespath.org/tutorial.html)&mdash;with `[].name`&mdash;the above JSON to

```json
[
  "project1",
  "project2",
  ...
]
```

Next, I used regular expression search&mdash;`^  "(.*)",`&mdash;and replace&mdash;`git clone git@example.com:bigone/$1.git; cd $1; git remote add other git@other.com:bigone/$1.git; git config user.email me@example.com; cd ..`&mdash;and some editing, to produce this

```bash
#!/bin/bash
git clone git@example.com:bigone/project1.git; cd project1; git remote add other git@other.com:bigone/project1.git; git config user.email me@example.com; cd ..
git clone git@example.com:bigone/project2.git; cd project2; git remote add other git@other.com:bigone/project2.git; git config user.email me@example.com; cd ..
...
```

That was all I needed to clone all the projects in the big GitLab group, and set them up properly.

To wrap it up, here's the command I run to sync all the remotes

```bash
find . -maxdepth 1 -not -path . -not -path '*/\.*' -exec sh -c 'echo {}; cd {}; git pull; git push other master' \;
```
