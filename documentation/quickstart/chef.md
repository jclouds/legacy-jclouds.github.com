---
layout: jclouds
title: Quick Start - Chef
---

# Quick Start: Chef

1. Setup a Chef Server or register for [Opscode Hosted Chef](https://community.opscode.com/users/new).
2. Ensure you are using a recent JDK 6 version.
3. Setup your project to include `chef`, `hostedchef` or `privatechef`, depending on the Chef falvour you are going to connect to.
    * Get the dependencies `org.jclouds.api/chef` using jclouds [Installation](/documentation/userguide/installation-guide).
    * Get the dependencies `org.jclouds.labs/hostedchef` using jclouds [Installation](/documentation/userguide/installation-guide).
    * Get the dependencies `org.jclouds.labs/privatechef` using jclouds [Installation](/documentation/userguide/installation-guide).
4. Start coding

## About Hosted and Private Chef

The Hosted and Private Chef apis are still not complete. The User and Organization apis are still a work in progress, so please, be patient.

The core Chef api, however, provides access to all Chef features in all Chef flavours, so you can use that api to connect to each endpoint.

## Using the Chef Server api

You can easily access the Chef Server api to manage the different components of your Chef Server.
The following example shows a several example api calls and the context creation, so you can get started with Chef.

Note that you can use `chef`, `hostedchef` or `privatechef` to create the context.

{% highlight java %}
String client = "clientName";
String organization = "organization"
String pemFile = System.getProperty("user.home") + "/.chef/" + client + ".pem";
String credential = Files.toString(new File(pemFile), Charsets.UTF_8);

ChefContext context = ContextBuilder.newBuilder("chef") //
    .endpoint("https://api.opscode.com/organizations/" + organization) //
    .credentials(client, credential) //
    .build();

// The raw api has access to all chef features as exposed in the Chef REST api
Set<String> databags = context.getApi().listDatabags();

// ChefService has helpers for common commands
String nodeName = "chef-example";
Set<String> runlist = ImmutableSet.of("recipe[apache2]");
Node node = context.getChefService().createNodeAndPopulateAutomaticAttributes(nodeName, runlist);

// Release resources
context.close();
{% endhighlight %}

## Bootstrap nodes with Chef and the ComputeService

You can also combine the jclouds compute portable api with the Chef api to bootstrap nodes using Chef. The following example
show how you could combine both apis to accomplish this.

{% highlight java %}
// Make a connection to compute provider. Note that ssh will be used ssh to bootstrap chef
ComputeServiceContext computeContext = ContextBuilder.newBuilder("<the compute provider name>") //
    .endpoint("<the compute endpoint>") //
    .credentials("identity", "credential") //
    .modules(ImmutableSet.<Module> of(new SshjSshClientModule())) //
    .buildView(ComputeServiceContext.class);

// Make a connection to the Chef platform
String client = "clientName";
String organization = "organization"
String pemFile = System.getProperty("user.home") + "/.chef/" + client + ".pem";
String credential = Files.toString(new File(pemFile), Charsets.UTF_8);

ChefContext context = ContextBuilder.newBuilder("chef") //
    .endpoint("https://api.opscode.com/organizations/" + organization) //
    .credentials(client, credential) //
    .build();
        
// Group all nodes in both Chef and the compute provider by this group
String group = "test";
String recipe = "apache2";

// Check to see if the recipe you want exists
List<String> runlist = null;
Iterable< ? extends CookbookVersion> cookbookVersions =
    chefContext.getChefService().listCookbookVersions();
if (any(cookbookVersions, containsRecipe(recipe))) {
    runlist = new RunListBuilder().addRecipe(recipe).build();
}

// Update the chef service with the run list you wish to apply to all nodes with the tag
Properties config = new Properties();
config.setProperty("run_list", "[]");
chefContext.getApi().createDatabagItem("bootstrap",
    new DatabagItem(group, chefContext.getUtils().json().toJson(config)));

chefContext.getChefService().updateRunListForGroup(runlist, group);

// Build the script that will bootstrap the chef client
Statement bootstrap =
    chefContext.getChefService().createClientAndBootstrapScriptForGroup(group);

// Run a node on the compute provider that bootstraps chef
Set< ? extends NodeMetadata> nodes =
    computeContext.getComputeService().createNodesInGroup(group, 1, runScript(bootstrap));

// Release resources
chefContext.close();
computeContext.close();
{% endhighlight %}
