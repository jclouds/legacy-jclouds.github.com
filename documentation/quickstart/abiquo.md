---
layout: jclouds
title: Quick Start - Abiquo
---

# Quick Start: Abiquo

1. Get access to a running Abiquo cloud.
2. Ensure you are using a recent JDK 6 version.
3. Set up your project to include `abiquo`.
	* Get the dependencies `org.jclouds.labs/abiquo` using jclouds [Installation](/documentation/userguide/installation-guide).
4. Start coding.

## Using the ComputeService portable API

The following example will deploy a single node using the default settings configured by the administrator of your tenant account:

{% highlight java %}
// Create the context using your credentials
ComputeServiceContext context = ContextBuilder.newBuilder("abiquo") //
    .endpoint("<the abiquo endpoint>") //
    .credentials("<your login>", "<your password>") //
    .modules(ImmutableSet.<Module> of(new SshjSshClientModule())) //
    .buildView(ComputeServiceContext.class);

// Get the compute service instance
ComputeService compute = context.getComputeService();

// Select the template to deploy
Template template = compute.templateBuilder() //
    .imageNameMatches("Chef Server 0\\.10\\.8") //
    .build();

// Create and run one node for the selected template
compute.createNodesInGroup("chef-servers", 1, template);

// Close the context
context.close();
{% endhighlight %}

## Using the provider-specific API

The provider-specific API gives you more control and enables you to better configure your nodes. For complete documentation on using the provider, refer to the [Abiquo User Guide](/documentation/userguide/using-abiquo).

