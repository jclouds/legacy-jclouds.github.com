---
layout: jclouds
title: Quick Start - Simple Queue Service Models
---

# Introduction

Amazon SQS (`aws-sqs`) is an easy queuing service with which you can easily send or receive 1-10 messages at a time. SQS support has been in jclouds since version 1.5.0.

### Getting an api connection to a queue

In SQS, once you discover or create a queue, you can focus a connection to to that, by supplying the queue's url.

{% highlight java %}
queueApi = context.getApi().getMessageApiForQueue(queueURI);
{% endhighlight %}

### sending a message
Sending a message is simple, just supply the text you wish to send.

{% highlight java %}
queueApi.send("my message");
{% endhighlight %}

### receiving a message
Receiving a message is also simple: invoke `receive` and if your result is not null, you have a message! 

{% highlight java %}
message = queueApi.receive();
{% endhighlight %}

### sending many messages
You can check whether bulk message requests came back, by checking the status result

{% highlight java %}
BatchResult<MessageIdAndMD5> acks = api.send(ImmutableMap.<String, String> builder()
                                 .put("id1", "test message one")
                                 .put("id2", "test message two")
                                 .put("id3", "test message two")
                                 .build());
{% endhighlight %}

### receiving many messages
Note that you can receive the same message twice *even in the same request!*.  Hence we use List, not Set.

{% highlight java %}
List<Message> messages = api.receive(10);
{% endhighlight %}
