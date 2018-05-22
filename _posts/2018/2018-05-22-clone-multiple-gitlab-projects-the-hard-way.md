---
layout: default
title: Clone multiple GitLab projects the hard way
tags: git gitlab clone
comments: true
---

We have this really big list of projects in a GitLab group/namespace hosted at&mdash;let's say&mdash;https://example.com/groups/bigone. I wanted to clone all the projects there, and do some additional housekeeping in the cloned repository such as change the email address, and add another remote location.

Now, there are easy ways to do this using the GitLab API, but we're trying to do this the hard way, remember?

I used Chrome's Developer Tools on the page above, and discovered that each time it was hit, it also hit https://example.com/groups/bigone/-/children.json?page=n, where n is 1 for the first page, 2 for the second page, and so on.

I copied JSON returned for each page, joined it, and reformatted it using Code so it looks like

```json
[
    {
        "id": 1,
        "name": "project1",
        "description": "Project 1",
        "visibility": "private",
        "full_name": "bigone / project1",
        "created_at": "2015-11-11T20:08:08.798Z",
        "updated_at": "2017-12-23T13:39:26.901Z",
        "avatar_url": null,
        "type": "project",
        "can_edit": true,
        "edit_path": "/bigone/project1/edit",
        "relative_path": "/bigone/project1",
        "permission": null,
        "star_count": 4,
        "markdown_description": "\u003cp dir=\"auto\"\u003eProject 1\u003c/p\u003e"
    },
    {
        "id": 2,
        "name": "project2",
        "description": "Project 2",
        "visibility": "private",
        "full_name": "bigone / project2",
        "created_at": "2015-12-22T06:55:26.131Z",
        "updated_at": "2018-04-23T18:10:33.845Z",
        "avatar_url": null,
        "type": "project",
        "can_edit": true,
        "edit_path": "/bigone/project2/edit",
        "relative_path": "/bigone/project2",
        "permission": null,
        "star_count": 4,
        "markdown_description": "\u003cp dir=\"auto\"\u003eProject 2\u003c/p\u003e"
    },
    ...
]
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
