# GitOps Demo

This repo can be used to create a simple demo of the AKS GitOps feature:

* Run 'deploy.sh' to create an AKS cluster, install the microsoft.flux extension, and create two flux confiurations:

    * A configuration wtih cluster scope that applies infrastructure config from the manifests folder in this repo.
    * A configuration wtih namespace scope that applies the config require for a [demo application](https://github.com/davidxw/gitops-demo-app1)
    
<br>

* Connect to the cluster and check that "app1" and "app2" namespaces are created, ngnix is installed in the nginx namespace, and that an application can be reached by hitting http://\<ngnix public IP\>/app1

* Test that Flux is doing its job by adding a new namespace to the ./manifests/namespaces.yml and verifying that it is created in cluster. Delete the app2 namespace from the cluster (should be empty), and verify that it is recreated

* Uncomment the GitRepository and Kustomisation resources in ./manifests/app-links/app2.yml to deploy a second application to the cluster. This application can be reached from  http://\<ngnix public IP\>/app2
