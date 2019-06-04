---
layout: default
title: Extract all tabular data from multipart mime documents
tags: docker compose mqtt node-red nodered
comments: true
---
# Extract all tabular data from multipart mime documents

Emails and Microsoft's legacy MHTML are multipart mime documents. The following post shows how tabular data in the form of HTML tables can be extracted from such documents using Jupyter Notebook and Python 3.

To begin with, install BeautifulSoup4 and html-table-extractor, using pip

```bash
pip install BeautifulSoup4 html-table-extractor
```

The following code opens an MHTML file, walks through all the parts in the file, uses BeautifulSoup4 to parse parts that have content type `text/html`, iterates through all the tables in the body, parses each table using html_table_extractor, and prints it out.

```python
import email
from bs4 import BeautifulSoup
from html_table_extractor.extractor import Extractor
with open("file.mht") as fp:
    message = email.message_from_file(fp)
    for part in message.walk():
        if (part.get_content_type() == "text/html"):
            soup = BeautifulSoup(part.get_payload(decode=False))
            for table in soup.body.find_all("table", recursive=False):
                extractor = Extractor(table)
                extractor.parse()
                print(extractor.return_list())
```
