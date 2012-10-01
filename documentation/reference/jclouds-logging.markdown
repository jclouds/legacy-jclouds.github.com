---
layout: jclouds
title: Logging
---
## Usage

You enable logging when you are building your Context.

You have the following options:

| Dependency | Implementation |
|------------|---------------------|
| jclouds-core | NullLoggingModule
| jclouds-core | JDKLoggingModule
| jclouds-core | ConsoleLoggingModule
| jclouds-log4j (Optional) | Log4JLoggingModule
| jclouds-slf4j (Optional) | SLF4JLoggingModule
| jclouds-antcontrib (Optional) | AntLoggingModule

To get an optional dependency go to the [Installation Guide](/documentation/userguide/installation-guide) and include the dependency for your kind of installation. For example, in the Getting the latest binaries section add [org.jclouds/jclouds-log4j "X.X.X"] to the list of dependencies.

### log4j

To use log4j you need the jclouds-log4j-X.X.X.jar file on your classpath. 

Here is example code of how to enable your components to use log4j:
{% highlight java %}
    Iterable<Module> modules = ImmutableSet.<Module> of(
        new Log4JLoggingModule());
    
    ComputeServiceContext context = ContextBuilder.newBuilder("a-compute-provider")
        .credentials("myUsername", "myPasswordOrApiKey")
        .modules(modules)
        .buildView(ComputeServiceContext.class);
{% endhighlight %}

You'll also need a log4j.xml ([example](https://github.com/jclouds/jclouds/blob/master/compute/src/test/resources/log4j.xml)) configuration file on your classpath.

### SLF4J

To use SLF4J you need the jclouds-slf4j-X.X.X.jar and the logback-*.jar ([dowload](http://logback.qos.ch/download.html)) files on your classpath. 

Here is example code of how to enable your components to use SLF4J:
{% highlight java %}
    Iterable<Module> modules = ImmutableSet.<Module> of(
        new SLF4JLoggingModule());
    
    ComputeServiceContext context = ContextBuilder.newBuilder("a-compute-provider")
        .credentials("myUsername", "myPasswordOrApiKey")
        .modules(modules)
        .buildView(ComputeServiceContext.class);
{% endhighlight %}

You'll also need a logback.xml ([example](https://github.com/jclouds/jclouds/blob/master/compute/src/test/resources/logback.xml)) configuration file on your classpath.

## Logging in jclouds

jclouds performs different kinds of logging: 

  * Standard context logging - used within each class
  * Wire logging - log the information going over the wire
  * Header logging - log the headers of requests/responses

### Standard Context Logging

Context Logging will show you how jclouds translates the ReST API of a service into HTTP calls and how HTTP results are translated back into java objects.

Each class has its own log named according to the class's fully qualified name.  For example the class `JavaUrlHttpCommandExecutorService` has a log named `org.jclouds.http.internal.JavaUrlHttpCommandExecutorService`. Since all classes follow this convention it is possible to configure context logging for all classes using the single logging rule using `org.jclouds`.

### Wire and Header Logging

Wire Logging is intentionally nearly identical to the Apache HTTP Components project system of the same name.

The wire log is used to log all data transmitted to and from servers when executing HTTP requests. This log should only be enabled to debug problems, as it will produce an extremely large amount of log data, some of it in binary format.

Because the content of HTTP requests is usually less important for debugging than the HTTP headers, these two types of data have been separated into different wire logs.

## Implementation

### Design

jclouds log design has the following goals:

  * Introduce no dependencies on third party APIs such as log4j or SLF4J
  * Support pluggable log implementations or optionally none


jclouds aims to be compatible with as many environments as possible.  Therefore, it has its own `org.jclouds.logging.Logger`. This interface serves two purposes: 

  * allow logging to be pluggable
  * allow zero-logging to be possible

### Pluggable

Pluggable logging is important.  While some users are ok using JDK logging, many prefer to use other APIs such as log4j or SLF4J. To widen the audience we need a layer that protects java logging users from unnecessary dependencies while at the same time allowing users the flexibility to retain a single config file.

In jclouds, logging implementations are plugged-in by Guice.  Essentially classes declare a Logger member annotated with `@Resource`, but set to the null-safe `Logger.NULL`. 

Post-construction, a subclass of [LoggingModule](https://github.com/jclouds/jclouds/blob/master/core/src/main/java/org/jclouds/logging/config/LoggingModule.java)
binds [BindLoggersAnnotatedWithResource](https://github.com/jclouds/jclouds/blob/master/core/src/main/java/org/jclouds/logging/config/BindLoggersAnnotatedWithResource.java),
 which in turn selects an appropriate Logger for the object.  

As this injection is handled in Guice modules, developers can be largely unaware of its existence, or even Guice itself.

### Zero Logging

As high-performance API, jclouds must have means to determine the overhead incurred by I/O systems 
such as logging.  As such, it is standard practice to design your components initialized with an instance of `NullLogger`. 

At runtime, this will be overridden with an appropriate logger implementation so that benchmarks can assess performance impact.  

Here's an example of how a developer can achieve this:

{% highlight java %}
@Resource
protected Logger logger = Logger.NULL;
{% endhighlight %}

