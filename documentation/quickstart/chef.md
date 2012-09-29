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

### Relationship between compute groups and run lists

Jclouds compute-chef integration is facilitated by the Chef concept of databags. 
We use a databag to store the relationships between Chef nodes and jclouds compute groups. By default these relationships are stored in a databag named "bootstrap". 
However, you can change this by adjusting the property `chef.bootstrap-databag`.
We provide a couple of utilities to help manage the data in this special bag. The two methods are named `updateRunListForGroup` and `getRunListForGroup` in java, and `update-run-list` and `run-list` in clojure at the moment.

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

### What does the generated bootstrap script do?

The method named `createClientAndBootstrapScriptForGroup` in java and `create-bootstrap` in clojure do all the heavy lifting required to create a valid bootstrap script for chef.
Here is the overall process:

1. Create a new client for the group if one isn't in memory (note that the naming convention for this client is group-validator-%02d sequentially. Ex. hadoop-validator-21).
2. Grab the run-list associated with the group from the bootstrap databag.
3. Write a single shell script that does the following:
    1. Installs Ruby and Chef Gems using the same process as [Knife Bootstrap](http://wiki.opscode.com/display/chef/Knife+Bootstrap)
    2. mkdir /etc/chef
    3. Write /etc/chef/client.rb, which sets the nodename as group-ip_address Ex. hadoop-175.2.2.3 (note that the ip address comes from ohai).
    4. Write /etc/chef/validation.pem associated with the client from step 1 above.
    5. Write /etc/chef/first-boot.json with the run-list from step 2 above.
    6. Execute chef-client -j /etc/chef/first-boot.json 
