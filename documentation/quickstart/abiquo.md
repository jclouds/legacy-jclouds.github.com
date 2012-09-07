---
layout: jclouds
title: Quick Start - Abiquo
---

# Quick Start: Abiquo

1. Get access to a running Abiquo cloud.
2. Ensure you are using a recent JDK 6 version.
3. Setup your project to include `abiquo`.
	* Get the dependencies `org.jclouds.labs/abiquo` using jclouds [Installation](/documentation/userguide/installation-guide).
4. Start coding

## Using the ComputeService portable api

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

The following example will combine the ComputeService portable API with the Abiquo provider specific API to select the public ip for the node being deployed.

{% highlight java %}
// Create the context using your credentials
ComputeServiceContext context = ContextBuilder.newBuilder("abiquo") //
    .endpoint("<the abiquo endpoint>") //
    .credentials("<your login>", "<your password>") //
    .modules(ImmutableSet.<Module> of(new SshjSshClientModule())) //
    .buildView(ComputeServiceContext.class);

// Get the compute service context and the provider specific context
ComputeService compute = context.getComputeService();
AbiquoContext abiquo = AbiquoContext.class.cast(context);

// Get the virtual datacenter that has been assigned to your account
VirtualDatacenter vdc =
    abiquo.getCloudService().findVirtualDatacenter(
        VirtualDatacenterPredicates.name("MyVirtualDatacenter"));

// Find an unused public ip
PublicIp publicIp = vdc.findPurchasedPublicIp(IpPredicates.<PublicIp> notUsed());

// Configure the template options to use the selected ip address
TemplateOptions options = compute.templateOptions() //
    .as(AbiquoTemplateOptions.class) //
    .ips(publicIp);

// Select the template to deploy
Template template = compute.templateBuilder() //
    .imageNameMatches("Chef Server 0\\.10\\.8") //
    .options(options) // Add the ip options
    .build();

// Create and run one node for the selected template
// The node will have the selected public ip address
compute.createNodesInGroup("chef-servers", 1, template);

// Close the context
context.close();
{% endhighlight %}

## Using the provider specific API

The provider specific API gives you more control over what is going on, and allows you to better configure your nodes. For a complete documentation on using the provider, refer to the [Abiquo User Guide](/documentation/userguide/using-abiquo).

