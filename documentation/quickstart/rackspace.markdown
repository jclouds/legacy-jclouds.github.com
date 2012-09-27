---
layout: jclouds
title: Getting Started: The Rackspace open cloud
---

# Getting Started: The Rackspace open cloud
## Introduction
The [Rackspace open cloud](http://www.rackspace.com/cloud/public/) platform includes everything you need to build websites and applications that scale—servers, storage, networking, APIs, and more. The Rackspace open cloud is based on OpenStack, which is a global collaboration of developers and cloud computing technologists producing the ubiquitous open source cloud computing platform for public and private clouds.

This guide assumes you're familiar with Java and its technologies. To get started you'll need access to the Rackspace cloud and jclouds.

## Terminology
There are some differences in terminology between jclouds and Rackspace/OpenStack that should be made clear.

| jclouds | Rackspace/OpenStack |
|---------|---------------------|
| Compute | Cloud Servers (aka Nova) |
| BlobStore | Cloud Files (aka Swift) |
| Location | Region |
| Hardware | Flavor |
| NodeMetadata | Server details |
| UserMetadata | Metadata |


## Get a Username and API Key
1. Sign up for free for the [Rackspace open cloud](https://cart.rackspace.com/cloud/)
1. Login to the [Cloud Control Panel](https://mycloud.rackspace.com/)
1. In the top right corner click on your username and then API Keys.

## Get jclouds

1. Ensure you are using the [Java Development Kit (JDK) version 6 or later](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
1. In your Terminal or Command Prompt run the following to verify the JDK is installed correctly.
    * `javac -version` 
1. Create a directory to try out jclouds
    * `mkdir jclouds` 
1. Follow the instructions for [Getting the latest jclouds binaries](/documentation/userguide/installation-guide).
1. You should now have a directory with the following structure
    * jclouds/
        * lein
        * project.clj
        * lib/
            * *.jar

## Your First Cloud Files App
### Introduction

Cloud Files is an easy to use online storage for files and media which can be delivered globally over Akamai's content delivery network (CDN).

### The Source Code

1. Create the directory hierarchy org/jclouds/examples/rackspace/cloudfiles/ in your jclouds directory
1. Create a Java source file called CreateContainer.java in the directory above
1. You should now have a directory with the following structure
    * jclouds/
        * lein
        * project.clj
        * lib/
            * *.jar
        * org/jclouds/examples/rackspace/cloudfiles/
            * CreateContainer.java
1. Open CreateContainer.java for editting
1. Go to the example code [CreateContainer.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudfiles/CreateContainer.java), read it over, and copy the code into your file

### Compile and Run

```
$ javac -classpath ".:lib/*" org/jclouds/examples/rackspace/cloudfiles/CreateContainer.java
$ java -classpath ".:lib/*" org.jclouds.examples.rackspace.cloudfiles.CreateContainer myUsername myApiKey
Create Container
  jclouds-example
```

### Next Steps

1. Try the rest of the [examples](https://github.com/jclouds/jclouds-examples/tree/master/rackspace) in the [cloudfiles package](https://github.com/jclouds/jclouds-examples/tree/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudfiles) and the [Logging example](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/Logging.java)
1. When you're ready to publish some files on the internet, try the [CloudFilesPublish.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudfiles/CloudFilesPublish.java) example
1. Change the examples to do different things that you want to do
1. After running some examples, compare the output with what you see in the [Cloud Control Panel](https://mycloud.rackspace.com/)
1. Browse the [documentation](http://www.jclouds.org/documentation/) and have a look at the [Javadoc](http://www.jclouds.org/documentation/releasenotes/) (choose the Javadoc for the current version)
1. Return to the [Installation Guide](http://www.jclouds.org/documentation/userguide/installation-guide/) and have a look at the different ways to integrate jclouds with your project
1. Join the [jclouds mailing list](https://groups.google.com/forum/?fromgroups#!forum/jclouds) or maybe even the [jclouds developer mailing list](https://groups.google.com/forum/?fromgroups#!forum/jclouds-dev)

## Cloud Servers
### Introduction

Cloud Servers is an easy to use service that provides on-demand servers that you can use to to build dynamic websites, deliver mobile apps, or crunch big data.

### The Source Code

1. Create the directory hierarchy org/jclouds/examples/rackspace/cloudservers/ in your jclouds directory
1. Create a Java source file called CreateServer.java in the directory above
1. You should now have a directory with the following structure
    * jclouds/
        * lein
        * project.clj
        * lib/
            * *.jar
        * org/jclouds/examples/rackspace/cloudservers/
            * CreateServer.java
1. Open CreateServer.java for editting
1. Go to the example code [CreateServer.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudservers/CreateServer.java), read it over, and copy the code into your file

### Compile and Run

```
$ javac -classpath ".:lib/*" org/jclouds/examples/rackspace/cloudservers/CreateServer.java
$ java -classpath ".:lib/*" org.jclouds.examples.rackspace.cloudservers.CreateServer myUsername myApiKey
Images
  Image{id=9eb71a23-2c7e-...}
  ...
Flavors
  Flavor{id=2,...}
  ...
Create Server
.....................................................
  ServerCreated{id=b037b1a1-...}
  Login IP: 123.123.123.123 Username: root Password: a1b2c3d4

```

### Next Steps

1. Try the rest of the [examples](https://github.com/jclouds/jclouds-examples/tree/master/rackspace) in the [cloudservers package](https://github.com/jclouds/jclouds-examples/tree/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudservers) and the [Logging example](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/Logging.java)
1. When you're ready to publish a web page on the internet, try the [CloudServersPublish.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudservers/CloudServersPublish.java) example
1. Change the examples to do different things that you want to do
1. After running some examples, compare the output with what you see in the [Cloud Control Panel](https://mycloud.rackspace.com/)
1. Browse the [documentation](http://www.jclouds.org/documentation/) and have a look at the [Javadoc](http://www.jclouds.org/documentation/releasenotes/) (choose the Javadoc for the current version)
1. Return to the [Installation Guide](http://www.jclouds.org/documentation/userguide/installation-guide/) and have a look at the different ways to integrate jclouds with your project
1. Join the [jclouds mailing list](https://groups.google.com/forum/?fromgroups#!forum/jclouds) or maybe even the [jclouds developer mailing list](https://groups.google.com/forum/?fromgroups#!forum/jclouds-dev)

## Support and Feedback

Your feedback is appreciated! If you have specific issues with Rackspace support in jclouds, we'd prefer that you file an issue via [Github](https://github.com/jclouds/jclouds/issues).

For general feedback and support requests, send an email to:

[sdk-support@rackspace.com](mailto:sdk-support@rackspace.com)