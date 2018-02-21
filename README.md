# My Blog

Head over to https://tewarid.github.io to view the blog.

Some useful tips to work with this Jekyll blog

* Run blog locally using Docker at http://localhost:4000

    ```bash
    ./run-docker.sh
    ```

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
