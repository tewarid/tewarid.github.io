# A Mutable Log

Head over to https://tewarid.github.io to view posts.

Some useful tips to work with this blog

* Use [VS Code](_posts\2017\2017-12-04-word-to-markdown-using-pandoc.md#markdown-editor), and its [myriad plugins](.vscode/extensions.json), to edit and preview posts

* Run site locally in a Docker container at http://localhost:4000

  ```bash
  ./run-docker.sh
  ```

  This works well but I've run into a situation where the Docker container [uses excessive CPU time](https://github.com/docker/for-mac/issues/1759) on macOS while idling.

* [Don´t use](https://github.com/jekyll/jekyll/issues/429) UTF-8 characters in file names of posts

* Use `rename.sh` Bash script to rename all posts in a folder using title specified in Front Matter

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

* A custom slate theme is configured in [_config.yml](_config.yml) and is sourced from [https://github.com/tewarid/slate](https://github.com/tewarid/slate).
