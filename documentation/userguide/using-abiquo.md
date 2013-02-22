---
layout: jclouds
title: Using the Abiquo cloud
---

# Using the Abiquo cloud

The Abiquo API uses high-level domain objects to perform operations against the Abiquo API. These domain objects provide the necessary functionality to avoid directly consuming the REST API, although this can still be done if needed.

## Creating the context

The first step in using the Abiquo API is to create the context that will point to the API endpoint. This can be done using the **ContextBuilder**:

{% highlight java %}
AbiquoContext context = ContextBuilder.newBuilder("abiquo")
    .endpoint("http://localhost/api")
    .credentials("user", "password")
    .buildView(AbiquoContext.class);
{% endhighlight %}

## Context root services

The Abiquo context provides a set of services to access the functionality of the different underlying APIs. These services are an entry point to the APIs and provide some high-level features, such as listing and filtering. The following code snippet shows a few examples of these services.

{% highlight java %}
// Get access to the administration API
AdministrationService admin = context.getAdministrationService()
List<Datacenter> datacenters = admin.listDatacenters()

// Get access to the cloud API
CloudService cloud = context.getCloudService()
List<VirtualMachine> vms = cloud.listVirtualMachines()
{% endhighlight %}

## Using the domain objects to perform operations

The domain objects are the core of the Abiquo API. They can be used to perform all operations. The following example shows the basic operations on a datacenter:

{% highlight java %}
Datacenter datacenter = Datacenter.builder(context.getApiContext())
    .name("Datacenter")
    .location("Honolulu")
    .build();
// Create the datacenter
datacenter.save()
// Modify the name of the datacenter
datacenter.setName("Updated Datacenter");
datacenter.update();
// Delete the datacenter        
datacenter.delete();
{% endhighlight %}

## A more complete example

This more complete example shows how regular operations can be done using the Abiquo API. It is important to note that the context must be closed when finishing, so the resources that were used can be released.

{% highlight java %}
AbiquoContext context = ContextBuilder.newBuilder("abiquo")
    .endpoint("http://localhost/api")
    .credentials("user", "password")
    .buildView(AbiquoContext.class);
AdministrationService administration = context.getAdministrationService();

try
{
    Datacenter datacenter = administration.findDatacenter(DatacenterPredicates.name("Datacenter"));
    datacenter.setName("Updated Datacenter");
    datacenter.update();
}
finally
{
   context.close();
}
{% endhighlight %}

# The Administration API by example

## Configuring the compute infrastructure

This example shows how to create the physical infrastructure of your cloud. The following code will:
1. create a **datacenter** 
2. create a **rack**
3. connect to a hypervisor
4. discover hypervisor details
5. add hypervisor to Abiquo so it can be used for deploying virtual machines.

