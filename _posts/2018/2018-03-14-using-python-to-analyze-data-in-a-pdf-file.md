---
layout: default
title: Using Python to analyze data in a PDF file
tags: python data analysis pandas pypdf2 macos
comments: true
---

The state university my daughter wants to study at just announced their [entrance exam results](http://processodeingresso.upe.pe.gov.br/arquivos/SSA1/SSA1_2018_Publicacao_v3.pdf) via a PDF file. I wanted to get additional insights from the data, and decided it was time to use Python&mdash;I've got [Jupyter Notebook](http://jupyter.org/) installed on macOS&mdash;to do the data extraction and analysis.

I needed to install a few additional packages for python 3

```bash
pip3 install PyPDF2 pandas matplotlib
```

First, I created an empty `DataFrame` with the three columns I needed

```python
import pandas as pd
columns = ['id','name', 'result']
df = pd.DataFrame(columns=columns)
```

Next, I extracted data from the PDF into the `DataFrame`

```python
import PyPDF2
pdf_file = open('SSA1_2018_Publicacao_v3.pdf', 'rb')
read_pdf = PyPDF2.PdfFileReader(pdf_file)
number_of_pages = read_pdf.getNumPages()
k = 0
for i in range(number_of_pages):
    page = read_pdf.getPage(i)
    textData = page.extractText()
    lineList = textData.splitlines()
    for j in range(5, len(lineList) - 2, 3):
        df.loc[k] = [lineList[j], lineList[j+1], float(lineList[j+2].replace(",", "."))]
        k = k + 1
```

Next, I dropped the last row because it contained spurious data

```python
df = df.drop(df.count() - 1)
print(df)
```

Next, I sorted the `DataFrame` by the `result` column to find the top scorers

```python
df=df.sort_values(by=['result', 'name'])
print(df.tail())
```

Next, I grouped students by their score to find how many had the same score as my daughter's

```python
df_grouped = df.groupby(by='result')['result'].count()
print(df_grouped)
```

Finally, I plotted the grouped data - after I removed students who scored 0

```python
%matplotlib inline
import matplotlib.pyplot as plt
plt.plot(df_grouped)
```

![Plot of number of students by result](/assets/img/python-pyplot-pandas-groupby.png)
