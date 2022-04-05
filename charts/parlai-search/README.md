# Parlai-search

Deploy a search engine API for https://parl.ai conversational artificial intelligence.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- A Docker image internet-accessible that runs a ParlAI search server with similar entrypoint  
`CMD ["serve" "--host" "0.0.0.0:8080"]`

Use [langameai/search-engine](https://hub.docker.com/repository/docker/langameai/search-engine) for example.

## Get Repo Info

```console
helm repo add langa-me https://langa-me.github.io/helm-charts
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Chart

```console
helm install [RELEASE_NAME] langa-me/parlai-search --set image.repository=myrepository,image.tag=mytag --create-namespace --namespace parlai
# Or with a value file
helm install [RELEASE_NAME] langa-me/parlai-search -f my-values.yaml --create-namespace --namespace parlai
```

Example

```
helm install parlai-search langa-me/parlai-search --set image.repository=langameai/search-engine -n parlai --create-namespace
```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Uninstall Chart

```console
helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Upgrading Chart

```console
helm upgrade [RELEASE_NAME] [CHART] --install
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). To see all configurable options with detailed comments, visit the chart's [values.yaml](./values.yaml), or run these configuration commands:

```console
helm show values langa-me/parlai
```

### Using Ingress

⚠️ Not tested, current intented usage is between pods in the cluster ⚠️

```console
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm -n ingress-nginx install ingress-nginx ingress-nginx/ingress-nginx --create-namespace
```