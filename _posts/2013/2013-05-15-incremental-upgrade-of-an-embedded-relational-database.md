---
layout: default
title: Incremental upgrade of an embedded relational database
tags: database version control upgrade
---

Several years ago I worked on a project that required incrementally upgrading an application and its embedded relational database. What follows is an overview of some best practices we used. Several open source projects, books and articles use or cite similar practices.

1. A full create script and incremental upgrade scripts

    It is vital that you have a full create script for fresh installs, and an incremental upgrade script per application version. The create script has CREATE SQL statements mostly. The upgrade script mostly has ALTER statements, for the changes required from a version of the application to the next.

2. Maintain your scripts under version control

    This ensures that you always know the changes that have been made, can rollback changes, and easily identify changes to create incremental update scripts.

3. Traceability between database scripts and application code

    You should use the same label to tag the database scripts and the application code in the version control system, so you know which script versions match an application release.

4. Installation

    The installer should upgrade the database from an older version of the application to the newest. You'll need to have a procedure in place, a batch script for instance, that knows all application versions and can apply corresponding upgrade scripts in sequence.
