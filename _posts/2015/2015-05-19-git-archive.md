---
layout: default
title: git archive
tags: git archive
---

To quickly get a source distribution in zip format

```bash
git archive --format=zip -o source.zip HEAD source/ README
```

Assuming source code is under the folder `source`, `README` is a file in the same folder as `source`. Subfolders ignored by `.gitignore` are not archived. You can replace `HEAD` with a commit label. `zip` can be replaced with `tar` or `tar.gz`. Try `man git-archive` for more details.
