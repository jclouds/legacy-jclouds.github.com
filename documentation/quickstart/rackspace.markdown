---
layout: jclouds
title: Getting Started - The Rackspace Cloud
---

# Getting Started: The Rackspace Cloud

1. [Introduction](#intro)
1. [Get a Username and API Key](#account)
1. [Get jclouds](#install)
1. [Terminology](#terminology)
1. [Your First Cloud Files App](#files)
1. [Your First Cloud Servers App](#servers)
1. [Working with Cloud Block Storage](#volumes)
1. [Working with Cloud Load Balancers](#loadbalancers)
1. [Next Steps](#next)
1. [Rackspace Cloud Providers](#providers)
1. [Getting the Rackspace Binaries](#rax-binaries)
1. [Support and Feedback](#support)

## <a id="intro"></a>Introduction
The [Rackspace Cloud](http://www.rackspace.com/cloud/public/) platform includes everything you need to build websites and applications that scale servers, storage, networking, APIs, and more. The Rackspace Cloud is based on OpenStack, which is a global collaboration of developers and cloud computing technologists producing the ubiquitous open source cloud computing platform for public and private clouds.

This guide assumes you're familiar with Java and its technologies. To get started you'll need access to the Rackspace cloud and jclouds.

## <a id="account"></a>Get a Username and API Key
1. Sign up for free for the [Rackspace Cloud (US)](https://cart.rackspace.com/cloud/).
1. Login to the [Cloud Control Panel (US)](https://mycloud.rackspace.com/).
1. In the top right corner click on your username and then API Keys.

Likewise you can go to the [Rackspace Cloud (UK)](https://buyonline.rackspace.co.uk/cloud/userinfo?type=normal) and login to the [Cloud Control Panel (UK)](https://mycloud.rackspace.co.uk/).

## <a id="install"></a>Get jclouds

1. Ensure you are using the [Java Development Kit (JDK) version 6 or later](http://www.oracle.com/technetwork/java/javase/downloads/index.html).
1. In your Terminal or Command Prompt run the following to verify the JDK is installed correctly.
    * `javac -version` 
1. Create a directory to try out jclouds.
    * `mkdir jclouds` 
1. Follow the instructions for [Getting the binaries using Apache Ant](/documentation/userguide/installation-guide).
1. If you know that you are only going to need the latest binaries (JARs) specific to Rackspace and you'd like to avoid downloading unecessary dependencies, read [Getting the Rackspace Binaries](#rax-binaries) below.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `build.xml`
        * `maven-ant-tasks.jar`
        * `lib/`
            * `*.jar`

## <a id="terminology"></a>Terminology
There are some differences in terminology between jclouds and Rackspace/OpenStack that should be made clear.

| jclouds | Rackspace/OpenStack |
|---------|---------------------|
| Compute | Cloud Servers (Nova)
| Node | Server
| Location/Zone | Region
| Hardware | Flavor
| NodeMetadata | Server details
| UserMetadata | Metadata
| BlobStore | Cloud Files (Swift)
| Blob | File

## <a id="files"></a>Your First Cloud Files App
### <a id="files-intro"></a>Introduction

[Cloud Files](http://www.rackspace.com/cloud/public/files/) is an easy to use online storage for files and media which can be delivered globally over Akamai's content delivery network (CDN).

### <a id="files-apis"></a>APIs

Cloud Files works with a portable layer in jclouds that is used to access features common to all cloud object storage systems. Cloud Files also works with the OpenStack layer in jclouds that is used to access features common to all OpenStack Swift object storage systems. Finally, Cloud Files works with the Rackspace layer in jclouds that is used to access features specific to the Rackspace object storage system.

1. The portable API for Cloud Files is org.jclouds.blobstore.BlobStore.
1. The OpenStack API for Cloud Files is org.jclouds.openstack.swift.CommonSwiftClient.
1. The Rackspace API for Cloud Files is org.jclouds.cloudfiles.CloudFilesClient. 
1. You can find these APIs in the latest [Javadoc](http://demobox.github.com/jclouds-maven-site/latest/apidocs).

### <a id="files-source"></a>The Source Code

1. Create the directory hierarchy org/jclouds/examples/rackspace/cloudfiles/ in your jclouds directory.
1. Create Java source files called CreateContainer.java and Constants.java in the directory above.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `build.xml`
        * `maven-ant-tasks.jar`
        * `lib/`
            * `*.jar`
        * `org/jclouds/examples/rackspace/cloudfiles/`
            * `CreateContainer.java`
            * `Constants.java`
1. Open CreateContainer.java for editing.
1. Go to the example code [CreateContainer.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudfiles/CreateContainer.java), read it over, and copy the code into your file.
1. Open Constants.java for editing.
1. Go to the example code [Constants.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudfiles/Constants.java), read it over, and copy the code into your file.

### <a id="files-compile"></a>Compile and Run

    javac -classpath ".:lib/*" org/jclouds/examples/rackspace/cloudfiles/CreateContainer.java

    java -classpath ".:lib/*" org.jclouds.examples.rackspace.cloudfiles.CreateContainer myUsername myApiKey

    Create Container
      jclouds-example

## <a id="servers"></a>Your First Cloud Servers App
### <a id="servers-intro"></a>Introduction

[Cloud Servers](http://www.rackspace.com/cloud/public/servers/) is an easy to use service that provides on-demand servers that you can use to to build dynamic websites, deliver mobile apps, or crunch big data.

### <a id="servers-apis"></a>APIs

Cloud Servers works with a portable layer in jclouds that is used to access features common to all cloud compute systems. Cloud Servers also works with the OpenStack layer in jclouds that is used to access features common to all OpenStack Nova compute systems.

1. The portable API for Cloud Servers is org.jclouds.compute.ComputeService.
1. The OpenStack API for Cloud Servers is the org.jclouds.openstack.nova.v2_0.features.ServerApi. It's accessible via the org.jclouds.openstack.nova.v2_0.NovaApi.
1. You can find these APIs in the latest [Javadoc](http://demobox.github.com/jclouds-maven-site/latest/apidocs).

### <a id="servers-source"></a>The Source Code

1. Create the directory hierarchy org/jclouds/examples/rackspace/cloudservers/ in your jclouds directory.
1. Create Java source files called CreateServer.java and Constants.java in the directory above.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `build.xml`
        * `maven-ant-tasks.jar`
        * `lib/`
            * `*.jar`
        * `org/jclouds/examples/rackspace/cloudservers/`
            * `CreateServer.java`
            * `Constants.java`
1. Open CreateServer.java for editing.
1. Go to the example code [CreateServer.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudservers/CreateServer.java), read it over, and copy the code into your file.
1. Open Constants.java for editing.
1. Go to the example code [Constants.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudservers/Constants.java), read it over, and copy the code into your file.

### <a id="servers-compile"></a>Compile and Run

    javac -classpath ".:lib/*" org/jclouds/examples/rackspace/cloudservers/CreateServer.java
    
    java -classpath ".:lib/*" org.jclouds.examples.rackspace.cloudservers.CreateServer myUsername myApiKey

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

## <a id="volumes"></a>Working with Cloud Block Storage
### <a id="volumes-intro"></a>Introduction

[Cloud Block Storage](http://www.rackspace.com/cloud/public/blockstorage/) allows you to create volumes on which to persistently store your data from your servers, even when those servers have been deleted. It delivers consistent performance for your I/O-intensive applications.

### <a id="volumes-apis"></a>APIs

Cloud Block Storage works with the OpenStack layer in jclouds that is used to access features common to all OpenStack Cinder block storage systems.

1. The OpenStack API for Cloud Block Storage is the org.jclouds.openstack.cinder.v1.CinderApi. All other APIs for working with block storage are accessible via the CinderApi.
1. You can find these APIs in the latest [Javadoc](http://demobox.github.com/jclouds-maven-site/latest/apidocs).

### <a id="volumes-source"></a>The Source Code

1. Create the directory hierarchy org/jclouds/examples/rackspace/cloudblockstorage/ in your jclouds directory.
1. Create Java source files called CreateVolumeAndAttach.java and Constants.java in the directory above.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `build.xml`
        * `maven-ant-tasks.jar`
        * `lib/`
            * `*.jar`
        * `org/jclouds/examples/rackspace/cloudblockstorage/`
            * `CreateVolumeAndAttach.java`
            * `Constants.java`
1. Open CreateVolumeAndAttach.java for editing.
1. Go to the example code [CreateVolumeAndAttach.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudblockstorage/CreateVolumeAndAttach.java), read it over, and copy the code into your file.
1. Open Constants.java for editing.
1. Go to the example code [Constants.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudblockstorage/Constants.java), read it over, and copy the code into your file.

### <a id="volumes-compile"></a>Compile and Run

    javac -classpath ".:lib/*" org/jclouds/examples/rackspace/cloudblockstorage/CreateVolumeAndAttach.java
    
    java -classpath ".:lib/*" org.jclouds.examples.rackspace.cloudblockstorage.CreateVolumeAndAttach myUsername myApiKey

    Create Server
      {id=DFW/8814...}
      Login: ssh root@123.123.123.123
      Password: a1b2c3d4
    Create Volume
      Volume{id=53d9...}
    Create Volume Attachment
      VolumeAttachment{id=53d9...}
    Mount Volume and Create Filesystem
      Exit Status: 0
    List Volumes
      ...

## <a id="lbs"></a>Working with Cloud Load Balancers
### <a id="lbs-intro"></a>Introduction

[Cloud Load Balancers](http://www.rackspace.com/cloud/public/loadbalancers/) distributes workloads across two or more servers, network links, and other resources to maximize throughput, minimize response time, and avoid overload. Rackspace Cloud Load Balancers allow you to quickly load balance multiple Cloud Servers for optimal resource utilization.

### <a id="lbs-apis"></a>APIs

Cloud Load Balancers works with the Rackspace layer in jclouds that is used to access features specific to the Rackspace load balancer system.

1. The Rackspace API for Cloud Load Balancers is org.jclouds.rackspace.cloudloadbalancers.CloudLoadBalancersApi.  All other APIs for working with load balancers are accessible via the CloudLoadBalancersApi.
1. You can find these APIs in the latest [Javadoc](http://demobox.github.com/jclouds-maven-site/latest/apidocs).

### <a id="lbs-source"></a>The Source Code

1. Create the directory hierarchy org/jclouds/examples/rackspace/cloudloadbalancers/ in your jclouds directory.
1. Create Java source files called CreateLoadBalancerWithExistingServers.java and Constants.java in the directory above.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `build.xml`
        * `maven-ant-tasks.jar`
        * `lib/`
            * `*.jar`
        * `org/jclouds/examples/rackspace/cloudloadbalancers/`
            * `CreateLoadBalancerWithExistingServers.java`
            * `Constants.java`
1. Open CreateLoadBalancerWithExistingServers.java for editing.
1. Go to the example code [CreateLoadBalancerWithExistingServers.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudloadbalancers/CreateLoadBalancerWithExistingServers.java), read it over, and copy the code into your file.
1. Open Constants.java for editing.
1. Go to the example code [Constants.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudloadbalancers/Constants.java), read it over, and copy the code into your file.

### <a id="lbs-compile"></a>Compile and Run

    javac -classpath ".:lib/*" org/jclouds/examples/rackspace/cloudloadbalancers/CreateLoadBalancerWithExistingServers.java
    
    java -classpath ".:lib/*" org.jclouds.examples.rackspace.cloudloadbalancers.CreateLoadBalancerWithExistingServers myUsername myApiKey

    Create Cloud Load Balancer
      LoadBalancer{id=85901...}
      Go to http://166.78.34.87

## <a id="jee"></a>jclouds in a JEE (J2EE) Environment

Setting up jclouds to work in a JEE Environment is easy. You simply need to ensure that jclouds won't spawn any of its own threads. You can do this by using the ExecutorServiceModule when building your Context.

An example code snippet.

```java
import static com.google.common.util.concurrent.MoreExecutors.sameThreadExecutor; 

import org.jclouds.compute.ComputeService;
import org.jclouds.compute.ComputeServiceContext;
import org.jclouds.concurrent.config.ExecutorServiceModule;

public class MyJEEClass {
  ...
  
  private void init() {
    Iterable<Module> modules = ImmutableSet.<Module> of(
      new ExecutorServiceModule(sameThreadExecutor(), sameThreadExecutor()));

      ComputeServiceContext context = ContextBuilder.newBuilder("rackspace-cloudservers-us")
            .credentials("myUsername", "myApiKey")
            .modules(modules)
            .buildView(ComputeServiceContext.class);
      ComputeService compute = context.getComputeService();
  }
  
  ...
} 
```

## <a id="next"></a>Next Steps

1. Try the rest of the [examples](https://github.com/jclouds/jclouds-examples/tree/master/rackspace#the-examples) and the [Logging example](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/Logging.java).
1. When you're ready to publish some web pages on the internet, try the [CloudFilesPublish.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudfiles/CloudFilesPublish.java), [CloudServersPublish.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudservers/CloudServersPublish.java), or [CreateLoadBalancerWithNewServers.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudloadbalancers/CreateLoadBalancerWithNewServers.java) examples.
1. Change the examples to do different things that you want to do.
1. After running some examples, compare the output with what you see in the [Cloud Control Panel](https://mycloud.rackspace.com/).
1. Browse the [documentation](http://www.jclouds.org/documentation/) and have a look at the latest [Javadoc](http://demobox.github.com/jclouds-maven-site/latest/apidocs).
1. Return to the [Installation Guide](http://www.jclouds.org/documentation/userguide/installation-guide/) and have a look at the different ways to integrate jclouds with your project.
1. Join the [jclouds mailing list](https://groups.google.com/forum/?fromgroups#!forum/jclouds) or maybe even the [jclouds developer mailing list](https://groups.google.com/forum/?fromgroups#!forum/jclouds-dev).

## <a id="providers"></a>Rackspace Cloud Providers

This is a list of providers that work with the Rackspace Cloud that you can use to build your Context.

* `"cloudfiles-us"`
* `"cloudfiles-uk"`
* `"rackspace-cloudservers-us"`
* `"rackspace-cloudservers-uk"`
* `"rackspace-cloudblockstorage-us"`
* `"rackspace-cloudblockstorage-uk"`
* `"rackspace-cloudloadbalancers-us"`
* `"rackspace-cloudloadbalancers-uk"`

## <a id="rax-binaries"></a>Getting the Rackspace Binaries

Read over the [Installation Guide](/documentation/userguide/installation-guide). If you know that you are only going to need the latest binaries (JARs) specific to Rackspace and you'd like to avoid downloading unecessary dependencies, use the following files for Ant or Maven.

### <a id="rax-ant"></a>Maven

For Maven, here is an example pom.xml file. To get the latest JARs simply replace X.X.X with the latest jclouds version number. To use the Rackspace Cloud UK add or update the dependencies with 'uk' on the end.

```xml
<project>
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.company.project</groupId>
  <artifactId>my-project</artifactId>
  <version>1.0.0</version>
  <name>My Project</name>

  <dependencies>
    <dependency>
      <groupId>org.jclouds.driver</groupId>
      <artifactId>jclouds-slf4j</artifactId>
      <version>X.X.X</version>
    </dependency>
    <dependency>
      <groupId>ch.qos.logback</groupId>
      <artifactId>logback-classic</artifactId>
      <version>[1.0.0,)</version>
    </dependency>
    <dependency>
      <groupId>org.jclouds.provider</groupId>
      <artifactId>cloudfiles-us</artifactId>
      <version>X.X.X</version>
    </dependency>
    <dependency>
      <groupId>org.jclouds.provider</groupId>
      <artifactId>rackspace-cloudservers-us</artifactId>
      <version>X.X.X</version>
    </dependency>
    <dependency>
      <groupId>org.jclouds.provider</groupId>
      <artifactId>rackspace-cloudblockstorage-us</artifactId>
      <version>X.X.X</version>
    </dependency>
    <dependency>
      <groupId>org.jclouds.provider</groupId>
      <artifactId>rackspace-cloudloadbalancers-us</artifactId>
      <version>X.X.X</version>
    </dependency>
</project>
```

### <a id="rax-ant"></a>Ant

For Ant, here is an example build.xml file. To get the latest JARs simply replace X.X.X with the latest jclouds version number. To use the Rackspace Cloud UK add or update the dependencies with 'uk' on the end.

```xml
<project default="sync-lib" xmlns:artifact="urn:maven-artifact-ant" >
  <target name="sync-lib" depends="initmvn">
    <delete dir="lib" />
    <mkdir dir="lib" />
    <artifact:dependencies filesetId="jclouds.fileset" versionsId="dependency.versions">
      <dependency groupId="org.jclouds.driver" artifactId="jclouds-slf4j" version="X.X.X" />
      <dependency groupId="ch.qos.logback" artifactId="logback-classic" version="[1.0.0,)" />
      <dependency groupId="org.jclouds.provider" artifactId="cloudfiles-us" version="X.X.X" />
      <dependency groupId="org.jclouds.provider" artifactId="rackspace-cloudservers-us" version="X.X.X" />
      <dependency groupId="org.jclouds.provider" artifactId="rackspace-cloudblockstorage-us" version="X.X.X" />
      <dependency groupId="org.jclouds.provider" artifactId="rackspace-cloudloadbalancers-us" version="X.X.X" />
    </artifact:dependencies>
    <copy todir="lib" verbose="true">
      <fileset refid="jclouds.fileset"/>
      <mapper type="flatten" />
    </copy>
  </target>
  
  <get src="http://search.maven.org/remotecontent?filepath=org/apache/maven/maven-ant-tasks/2.1.3/maven-ant-tasks-2.1.3.jar" dest="maven-ant-tasks.jar"/>
  
  <target name="initmvn">
    <path id="maven-ant-tasks.classpath" path="maven-ant-tasks.jar"/>
    <typedef resource="org/apache/maven/artifact/ant/antlib.xml"
             uri="urn:maven-artifact-ant"
             classpathref="maven-ant-tasks.classpath"/>
  </target>
</project>
```

## <a id="support"></a>Support and Feedback

Your feedback is appreciated! If you have specific issues with Rackspace support in jclouds, we'd prefer that you file an issue via [GitHub](https://github.com/jclouds/jclouds/issues).

For general feedback and support requests, send an email to:

[sdk-support@rackspace.com](mailto:sdk-support@rackspace.com)
