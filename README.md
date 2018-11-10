# My Blog

Head over to https://tewarid.github.io to view the blog.

Some useful tips to work with this Jekyll blog

* Run blog locally in a Docker container at http://localhost:4000

    ```bash
    ./run-docker.sh
    ```

    This works well but I've run into a situation where the Docker container [uses excessive CPU time](https://github.com/docker/for-mac/issues/1759) on macOS while idling.

* Use `rename.sh` Bash script to rename all posts in a folder using title specified in Front Matter.

* mermaid.js diagrams can be inserted as follows

    ```html
    <div class="mermaid" style="height:300px;">
    classDiagram
        Primate <|-- Gorilla : is a
        Primate : int id
        Primate : brainSize()
    </div>
    ```

* LaTeX can be inserted inline `$$\LaTeX$$` or as a block

    ```latex
    $$
    \LaTeX
    $$
    ```

* Section heading in posts start at level 3 i.e. three successive #. Level 1 and 2 are reserved for blog title and post title, respectively.

* [Don´t use](https://github.com/jekyll/jekyll/issues/429) UTF-8 characters in file name of posts.
