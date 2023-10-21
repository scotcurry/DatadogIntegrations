# Overview

This is the deployment information for the C# [RSSFeedPuller](https://github.com/scotcurry/RSSFeedPuller) project.

## Docker-rssfeedpuller-k8s

This is used to build a Docker image that **DOES NOT** have the Datadog tracing library embedded in it.  This project is built to use [Datadog Dynamic Instrumentation](https://docs.datadoghq.com/dynamic_instrumentation/)

## rssfeedpuller-deployment.yaml

A well commented deployment file with links to the underlying Kubernetes documentation.

## rssfeedpuller-service.yaml

A well commented services file with links to the underlying Kubernetes documentation.

## secrets.yaml

The Datadog API and APP keys must be added to the K8s secrets. Fomat is:
```
kubectl create secret generic datadog-secret --from-literal api-key=<API KEY> --from-literal app-key=<APP KEY>
```

## values.yaml
Not added to the repository has it has the API keys.  You must first add the repository location with the following:
```
helm repo add datadog https://helm.datadoghq.com
```
This configures the Datadog agent in the Kubernetes cluster.  Command line is:
```
helm install datadog -f values.yaml datadog/datadog
```

# Minikube Networking

This is one of the most confusing things about using minikube.  To expose the cluster to the outside world, there are a couple of ways to do it (Nodeport is the other) but [LoadBalancer](https://minikube.sigs.k8s.io/docs/handbook/accessing/#loadbalancer-access) seems to be the easiest.  To make the service accessible, you must use the following steps **in order.**

The following sequence of steps will make the minikube application (running on 192.168.11.180) available on the network on port 26020. **Note** the window has to stay open the entire time for the forwarding to work.  As soon as it is closed, the process will terminate. 

kubectl port-forward --address 192.168.11.180 service/rssfeedpuller-service 26020:6020