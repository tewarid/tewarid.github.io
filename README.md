# My Blog

Head over to https://tewarid.github.io to view the blog.

Some useful tips to work with this Jekyll blog

* Run blog locally in a Docker container at http://localhost:4000

    ```bash
    ./run-docker.sh
    ```

    This works well but I've run into a situation where the Docker container [uses excessive CPU time](https://github.com/docker/for-mac/issues/1759) on macOS while idling.

* Command to rename all posts in a folder using title specified in Front Matter

    ```bash
    for i in *.md; do v=`grep title: $i`; v=${v:7}; v=`echo ${v} | awk '{print tolower($0)}'`; v=`echo ${v//[ \/?\":]/-}`; mv ${i} ${i:0:10}-$v.md; done
    ```

* LaTeX can be inserted inline `$$\LaTeX$$` or as a block

    ```latex
    $$
    \LaTeX
    $$
    ```
