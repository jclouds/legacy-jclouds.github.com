---
layout: jclouds
title: Developer Setup Instructions for Eclipse
---

# jclouds Developer Setup instructions for Eclipse

## Introduction
This guide will help you set up and import your projects into Eclipse. It also includes instructions for running tests with TestNG, setting up a demo project, and cleaning up your build artifacts.

## Pre-requisites
*  Install Java 7 [Oracle JDK edition](http://www.oracle.com/technetwork/java/javase/downloads/index.html) or [OpenJDK](http://openjdk.java.net/install/index.html)
*  Install [Apache Maven 3.0.x](http://maven.apache.org/download.cgi)
*  Install [Git](http://git-scm.com/downloads)
*  Install [Eclipse 3.4 or higher](http://www.eclipse.org/downloads/)


## Configure Eclipse

### Install the m2eclipse plugin
1.  Open Eclipse
2.  Go to `Help -> Eclipse Marketplace`
3.  Find *m2eclipse*
4.  `Install` the `Maven Integration for Eclipse WTP` plugin

### Install the TestNG plugin
1.  Open Eclipse
2.  Go to `Help -> Eclipse Marketplace`
3.  Find **TestNG**
4.  `Install` the `TestNG for Eclipse` plugin

## Clone jclouds from Github

* Go to [Github](https://github.com/) and fork [jclouds/jclouds](https://github.com/jclouds/jclouds)
* Clone your jclouds's fork by using something like:
	* `git clone https://github.com/username/jclouds.git`
	* `cd jclouds`
	* `mvn eclipse:eclipse -Dmaven.javadoc.skip=true -DdownloadSources=true`
	
If you are not familiar with the command line, you can use [Github for Mac](http://mac.github.com/) or [Github for Windows](http://windows.github.com/) to clone the `jclouds` project on your workstation.
	
  	 
## Import into Eclipse
1.  Open Eclipse
2.  `File -> Import … -> Maven -> Existing Maven projects
3.  Choose as Root directory your local git repository folder, ex. `/Users/username/projects/jclouds`
4.  Select all projects
5.  Click `Finish`

# Running Tests

Tests in Eclipse are created using TestNG. Please make sure you have installed the TestNG plugin for Eclipse before proceeding. If you are not familiar with TestNG, please have a [quick overview](http://testng.org/doc/eclipse.html).

## Live testing 

To run tests that use a real live service like aws-s3, you will need to provide your credentials to Eclipse and tell your tests to use them.  
You'll key these on the provider name (ex. provider  is aws-s3, cloudfiles-us, aws-ec2, etc)

To implement this, open the test's Run Configurations and enter in the following into VM arguments-

    -Dbasedir=. -Dtest.provider.identity=identity -Dtest.provider.credential=credential

ex. for **vcloud**

    -Dbasedir=. -Dtest.vcloud.endpoint=https://vcloudserverilike/api Dtest.vcloud.identity=user@org -Dtest.vcloud.credential=password

### Testing a BlobStore

If you are testing a BlobStore, you will also need to pass the test initializer you can find in its pom.xml file

ex. for *aws-s3*

    -Dbasedir=. -Dtest.aws-s3.identity=accesskey -Dtest.aws-s3.credential=secret -Dtest.initializers=org.jclouds.aws.s3.blobstore.integration.AWSS3TestInitializer

## ssh testing

ssh tests need access to an ssh host you have access to.  
Note that this is only required for running pure ssh tests.  
ssh indirectly used via a cloud will use the cloud credentials not the ones below. 
Note that the destination must be a Unix-like host that at least contains a world readable /etc/passwd file.

*  In Eclipse's Preferences open the section Run/Debug > String Substitution
*  Create two new variables named:
	*  `test.ssh.username` with the value of your ssh username
	*  `test.ssh.password` with the value of your ssh password

Then, for each test that uses ssh, open the test's Run Configurations and enter in the following into VM arguments:

    -Dtest.ssh.host=localhost -Dtest.ssh.port=22 -Dtest.ssh.username=${test.ssh.username} -Dtest.ssh.password=${test.ssh.password}

*  note that you can replace {{{test.ssh.host}}} and {{{test.ssh.port}}} above if you are not connecting to localhost.


## Create a demo project

For instance if you want to create a demo project in aws, you can do it with following steps:

*  Copy a sample project there (aws/demos directory) 
*  Change pom.xml from demos and add new module
*  Change pom.xml of the new project (change names and classes)
*  Add your code
*  `mvn eclipse:clean`
*  `mvn eclipse:eclipse -DskipTests=true`
*  You  can import your project now in eclipse.



## Clean build 
  * Close Eclipse
  * `mvn eclipse:clean`
  * `mvn clean` (may not be needed?)
  * `mvn install`
  * Then to start coding again:
    * `mvn eclipse:eclipse -Dmaven.javadoc.skip=true`
    * Open Eclipse
    * Delete old project references (but not underlying files)
    * Re-import projects
