# Self-Service Kubernetes Development with ArgoCD
This repository contains the source code for an example/walk-through that makes use of [ArgoCD's ApplicationSets](https://argo-cd.readthedocs.io/en/stable/user-guide/application-set/) to demonstrate self-service Kubernetes development. The source code creates two [virtual clusters](https://www.vcluster.com/docs/what-are-virtual-clusters) and two microservices (orders and products) that will be deployed to each of these clusters using GitOps. 

## Prerequisites
* A [Kubernetes](https://kubernetes.io/) cluster. This example uses an EKS cluster but you can use any Kubernetes cluster as long as you update the *creation-script.sh* file accordingly.
* ArgoCD deployed to Kubernetes cluster
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-version.html)
* [kubectl](https://kubernetes.io/docs/tasks/tools/) 
* [Vcluster CLI](https://www.vcluster.com/docs/getting-started/setup)

## Get It Up & Running
Once you've got all the prerequisites in place, you can run the *creation-script.sh* file. You can make it executable on your local machine by running `chmod +x <filename>`. 

## Video
You can watch a detailed walk-through on how to make use of this example. 

[![Alt text](./video-thumbnail.jpg?raw=true "Video Thumbnail")](https://youtu.be/pCoqqNZmnP8)


## Self-Service Kubernetes Development with GitOps
Here's an example of a development workflow using GitOps, application developers can define the infrastructure that they need as code, and submit it as a pull request. A platform team can then review the pull request, and upon approval, merge it to the branch that your GitOps operator is watching. The GitOps operator will then compare this to the live state, detect any differences and reconcile the state based on the declarations in the repo. As a result, the infrastructure change control process to Kubernetes is automated, and primarily driven by developers.

[![Alt text](./diagrams/diagram1.png?raw=true "GitOps Workflow Example")](https://youtu.be/pCoqqNZmnP8)


This project demonstrates one approach of how developers can manage the creation of their own Kubernetes clusters and deploy applications to them. Both processes will be carried out using GitOps, and specifically managed by ArgoCD's ApplicationSets. Instead of provisioning separate Kubernetes clusters, the model is based off a single host cluster where ArgoCD is deployed. Developers can then create their own virtual clusters that will run on the same host cluster. Such an approach provides a scalable and cost-effective foundation for multi-tenancy in a dev environment.

![Alt text](./diagrams/diagram5.png?raw=true "ApplicationSets Workflow Diagram")

![Alt text](./diagrams/diagram6.png?raw=true "Virtual Clusters Diagram")


## ArgoCD Concepts 

### Applications in ArgoCD
An Application in ArgoCD defines the source and destination for your Kubernetes resources. The source is the location in a Git or Helm repository where your Kubernetes resource manifests live, and the destination is the location where the resources should be deployed in your Kubernetes cluster.

![Alt text](./diagrams/diagram2.png?raw=true "ArgoCD Application Diagram")

### ApplicationSets in ArgoCD
The ApplicationSet controller can be used to automatically manage the lifecycle of your ArgoCD Applications. A controller's job in Kubernetes is to continuously watch and make sure that the live state of its resources matches the desired state. The ApplicationSet resource allows you to define a template from which other Applications will be created. This resource is powerful because it provides a great deal of flexibility. The ApplicationSet resource contains parameters that will be substituted by the values required for the Applications being created. To insert these parameters, we use *[Generators](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators/)*. As the name implies, generators are responsible for generating the parameter values that will be inserted into the Application templates. There are different types of generators but this example uses the git generator for this Kubernetes development workflow. 

![Alt text](./diagrams/diagram3.png?raw=true "ArgoCD ApplicationSet Diagram")

![Alt text](./diagrams/diagram4.png?raw=true "ArgoCD ApplicationSet Diagram")


## Clean Up
Once you're done, you can clean things up with the *cleanup-script.sh* file. Remember to delete any infrastructure you created in the process (i.e. Kubernetes cluster, load balancer, etc.).

## Other Resources
If you're brand new to ArgoCD or Vclusters, you can check out these videos below:
* [Getting Started with ArgoCD](https://youtu.be/AvLuplh1skA)
* [Kubernetes Virtual clusters with Loft Labs](https://youtu.be/a8fIyUd9438)

