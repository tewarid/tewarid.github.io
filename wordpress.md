# Useful [WordPress REST API](https://developer.wordpress.com/docs/api/) endpoints

List recent comments of a site

```html
https://public-api.wordpress.com/rest/v1.1/sites/delog.wordpress.com/comments?number=100&page=1
```

Returns 20 comments without the `number` option. Use the `page` option to fetch the next set of comments.

List posts

```html
https://public-api.wordpress.com/rest/v1.1/sites/delog.wordpress.com/posts?number=100&page_handle=value%3D2014-11-26T14%253A24%253A37-03%253A00%26id%3D5796
```

Returns 20 posts without the `number` option. Specify `page_handle` option as the URL-encoded value of the `next_page` property in the `meta` section.
