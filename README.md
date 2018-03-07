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

* Useful [WordPress REST API](https://developer.wordpress.com/docs/api/) endpoints

    * https://public-api.wordpress.com/rest/v1.1/sites/delog.wordpress.com/comments?number=100&page=1

        List of recent comments of a site. Returns 20 comments without the `number` option. Use the `page` option to fetch the next set of comments.

    * https://public-api.wordpress.com/rest/v1.1/sites/delog.wordpress.com/posts?number=100&page_handle=value%3D2014-11-26T14%253A24%253A37-03%253A00%26id%3D5796

        List of posts. Returns 20 posts without the `number` option. Specify `page_handle` option as the URL-encoded value of the `next_page` property in the `meta` section.
