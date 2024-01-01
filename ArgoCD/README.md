## Overview

This is a tool that watches a git repository and will deploy the app to a Kubernetes cluster.

### Setup

* Easiest to configure when it runs in a namespace called argocd.  [Getting started documentation](https://argo-cd.readthedocs.io/en/stable/getting_started/)

```
kubectl create namespace argocd
```

* Install the code with:
```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

* Need to configure the service to be of type LoadBalancer
```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
immediately port forward with the following [there is a lot of documentation about ingress as well](https://argo-cd.readthedocs.io/en/stable/getting_started/#ingress)
```
kubectl port-forward svc/argocd-server -n argocd 9080:443
```

* Create an initial password
```
argocd admin initial-password -n argocd
```

* Update the password using the following command:
```
argocd account update-password
```