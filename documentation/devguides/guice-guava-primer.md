---
layout: jclouds
title: Guava and Guice Primer
---

# An Introduction to Guava and Guice

All of the jclouds framework is built on top of Guava and Guice.  In order to properly use jclouds or contribute to the code base, it is important to 
be well versed in these tools.  The purpose of this document is not to instruct you on how to use Guava and Guice, but rather serves as a pointer for 
you to find information.

## What are Guava and Guice?

### Guava

Guava is a suite of fundamental libraries created and maintained by Google.  It maximizes your efficiency when working on Java-based projects 
by filling the gaps in Java and allowing you to write simpler, cleaner code.  Using Guava makes it easy for you to follow best practices in Java 1.5 
and beyond.  Guava provides enhancements to the Java language in general.  Some of these enhancements are to the primitive constructs within Java.

#### Resources for learning about Guava

Several good resources exist for information on Guava.  You may wish to read the [Guava User Guide](http://code.google.com/p/guava-libraries/wiki/GuavaExplained)
for more in depth information.

Please see the presentations [An Overview of Guava: Google Core Libraries for Java](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=9&cad=rja&sqi=2&ved=0CFsQFjAI&url=http%3A%2F%2Fguava-libraries.googlecode.com%2Ffiles%2FAnOverviewofGuavaDevoxxFRApril2012.pdf&ei=KX0EUevTC-b6igLrh4CIBg&usg=AFQjCNG0wQM-lLWG2dCAYwmsCQcxnGKm2g&sig2=asS0VOL32lX3e1qV7nKM1Q) 
and [Guava for Netflix](http://guava-libraries.googlecode.com/files/Guava_for_Netflix_.pdf) for brief overviews of some of the Guava libraries. 
*Note - Clicking on these links will open PDFs on your computer.

[<it>Effective Java</it>](http://books.google.com/books?id=Ft8t0S4VjmwC&hl=en) by Joshua Block is a fantastic book that tells you how to 
use Java and its fundamental libraries to maximum effect.

Watch [An Overview of Guava: Google Core Libraries for Java](http://www.infoq.com/presentations/Guava) from QCon SF 2012, presented by Google's Kevin Bourrillion.

### Guice

Guice is a dependency injection framework developed at Google.  It allows for type safe dependency injection using all native Java syntax.  Guice helps
you to build better APIs.

#### Resources for learning about Guice

Read the [Guice User Guide](http://code.google.com/p/google-guice/) for complete information.

Please see the presentations [Big Modular Java with Guice](https://google-guice.googlecode.com/files/Guice-Google-IO-2009.pdf) and [Java on Guice](https://google-guice.googlecode.com/files/Java%20on%20Guice%20-%20Developer%20Day%20Slides.pdf) 
for overviews of Guice. 
*Note - Clicking on these links will open PDFs on your computer.

## How does jclouds use Guava and Guice?

jclouds uses Guava and Guice in interfaces and to simplify code.  Essentially, the Guava libraries enable cleaner and simpler code within the jclouds 
framework while Guice is the glue that holds all of the pieces of jclouds together.

In particular, jclouds avails itself of the following Guava packages and classes:

* Package [com.google.common.collect](http://docs.guava-libraries.googlecode.com/git-history/release/javadoc/com/google/common/collect/package-summary.html) 
is used for collections.
* Package [com.google.common.util.concurrent](http://docs.guava-libraries.googlecode.com/git-history/release/javadoc/com/google/common/util/concurrent/package-summary.html)
is used for asynchronous processing.
* Package [com.google.common.cache](http://docs.guava-libraries.googlecode.com/git-history/release/javadoc/com/google/common/cache/package-summary.html) 
is used for caching information returned from cloud APIs.
* Class [Optional](http://docs.guava-libraries.googlecode.com/git-history/release/javadoc/com/google/common/base/Optional.html) is used extensively 
to avoid troublesome confusions around the meaning of null.
* Interface [Function](http://docs.guava-libraries.googlecode.com/git-history/release/javadoc/com/google/common/base/Function.html) is used
for the majority of the translation layer in jclouds.

jclouds uses Guice to piece together the translation layer for the compute abstraction to the cloud specific client library.  One can think of a 
jclouds compute context as being built by a Guice injector.

jclouds uses the following Guice features:

* @ImplementedBy under [Just-in-time Bindings](http://code.google.com/p/google-guice/wiki/JustInTimeBindings) is a default implementing class.
* @Inject(optional=true) under [Injections](http://code.google.com/p/google-guice/wiki/Injections) is a way to specify optional fields and Guice
constructed objects.
* An example of how jclouds integrates with the Guice SPI internally for assisting in managing the lifecycle of an object can be seen by reading 
[BindLoggersAnnotatedWithResource](https://github.com/jclouds/jclouds/blob/master/core/src/main/java/org/jclouds/logging/config/BindLoggersAnnotatedWithResource.java).