{% highlight java %}
// Create a datacenter with the Enterprise Edition features
Datacenter datacenter = Datacenter.builder(context.getApiContext()    
    .name("API datacenter")
    .location("Barcelona")
    .remoteServices("10.60.21.34", AbiquoEdition.ENTERPRISE)
    .build();
datacenter.save();

// Create the rack where the hypervisor will be added
Rack rack = Rack.builder(context.getApiContext(), datacenter)
    .name("API rack")
    .build();
rack.save();

// Connect to the hypervisor and discover its information
Machine machine =
    datacenter.discoverSingleMachine("10.60.1.79", HypervisorType.XENSERVER,
        "hypUser", "hypPass");

// We need to enable at least one datastore, and set the virtual switch to use
Datastore datastore = machine.findDatastore("Local storage");
String vswitch = machine.findAvailableVirtualSwitch("eth1");

datastore.setEnabled(true);
machine.setVirtualSwitch(vswitch);
machine.setRack(rack);    // We will add the hypervisor to the newly created rack

machine.save();

// At this point the compute infrastructure is ready and users will be able to start
// deploying virtual machines
{% endhighlight %}

## Configuring the storage infrastructure

This example shows a basic configuration of tiered storage. It shows how to configure the different tiers, add a storage device and assign a specific storage pool to a tier.

{% highlight java %}
// Get an existing Datacenter
Datacenter datacenter =
    context.getAdministrationService().findDatacenter(DatacenterPredicates.name("San Francisco"));

// Configure the storage tiers (each datacenter has 4 tiers by default)
List<Tier> tiers = datacenter.listTiers();
tiers.get(0).setName("Gold Storage");
tiers.get(0).update();
tiers.get(1).setEnabled(false);
tiers.get(1).update();
tiers.get(2).setEnabled(false);
tiers.get(2).update();
tiers.get(3).setEnabled(false);
tiers.get(3).update();

// Add a storage device to the datacenter
StorageDevice device = StorageDevice.builder(context.getApiContext(), datacenter)
    .name("Storage Device")           // A name for the remote device
    .iscsiIp("10.60.21.203")          // IP address to access the device using the iSCSI protocol. Hypervisors will use it to access the volumes and expose them to the guests
    .iscsiPort(3260)                  // Port to access the device using the iSCSI protocol. Hypervisors will use it to access the volumes and expose them to the guests (it is set to the default value when setting the storage type)
    .managementIp("10.60.21.203")     // IP address of the device management API. Abiquo will use it to manage volumes
    .managementPort(8180)             // Port of the device management API. Abiquo will use it to manage volumes (this port is set to the right default value when setting the device type)
    .type(StorageTechnologyType.LVM)  // The type of the storage device
    .build();

device.save();

// Set the storage pools to be used in Abiquo. Volumes created in virtual datacenters
// will be allocated in the selected storage pools.
StoragePool pool = device.findRemoteStoragePool(StoragePoolPredicates.name("abiquo"))
Tier tier = datacenter.findTier(TierPredicates.name("Gold Storage"));
pool.setTier(tier);
    
pool.save();

// At this point the infrastructure is ready with one storage tier and users will be
// able to create volumes on demand.
{% endhighlight %}

## Configuring the network infrastructure

This example shows the steps that a Cloud Administrator should perform to prepare the networks that will be used by the end users. It shows how to configure the different network types that exist in Abiquo:

* **External:** Usually used to connect virtual machines inside a virtual datacenter to a VPN network belonging to the tenant.
* **Public:** Used to make virtual machines attached to public networks reachable from the Internet.
* **Unmanaged:** Used to delegate the configuration of the NICs in the virtual machines to a local DHCP outside of Abiquo.

{% highlight java %}
// Get the Datacenter where the network configurations will be applied
Datacenter datacenter =
    context.getAdministrationService().findDatacenter(DatacenterPredicates.name("San Francisco"));

// Configure a public network
PublicNetwork publicNetwork = PublicNetwork.builder(context.getApiContext(), datacenter)
    .name("PublicNetwork")    // The name of the network
    .address("80.80.80.0")    // The network address
    .mask(24)                 // The network mask
    .gateway("80.80.80.1")    // The default gateway for the network
    .tag(5)                   // The VLAN tag for this network
    .build();

// Save the network. This will create all the IPs in the range defined by the network address and mask.
publicNetwork.save();

// Create an external network for an enterprise
Enterprise tenant = context.getAdministrationService().findEnterprise(EnterprisePredicates.name("Abiquo"));
ExternalNetwork externalNetwork = ExternalNetwork.builder(context.getApiContext(), datacenter, tenant)
    .name("ExternalNetwork")   // The name of the network
    .address("10.60.0.0")      // The network address
    .mask(24)                  // The network mask
    .gateway("10.60.0.1")      // The default gateway for the network
    .tag(10)                   // The VLAN tag for this network
    .build();

// Save the network. This will create all the IPs in the range defined by the network address and mask.
externalNetwork.save();

// Create an unmanaged network for the same tenant
UnmanagedNetwork unmanagedNetwork = UnmanagedNetwork.builder(context.getApiContext(), datacenter, tenant)
    .name("UnmanagedNetwork")   // The name of the network
    .address("10.70.0.0")      // The network address
    .mask(24)                  // The network mask
    .gateway("10.70.0.1")      // The default gateway for the network
    .tag(11)                   // The VLAN tag for this network
    .build();

// When creating the UnmanagedNetwork, no IP addresses will be created. Unmanaged networks are used to
// allow external systems to configure the NICs, and those external systems will be the ones that will configure
// the IP addresses accordingly when attaching NICs to a virtual machine.
unmanagedNetwork.save();

// At this point the infrastructure is ready with a public network that can be used by anyone, and an external
// and unmanaged network that have been assigned to a tenant.
{% endhighlight %}

The default network creation enables all IP addresses inside the network range. To customize this, and disable a set of IPs so they cannot be used, or to put them in quarantine, you can iterate the available IPs and update them accordingly as shown in the example:

{% highlight java %}
List<PublicIp> publicIps = publicNetwork.listIps(IpPredicates.<PublicIp> available());
for (PublicIp publicIp : publicIps)
{
    publicIp.setAvailable(false);
    publicIp.update();
}
{% endhighlight %}

## Managing tenants

This example shows how to create new Enterprises that will consume the resources of the cloud. It shows how to create the initial enterprise administrator that will be able to manage their enterprise and users.

{% highlight java %}
// Create a new enterprise with a given set of limits
Enterprise enterprise = Enterprise.builder(context.getApiContext())
    .name("New Enterprise")
    .cpuCountLimits(5, 10)      // Number of CPUs: Maximum 10, warn when 5 are in use
    .ramLimits(2048, 4096)      // Ram in MB: 4GB total, warn when 2GB are in use
    .publicIpsLimits(5, 10)     // Available public IPs: 10, warn when 5 are in use
    .storageLimits(5120 * 1204 * 1024, 10240 * 1204 * 1024) // External storage capacity: 10GB, warn when 5GB are in use
    .build();

enterprise.save();

// Allow the enterprise to use a Datacenter
Datacenter datacenter =
    context.getAdministrationService().findDatacenter(DatacenterPredicates.name("San Francisco"));

enterprise.allowDatacenter(datacenter);

// Create an Enterprise administrator, so she can begin using the cloud infrastructure
// and can start creating the users of the enterprise
Role role =
    context.getAdministrationService().findRole(RolePredicates.name("ENTERPRISE_ADMIN"));

// Create the user with the selected role in the newly created enterprise
User enterpriseAdmin = User.builder(context.getApiContext(), enterprise, role) 
    .name("Name", "Surname")       // The name and surname
    .email("username@company.com") // The email address
    .nick("username")              // The login username
    .password("thepassword")       // The password
    .build();

enterpriseAdmin.save();

// At this point, the new Enterprise is created and ready to begin consuming the resources
// of the cloud
{% endhighlight %}

# The Cloud API by example

## Configuring the virtual infrastructure

This example shows how an enterprise administrator can create a **virtual datacenter**. Virtual datacenters provide a set of compute, networking and storage resources that can be consumed by end users in their preferred way.

{% highlight java %}
// Get the enterprise you are managing (the current one in this example)
Enterprise enterprise = context.getAdministrationService().getCurrentEnterprise();

// Get the datacenter where the virtual datacenter will be created (must be allowed for
// the enterprise)
Datacenter datacenter =
    enterprise.findAllowedDatacenter(DatacenterPredicates.name("API datacenter"));

// Choose the type of hypervisor among those available in the datacenter
HypervisorType hypervisor =
    datacenter.findHypervisor(HypervisorPredicates.type(HypervisorType.KVM));

// Create a default private network for the virtual datacenter
 PrivateNetwork network = PrivateNetwork.builder(context.getApiContext())
    .name("DefaultNetwork") // A name for the network
    .gateway("192.168.1.1") // Default gateway
    .address("192.168.1.0") // Network address
    .mask(24)               // Prefix size expressed as a decimal number
    .build();

// Create the virtual datacenter
VirtualDatacenter virtualDatacenter = 
    VirtualDatacenter.builder(context.getApiContext(), datacenter, enterprise)
        .name("API virtual datacenter")       // A name for the virtual datacenter
        .cpuCountLimits(18, 20)               // Number of CPUs: Maximum 20, warn when 18 are in use
        .hdLimitsInMb(10240 * 1204 * 1024, 20480 * 1204 * 1024)   // Hard Drive capacity: 20GB, warn when 10GB are in use
        .publicIpsLimits(2, 2)                // Available public IPs: 2, warn when both are in use
        .ramLimits(2048, 4096)                // RAM in MB: 4GB total, warn when 2GB are in use
        .storageLimits(5120 * 1204 * 1024, 10240 * 1204 * 1024)  // External storage capacity: 10GB, warn when 5GB are in use
        .vlansLimits(1, 2)                   // VLAN: Maximum 2, warn when 1 is in use
        .hypervisorType(hypervisor)          // Type of the hypervisor
        .network(network)                    // Default network
        .build();

virtualDatacenter.save();

// Once the virtual datacenter has been created, we can assign some public IPs to it, so they can be attached
// to the virtual machines created in the virtual datacenter.
List<PublicIps> availablePublicIps = virtualDatacenter.listAvailablePublicIps();

// Purchase public IPs up to the hard limit of the virtual datacenter
// A 0 limit means unlimited, so take the enterprise limit in that case
long limit = virtualDatacenter.getPublicIpsHard() != 0 ?
                virtualDatacenter.getPublicIpsHard()
                : enterprise.getPublicIpsHard();

for (int i = 0; i < limit; i++) {
    PublicIp publicIp = availablePublicIps.get(i).
    virtualDatacenter.purchasePublicIp(publicIp);
}

// At this point the virtual infrastructure is ready and users will be able to start
// deploying virtual machines
{% endhighlight %}

## Deploying virtual machines

This example shows how to create and deploy new virtual machines. It shows how to get the virtual datacenter where the virtual machine will be deployed, and how to configure the resources of the virtual machine to deploy.

{% highlight java %}
// Get the virtual datacenter where the virtual machine will be deployed
VirtualDatacenter vdc =
    context.getCloudService().findVirtualDatacenter(
        VirtualDatacenterPredicates.name("Development"));

// Create a new virtual appliance to group the desired virtual machines (only
// one in this example)
VirtualAppliance vapp = VirtualAppliance.builder(context.getApiContext(), vdc)
    .name("First virtual appliance") // The name for the virtual appliance
    .build();
vapp.save();

// Get the template to use from the templates available to the virtual datacenter
VirtualMachineTemplate template = vdc.findAvailableTemplate(
    VirtualMachineTemplatePredicates.name("CentOS 6"));

// Create the virtual machine
VirtualMachine vm = VirtualMachine.builder(context.getApiContext(), vapp, template)
    .name("My CentOS 6 VM") // The name of the virtual machine
    .cpu(2)                 // The number of CPUs
    .ram(128)               // The amount of RAM in MB
    .build();
vm.save();
 
// Deploy the virtual machine
vm.deploy();

// At this point a deployment job has been started asynchronously and the 
// virtual machine will be deployed in the background
{% endhighlight %}

### Monitoring virtual machine deployments

As seen in the previous example, virtual machine deployments are performed asynchronously, because they may take a long time to complete. There are two ways to monitor these asynchronous tasks: the following examples show how to monitor deployments using a blocking and a non-blocking approach.

**NOTE ON ASYNCHRONOUS TASKS**: All asynchronous operations return an **AsyncTask** object that can be queried to see the current state of the task. However, when monitoring such an operation it is recommended to use the methods shown in the examples below, to monitor the object that generated the task instead of the task itself. *AsyncTask* objects represent the state of the job that configures the hypervisor, but after that job finishes, the Abiquo server still performs some actions, so it is not recommended to use this *AsyncTask* object to monitor deployments, etc.

#### Deploy a virtual machine and block until deployment finishes

{% highlight java %}
// Deploy the virtual machine
vm.deploy();

// Monitor the task and wait until it completes
VirtualMachineMonitor monitor = context.getMonitoringService().getVirtualMachineMonitor();
monitor.awaitCompletionDeploy(vm);

// At this point the deployment has finished and the virtual machine will provide detailed
// information about the status of the deployment.
{% endhighlight %}

#### Deploy a virtual machine and wait asynchronously

To monitor the deployment asynchronously, first you need to create an event handler that will process the events. The following example shows an event handler that handles the three types of events that are generated by the monitoring server, but your handlers only need to define a method for those events that need to be handled.

{% highlight java %}
public class DeployHandler {
    @Subscribe
    public void onComplete(final CompletedEvent<VirtualMachine> event) {
        // Handle completion here
    }
    @Subscribe
    public void onFailure(final FailedEvent<VirtualMachine> event) {
        // Handle failures here
    }
    @Subscribe
    public void onTimeout(final TimeoutEvent<VirtualMachine> event) {
        // Handle timeout here
    }
}
{% endhighlight %}

Once the handler has been defined, it only needs to be registered to start receiving events. It will receive **ALL** events from all objects, so if you only want to handle the events of a particular object, make sure to check against the **event.getTarget()** method in your handler code to ensure you are handling the right event.

{% highlight java %}
// Deploy the virtual machine
vm.deploy();

// Register the handler so it starts to listen to events
DeployHandler handler = new DeployHandler();

VirtualMachineMonitor monitor = context.getMonitoringService().getVirtualMachineMonitor()
monitor.register(handler);

// Monitor the task and call the callback when it completes
monitor.monitorDeploy(vm);

// The 'monitor' method will not block and the program execution will continue
// normally. Events will be dispatched to handlers when the monitor completes, fails
// or reaches timeout.
{% endhighlight %}

Do not forget to **unregister** your handler so you stop receiving events when you are done. This can be done by invoking the monitoring service as follows:

{% highlight java %}
VirtualMachineMonitor monitor = context.getMonitoringService().getVirtualMachineMonitor();
monitor.unregister(handler);
{% endhighlight %}

You may want to unregister the handler inside the event handler methods. There is no limitation on that. Feel free to code your handlers however you like.

## Adding storage to the virtual machines

This example shows how to create a new virtual machine and add some additional storage to it. It shows how to get the virtual datacenter where the virtual machine will be created, and how to configure the resources of the virtual machine.

{% highlight java %}
// Get the virtual datacenter where the virtual machine will be created
VirtualDatacenter vdc =
    context.getCloudService().findVirtualDatacenter(
        VirtualDatacenterPredicates.name("Development"));

// Get the virtual appliance where the virtual machine will be created
VirtualAppliance vapp =
    vdc.findVirtualAppliance(VirtualAppliancePredicates.name("Storage"));

// Get the template to use from the templates available to the virtual datacenter
VirtualMachineTemplate template = vdc.findAvailableTemplate(
    VirtualMachineTemplatePredicates.name("CentOS 6"));

// Create the virtual machine
VirtualMachine vm = VirtualMachine.builder(context.getApiContext(), vapp, template)
    .name("My CentOS 6 VM") // The name of the virtual machine
    .cpu(2)                 // The number of CPUs
    .ram(2048)              // The amount of RAM in MB
    .build();
vm.save();
 
// Create a 2GB extra hard disk and attach it to the virtual machine
HardDisk disk = HardDisk.builder(context.getApiContext(), vdc).sizeInMb(2048L).build();
disk.save()
vm.attachHardDisks(disk);
    
// Create a 20GB persistent volume and attach it to the virtual machine
Tier tier = vdc.findStorageTier(TierPredicates.name("Standard storage"));
Volume volume = Volume.builder(context.getApiContext(), vdc, tier)
    .name("Data volume")   // The name of the persistent volume
    .sizeInMb(20480L)      // The size in MB of the persistent volume
    .build();
volume.save()
vm.attachVolumes(volume);

// At this point the virtual machine is configured with an additional 2GB hard
// disk, and a 20GB additional persistent iscsi volume.
{% endhighlight %}

## Configuring networking in virtual machines

This example shows how configure the NICs for a virtual machine, so it can be used to build complex services. This example will show how to create a virtual machine with 4 NICs: one from a private network, one from an external network, one from a public network and the last one from an unmanaged network.

{% highlight java %}
// Get the virtual datacenter where the virtual machine will be created
VirtualDatacenter vdc =
    context.getCloudService().findVirtualDatacenter(
        VirtualDatacenterPredicates.name("Development"));

// Get the virtual appliance where the virtual machine will be created
VirtualAppliance vapp =
    vdc.findVirtualAppliance(VirtualAppliancePredicates.name("Networking"));

// Get the template to use from the templates available to the virtual datacenter
VirtualMachineTemplate template = vdc.findAvailableTemplate(
    VirtualMachineTemplatePredicates.name("CentOS 6"));

// Create the virtual machine
VirtualMachine vm = VirtualMachine.builder(context.getApiContext(), vapp, template)
    .name("My CentOS 6 VM") // The name of the virtual machine
    .cpu(2)                 // The number of CPUs
    .ram(2048)              // The amount of RAM in MB
    .build();

// By default, the virtual machine is assigned a NIC from the virtual datacenter default network.
vm.save();

// Get an unused IP from the external network
Enterprise enterprise = vdc.getEnterprise();
Datacenter datacenter = vdc.getDatacenter();
ExternalNetwork extNet =
    enterprise.findExternalNetwork(datacenter,
        NetworkPredicates.<ExternalIp> name("ExternalNetwork"));
ExternalIp extIp = extNet.listUnusedIps().get(0);

// Get an unused public IP from the public network
PublicIp pubIp = vdc.findPurchasedPublicIp(IpPredicates.<PublicIp> notUsed());

// Get a private IP from the privateNetwork
PrivateNetwork privNet = vdc.findPrivateNetwork(
    NetworkPredicates.<PrivateIp> name("PrivateNetwork"));
PrivateIp privIp = privNet.listUnusedIps().get(0);

// At this point we have everything we need to attach the IPs to the virtual machine.

// Attach the IPs in the appropriate order
List<Ip<?, ?> ips = Lists.<Ip< ? , ? >> newArrayList(extIp, pubIp, privIp);
vm.setNics(ips);

// At this point we have the virtual machine with the IP addresses attached to it.
{% endhighlight %}

### Configuring the default gateway

By default, the gateway from the network of the first IP attached will be used as the default gateway. This can be changed by providing the network to use as the default gateway network when attaching the IPs. The following example shows how to configure the gateway:

{% highlight java %}
// Option 1: Configure the gateway without changing the NIC configuration
PublicNetwork gateway = pubIp.getNetwork();
vm.setGatewayNetwork(gateway);

// Option 2: Configure the network when configuring the NICs
PublicNetwork gateway = pubIp.getNetwork();
vm.setNics(gateway, extIp, pubIp, privIp);
{% endhighlight %}

### Attaching IPs from unmanaged networks

Unmanaged networks are special. Because Abiquo will not assign the IPs to the virtual machines, IPs from unmanaged networks cannot be directly assigned. An external system will configure the IPs for the virtual machine when it is deployed. However we must indicate that the virtual machine will have NICs from a specific unmanaged network.

To do that, we can call the **setNics** method providing as many unmanaged networks as we want, to indicate that an IP address in each network (or many IP addresses if an unmanaged network is provided more than once) must be attached to the virtual machine.

{% highlight java %}
Unmanagednetwork unmanagedNet = enterprise.findUnmanagedNetwork(datacenter,
    NetworkPredicates.<UnmanagedIp> name("UnmanagedNetwork"));

List<UnmanagedNetwork> unmanagedNicsFromNet =
    Lists.<UnmanagedNetwork> newArrayList(unmanagedNet);

// This will attach the IPs provided in the first list, and the corresponding
// unmanaged IPs from the given unmanaged networks.
vm.setNics(ips, unmanagedNicsFromNet);
{% endhighlight %}

# Miscellaneous examples

## Asynchronous monitor example

This example shows how to deploy an existing virtual machine, and monitor the deployment process asynchronously without blocking the main thread.

### DeployExample.java

This is the main application thread. It deploys the virtual machine and starts the monitoring thread to asynchronously monitor the deployment process.

{% highlight java %}
import org.jclouds.ContextBuilder;
import org.jclouds.abiquo.AbiquoApiMetadata;
import org.jclouds.abiquo.AbiquoContext;
import org.jclouds.abiquo.domain.cloud.VirtualAppliance;
import org.jclouds.abiquo.domain.cloud.VirtualDatacenter;
import org.jclouds.abiquo.domain.cloud.VirtualMachine;
import org.jclouds.abiquo.monitor.VirtualMachineMonitor;
import org.jclouds.abiquo.predicates.cloud.VirtualMachinePredicates;
import org.jclouds.logging.config.NullLoggingModule;

import com.google.common.collect.ImmutableSet;
import com.google.inject.Module;

/**
 * Asynchronous deployment example.
 * <p>
 * This example shows how to deploy a virtual machine and asynchronously monitor the deployment
 * process without blocking the main thread.
 */
public class DeployExample {

    public static void main(final String[] args) {
        // Build the context (we use a NullLoggingModule because we do not want logging in this
        // example)
        AbiquoContext context = ContextBuilder.newBuilder("abiquo")
            .endpoint("http://10.60.21.33/api")
            .credentials("user", "password")
            .modules(ImmutableSet.<Module> of(new NullLoggingModule()))
            .buildView(AbiquoContext.class);

        try
        {
            // Get the virtual datacenter and virtual appliance by ID
            VirtualDatacenter vdc = context.getCloudService().getVirtualDatacenter(7);
            VirtualAppliance vapp = vdc.getVirtualAppliance(6);
            VirtualMachine vm =
                vapp.findVirtualMachine(VirtualMachinePredicates
                    .name("ABQ_524095a7-85d4-4fa2-8d96-5109f308ae1e"));

            // Create the event handler that will be notified asynchronously when deployment
            // finishes
            VmEventHandler handler = new VmEventHandler(context, vm);

            // Register the event handler in the monitoring service. This way the service will
            // notify all deploy-related events to it.
            VirtualMachineMonitor monitor =
                context.getMonitoringService().getVirtualMachineMonitor();
            monitor.register(handler);

            // Deploy the virtual machine
            vm.deploy();

            // Start monitoring it
            monitor.monitorDeploy(vm);

            // The monitor method does not block the thread until deployment finishes. Instead it
            // spawns a monitoring thread and will asynchronously notify all registered event
            // handlers when deployment finishes.
            System.out.println("Started monitoring virtual machine");
            System.out.println("Terminating main thread");
        }
        catch (Exception ex) {
            // Note that in this example we don't close the context in a finally block. We only
            // close it if something fails; otherwise, the event handler will close the context in a
            // separate thread when the deploy operation finishes
            if (context != null) {
                context.close();
            }
        }
    }
}
{% endhighlight %}

### VmEventHandler.java

This is the event handler that will be notified with all events related to virtual machines.

{% highlight java %}
import org.jclouds.abiquo.AbiquoContext;
import org.jclouds.abiquo.domain.cloud.VirtualMachine;
import org.jclouds.abiquo.events.handlers.AbstractEventHandler;
import org.jclouds.abiquo.events.monitor.CompletedEvent;
import org.jclouds.abiquo.events.monitor.FailedEvent;
import org.jclouds.abiquo.events.monitor.MonitorEvent;
import org.jclouds.abiquo.events.monitor.TimeoutEvent;
import org.jclouds.abiquo.monitor.VirtualMachineMonitor;

import com.google.common.eventbus.Subscribe;

/**
 * Handles events related to a specific virtual machine.
 */
public class VmEventHandler extends AbstractEventHandler<VirtualMachine> {

    /** Used to close the context when the job finishes. */
    private AbiquoContext context;

    /** The monitored virtual machine. */
    private VirtualMachine vm;

    public VmEventHandler(final AbiquoContext context, final VirtualMachine vm) {
        super();
        this.context = context;
        this.vm = vm;
    }

    /**
     * Async monitors will receive all events, so we need to be careful and handle only the events
     * we are interested in.
     * 
     * @param event The populated event. It holds the monitored object in the event.getTarget()
     *            property.
     * @return A boolean indicating if this handler instance must handle the given event.
     */
    @Override
    protected boolean handles(final MonitorEvent<VirtualMachine> event) {
        return event.getTarget().getId().equals(vm.getId());
    }

    /**
     * This method will be called when the monitored job completes without error.
     */
    @Subscribe  //The subscribe annotation registers the method as an event handler.
    public void onComplete(final CompletedEvent<VirtualMachine> event) {
        if (handles(event)) {
            System.out.println("VM " + event.getTarget().getName() + " deployed");

            // Stop listening to events and close the context (in this example when the VM is
            // deployed, the application should end)
            unregisterAndClose();
        }
    }

    /**
     * This method will be called when the monitored job fails.
     */
    @Subscribe  //The subscribe annotation registers the method as an event handler.
    public void onFailure(final FailedEvent<VirtualMachine> event) {
        if (handles(event)) {
            System.out.println("Deployment for" + event.getTarget().getName() + " failed");

            // Stop listening to events and close the context (in this example when the VM is
            // deployed the application should end)
            unregisterAndClose();
        }
    }

    /**
     * This method will be called when the monitored job times out.
     * <p>
     * In our example we are not invoking the
     * {@link VirtualMachineMonitor#monitorDeploy(Long, java.util.concurrent.TimeUnit, VirtualMachine...)}
     * method to specify a timeout, so this method will never be called.
     */
    @Subscribe  //The subscribe annotation registers the method as an event handler.
    public void onTimeout(final TimeoutEvent<VirtualMachine> event) {
        if (handles(event)) {
            System.out.println("Deployment for vm " + event.getTarget().getName() + " timed out");

            // Stop listening to events and close the context (in this example when the VM is
            // deployed, the application should end)
            unregisterAndClose();
        }
    }

    /**
     * Unregisters the handler and closes the context.
     */
    private void unregisterAndClose() {
        context.getMonitoringService().unregister(this);
        context.close();
        System.out.println("Terminating monitoring thread");
    }
}
{% endhighlight %}
