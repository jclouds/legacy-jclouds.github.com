---
layout: jclouds
title: Installation
---
# Installation

## Getting the binaries using lein

  * Download [lein](https://github.com/technomancy/leiningen/raw/stable/bin/lein) and make it executable.
  * Create a __project.clj__ file with the below contents.
{% highlight clojure %}
(defproject deps "1" :dependencies [[org.jclouds/jclouds-all "1.5.3"] [org.jclouds.driver/jclouds-sshj "1.5.3"]])
{% endhighlight %}
  * Execute __lein pom__, then __mvn dependency:copy-dependencies__ which will fill `target/dependency` with all the jclouds jars.

Replace the __provider__ and __api__ in the above directory paths to the ones you want to use in your project.

## Adding jclouds to your Apache Maven project

If your project is managed using Apache Maven, then it is very easy to use the jclouds, just add
the following your project's __pom.xml__:

{% highlight xml %}
<dependencies>
  <dependency>
    <groupId>org.jclouds</groupId>
    <artifactId>jclouds-allcompute</artifactId>
    <version>1.5.3</version>
  </dependency>
  <dependency>
    <groupId>org.jclouds</groupId>
    <artifactId>jclouds-allblobstore</artifactId>
    <version>1.5.3</version>
  </dependency>
</dependencies>
{% endhighlight %}

## Getting the binaries using Apache Ant

If you want to automate fetching the jclouds binaries, you can use the following ant script.

Install [ant](http://ant.apache.org/), copy the following into a __build.xml__ file, tweaking things like 'provider' and 'driver' as necessary. The following example uses *jclouds-all*, *jclouds-sshj* as a driver, and includes the logback jars for a logging implementation.

When you run this script with __ant__, it will build a __lib__ directory full of jars you can later copy into your own project.

{% highlight xml %}
<project default="sync-lib" xmlns:artifact="urn:maven-artifact-ant" >
  <target name="sync-lib" depends="initmvn">
    <delete dir="lib" />
    <mkdir dir="lib" />
    <artifact:dependencies filesetId="jclouds.fileset" versionsId="dependency.versions">
      <dependency groupId="org.jclouds" artifactId="jclouds-all" version="1.5.3" />
      <dependency groupId="org.jclouds.driver" artifactId="jclouds-sshj" version="1.5.3" />
      <dependency groupId="ch.qos.logback" artifactId="logback-classic" version="[1.0.0,)" />
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
{% endhighlight %}

To only fetch the jars for a particular provider replace

{% highlight xml %}
      <dependency groupId="org.jclouds" artifactId="jclouds-all" version="1.5.3" />
{% endhighlight %}

with

{% highlight xml %}
      <dependency groupId="org.jclouds.provider" artifactId="the-provider-id" version="1.5.3" />
{% endhighlight %}

You can see the list of supported providers and their ids in the [Supported Providers](/documentation/reference/supported-providers).

## Adding jclouds to your Apache Ant project.

If you use ant, you will need to install [maven ant tasks](http://maven.apache.org/ant-tasks/index.html).
Then, add jclouds to your __build.xml__ as shown below:

{% highlight xml %}
<artifact:dependencies pathId="jclouds.classpath">
  <dependency groupId="org.jclouds" 
              artifactId="jclouds-allcompute"
              version="1.5.3" />
  <dependency groupId="org.jclouds"
              artifactId="jclouds-allblobstore"
              version="1.5.3" />
</artifact:dependencies>
{% endhighlight %}

## Adding jclouds to your Clojure project using leiningen

If you use lieningen, you can add jclouds to your project.clj like below, supporting clojure 1.2 and 1.3:

{% highlight clojure %}
:dependencies [[org.clojure/clojure "1.3.0"]
               [org.clojure/core.incubator "0.1.0"]
               [org.clojure/tools.logging "0.2.3"]
               [org.jclouds/jclouds-allcompute "1.5.3"]
               [org.jclouds/jclouds-allblobstore "1.5.3"]]
{% endhighlight %}

## Making your own lib dir
  * Using maven:
    * Create a pom.xml file with dependencies you need (ex. org.jclouds/jclouds-all) and the snapshot repository, if you want snapshot version (1.6.0-SNAPSHOT).
    * Execute `mvn dependency:copy-dependencies`.
    * You'll notice a new directory target/dependency with all the jars you need.
  * Using lein
    * See "Getting the binaries using lein" above.
  * Using ant
    * See "Getting the binaries using Apache Ant" above.

## Using the jclouds Snapshot Builds

If you want to use the bleeding edge release of jclouds, you'll need to setup a maven dependency pointing to our sonatype snapshot repo.

You need to update your repositories and add the following in your project's pom.xml:

{% highlight xml %}
<repositories>
  <repository>
    <id>jclouds-snapshots</id>
    <url>https://oss.sonatype.org/content/repositories/snapshots</url>
    <snapshots>
      <enabled>true</enabled>
    </snapshots>
  </repository>
</repositories>
<dependencies>
  <dependency>
    <groupId>org.jclouds</groupId>
    <artifactId>jclouds-allcompute</artifactId>
    <version>1.6.0-SNAPSHOT</version>
  </dependency>
  <dependency>
    <groupId>org.jclouds</groupId>
    <artifactId>jclouds-allblobstore</artifactId>
    <version>1.6.0-SNAPSHOT</version>
  </dependency>
</dependencies>
{% endhighlight %}

## Adding jclouds snapshot to your Apache Ant project

If you use ant, you will need to install [maven ant tasks](http://maven.apache.org/ant-tasks/index.html).

Then, add jclouds snapshot dependencies to your __build.xml__ as shown below:

{% highlight xml %}
<artifact:remoteRepository id="jclouds.snapshot.repository"
                           url="https://oss.sonatype.org/content/repositories/snapshots" />
<artifact:dependencies pathId="jclouds.classpath">
  <dependency groupId="org.jclouds"
              artifactId="jclouds-allcompute"
              version="1.6.0-SNAPSHOT" />
  <dependency groupId="org.jclouds"
              artifactId="jclouds-allblobstore"
              version="1.6.0-SNAPSHOT" />
  <remoteRepository refid="jclouds.snapshot.repository" />
</artifact:dependencies>
{% endhighlight %}

## Adding jclouds snapshots to your leiningen (clojure) project

If you use lieningen, you can add jclouds snapshots to your __project.clj__ like below:

{% highlight clojure %}
  :dependencies [[org.clojure/clojure "1.3.0"]
                 [org.clojure/core.incubator "0.1.0"]
                 [org.clojure/tools.logging "0.2.3"]
                 [org.jclouds/jclouds-allcompute "1.6.0-SNAPSHOT"]
                 [org.jclouds/jclouds-allblobstore "1.6.0-SNAPSHOT"]]
  :repositories { "jclouds-snapshot" "https://oss.sonatype.org/content/repositories/snapshots"}
{% endhighlight %}
