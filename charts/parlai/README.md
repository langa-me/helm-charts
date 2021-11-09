# Parlai

⚠️ This is a non-official Helm chart, it may be insecure and unfit for professional use. ⚠️

As per [parlai documentation](https://github.com/facebookresearch/ParlAI/):
> A framework for training and evaluating AI models on a variety of openly available dialogue datasets.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- A Docker image internet-accessible that runs a ParlAI bot similar to in the
[examples](https://github.com/facebookresearch/ParlAI/tree/main/parlai/chat_service) with such a Docker configuration:
```docker
FROM python:3.7-slim AS compile-image
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc && pip3 install virtualenv

RUN virtualenv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt

FROM python:3.7-slim AS build-image
COPY --from=compile-image /opt/venv /opt/venv

# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"
# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

ENTRYPOINT ["python", "run.py"]
CMD ["--config_path", "./config.yaml", "--port", "8080"]
```

If you want to quickly try, use the basic image [louis030195/ava:latest-dev](https://hub.docker.com/r/louis030195/ava) for example.

## Get Repo Info

```console
helm repo add langa-me https://langa-me.github.io/helm-charts
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Chart

```console
helm install [RELEASE_NAME] langa-me/parlai --set image.repository=myrepository,image.tag=mytag --create-namespace --namespace parlai
# Or with a value file
helm install [RELEASE_NAME] langa-me/parlai -f my-values.yaml --create-namespace --namespace parlai
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

```console
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm -n ingress-nginx install ingress-nginx ingress-nginx/ingress-nginx --create-namespace
```

## Tricks

Once deployed, the bot will download a bunch of models, the chart will ask for a [PersistentVolumeClaim](https://v1-18.docs.kubernetes.io/docs/concepts/storage/persistent-volumes/).

You should set the PersistentVolume that has been attached to the pod to retain its data (models), just in case you want to uninstall the bot and reinstall later, it would prevent re-downloading the models.

`kubectl get pv -n parlai`

Then

`kubectl patch pv <your-pv-name> -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}' -n parlai`