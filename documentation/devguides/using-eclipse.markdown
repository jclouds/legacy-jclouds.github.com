---
layout: jclouds
title: Developer Setup Instructions for Eclipse
---

# jclouds Developer Setup instructions for Eclipse

## Introduction
This guide will help you set up jclouds in Eclipse and includes instructions for running tests.

## Pre-requisites
*  Java 7 [Oracle JDK edition](http://www.oracle.com/technetwork/java/javase/downloads/index.html) or [OpenJDK](http://openjdk.java.net/install/index.html)
*  [Git](http://git-scm.com/downloads)
*  [Eclipse 3.4 or higher](http://www.eclipse.org/downloads/)
*  [m2eclipse](http://www.eclipse.org/m2e/). m2eclipse [is included]() in the _Eclipse IDE for Java Developers_ package for [Eclipse 3.7 (Indigo)](http://www.eclipse.org/downloads/packages/eclipse-ide-java-developers/indigosr2) and higher
*  [TestNG plugin for Eclipse](http://testng.org/doc/download.html)
*  A local [clone](http://git-scm.com/book/en/Git-Basics-Getting-a-Git-Repository#Cloning-an-Existing-Repository) of [jclouds/jclouds](https://github.com/jclouds/jclouds/) or [your jclouds fork](https://help.github.com/articles/fork-a-repo)
*  If working on jclouds-labs projects, a local clone of [jclouds/jclouds-labs](https://github.com/jclouds/jclouds-labs) or your jclouds-labs fork

## Adding projects to Eclipse

1. Import jclouds projects [as Maven projects](http://www.sonatype.com/books/m2eclipse-book/reference/creating-sect-importing-projects.html). If you wish to optimize your workspace, you can exclude unneeded projects (such as those without a `src` folder)
2. Accept any warnings about `Incomplete Maven Goal Execution` related to the `maven-remote-resource-plugin:bundle` goal for the jclouds-resources project. You can either:
    * Ignore the error, which will not affect your builds
    * Remove the jclouds-resources project from your workspace, unless developing against it
    * Right-click on the build error and use the `Quick Fix` option to ignore the `bundle` goal
    * Add this [configuration snippet](https://gist.github.com/anonymous/5184602) to your jclouds-resources POM file and refresh the project in Eclipse
3. If working on jclouds-labs, import the jclouds-labs projects as Maven projects

## Running tests in Eclipse

If you are not familiar with TestNG, please have a [quick look](http://testng.org/doc/eclipse.html).

### Testing a live provider

Live tests require the following system properties to be provided as [VM Arguments](http://help.eclipse.org/juno/index.jsp?topic=%2Forg.eclipse.jdt.doc.user%2Ftasks%2Ftasks-executionArgs.htm):

*  `basedir` (use `.` as the value)
*  <tt>test._provider_.identity</tt>
*  <tt>test._provider_.credential</tt>

Here, _provider_ is e.g. "aws-s3", "cloudfiles-us", "aws-ec2" etc. Depending on the provider, you may also be able to specify additional system properties, e.g. `test.vcloud.endpoint` for vcloud:

```
-Dbasedir=. -Dtest.vcloud.identity=user@org -Dtest.vcloud.credential=password -Dtest.vcloud.endpoint=https://vcloudserverilike/api
```

### Testing SSH connections

Tests making direct SSH connections, such as [`SshjSshClientLiveTest`](https://github.com/jclouds/jclouds/blob/master/drivers/sshj/src/test/java/org/jclouds/sshj/SshjSshClientLiveTest.java), also use system properties to determine the connection details to use. This only applies to **direct** SSH tests, not to tests that create and access machines via a compute provider. The following system properties are required:

*  `test.ssh.host`
*  `test.ssh.port`
*  `test.ssh.username`
*  `test.ssh.password`

The destination host must be a Unix-like host that contains a world readable `/etc/passwd` file.

You can use Eclipe's [String Substitution](http://help.eclipse.org/juno/index.jsp?topic=%2Forg.eclipse.jdt.doc.user%2Freference%2Fpreferences%2Frun-debug%2Fref-string_substitution.htm&resultof=%22string%22%20%22substitution%22%20%22substitut%22%20) feature to declare aliases for sensitive information such as your username and password and use these aliases in the Program Arguments.
