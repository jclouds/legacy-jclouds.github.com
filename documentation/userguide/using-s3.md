title: Using the s3 Api
---
# Using the s3 Api

## Private Installs
Private clouds often expose s3-compatible interfaces.  Very commonly, users install clones on non-https, or self-signed servers.  If you do so, make sure you set the following properties:
```
jclouds.trust-all-certs=true
jclouds.relax-hostname=true
```
Here are a few configuration examples of common s3 clones:
### Walrus
The following properties should help use the `s3` provider on a walrus install:
```
jclouds.regions=walrus
jclouds.s3.service-path=/services/Walrus
jclouds.s3.virtual-host-buckets=false
s3.endpoint=http://host:8773/services/Walrus
```

