# A Mutable Log

Head over to https://tewarid.github.io to view posts.

Some useful tips to work with this log

* [Use](_posts\2017\2017-12-04-word-to-markdown-using-pandoc.md#markdown-editor) VS Code, and its myriad plugins, to edit and preview posts

* Run site locally in a Docker container at http://localhost:4000

    ```bash
    ./run-docker.sh
    ```

    This works well but I've run into a situation where the Docker container [uses excessive CPU time](https://github.com/docker/for-mac/issues/1759) on macOS while idling.

* Use `rename.sh` Bash script to rename all posts in a folder using title specified in Front Matter

* Using Jekyll filters and tags in markdown makes it less portable, I suggest using them only in the following situations

    * Add link to a post as follows

    ```liquid
    [posted]({% link _posts/2018/2018-03-23-status-of-popular-markup-language-standards.md %})
    ```

    * Insert source code from a GitHub gist as follows

    ```liquid
    {% gist 300cd9b377774598478a5ab852ae4d7e %}
    ```

* mermaid.js diagrams can be inserted as follows

    ````text
    ```mermaid
    classDiagram
        Primate <|-- Gorilla : is a
        Primate : int id
        Primate : brainSize()
    ```
    ````

* LaTeX can be inserted inline `$$\LaTeX$$` or as a block

    ```latex
    $$
    \LaTeX
    $$
    ```

    Preview in Code using the following setting for Markdown+Math plugin

    ```json
    "mdmath.delimiters": "kramdown",
    ```

* [Don´t use](https://github.com/jekyll/jekyll/issues/429) UTF-8 characters in file names of posts
