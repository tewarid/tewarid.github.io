---
layout: default
title: Importing external data - a tale of multiple approaches
tags: import data
comments: true
---
# Importing external data - a tale of multiple approaches

We have a custom software solution for one of our customers that imports data from external systems. The data is provided in the form of Excel spreadsheets, that are imported using the [Microsoft Access Database Engine 2010 Redistributable](https://www.microsoft.com/en-us/download/details.aspx?id=13255).

There are several technical approaches that can be used to solve the problem. The use case quite generally involves the user manually exporting the data from other systems, rarely adjusting some information and feeding it to our custom solution. Our main application in the solution is web based.

There are several approaches to implement this use case

1. Upload a file using our main web application. The application processes the file and provides the status of the procedure.

2. Use a rich-client application that reads the file and sends the data to the main web application, using a web service.

3. Create a network share where the users can just copy their files, a service of some kind monitors the share and processes the files.

It is nice if some criteria can be established to choose one of these approaches.

Here's a small list of quite general criteria

1. Problem reporting

    It should be easy to report problems with the input file and the importation process.

2. Time

    If the files are large they can take a long time to import.

3. Progress

    The user should be able to follow progress of importation of each file, and know precisely when the importation is done.

4. Security

    Restrict access to only particular users.

5. Robustness of the components for a particular usage scenario

    Server-side service components need to be more robust, run for long periods of times non-stop, usually days or months. They should be capable of automatically recovering from failures.

Considering the criteria above we decided to follow approach 2. It meets criteria 1 and 3 quite nicely. Criteria 2 becomes a non-issue since the input data sets are never too big - they are excel spreadsheets after all. Criteria 4 is easy to meet using Windows authentication. It also helps to meet criteria 5. We were having some issues with the Access Database engine cited before - probably of our own making, but we could not find a root cause. It is easier to justify restarting a rich-client application than it is to restart a server.

With approach 1 it is usually harder to meet criteria 1 and 3.  With approach 3, criteria 4 is usually a problem. A share between users is usually the easiest way for viruses to propagate, besides the fact that the configuration usually needs to be performed by someone from IT. It is also difficult to meet criteria 1 and 3 with that approach.
