# Helm Charts

[![Release Charts](https://github.com/StevenJDH/helm-charts/actions/workflows/chart-releaser-workflow.yml/badge.svg?branch=main)](https://github.com/StevenJDH/helm-charts/actions/workflows/chart-releaser-workflow.yml)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/51e4129137284c32a81ec74a8600c63c)](https://app.codacy.com/gh/StevenJDH/helm-charts/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=StevenJDH/helm-charts&amp;utm_campaign=Badge_Grade)
![Maintenance](https://img.shields.io/badge/yes-4FCA21?label=maintained&style=flat)
![GitHub](https://img.shields.io/github/license/StevenJDH/helm-charts)

A collection of Kubernetes applications ready for release using [Helm](https://github.com/helm/helm).

![helm charts demo](helm-charts-demo.gif "Demo")

[![Buy me a coffee](https://img.shields.io/static/v1?label=Buy%20me%20a&message=coffee&color=important&style=flat&logo=buy-me-a-coffee&logoColor=white)](https://www.buymeacoffee.com/stevenjdh)

## Prerequisites
* Kubernetes 1.19+
* [Helm](https://github.com/helm/helm/releases) 3.8.0+

## TL;DR

```bash
helm repo add stevenjdh https://StevenJDH.github.io/helm-charts
helm repo update
helm search repo stevenjdh
helm install my-release stevenjdh/<chart>
```

## Pull requests
Pull requests will trigger automatic chart testing and tests against Kubernetes 1.19.x, 1.25.x, and 1.32.x before they can be merged into `main`. To avoid issues, run the same tests locally before submitting a PR.

### Manual chart testing

```bash
docker run -it --rm --name ct --workdir=/data \
    --volume "$(pwd):/data" quay.io/helmpack/chart-testing:v3.12.0 sh \
    -c "ct lint --charts charts/<chart> --print-config --config ct.yaml"
```

### Manual kind (Kubernetes in Docker) tests
Install the needed CLI from [here](https://kind.sigs.k8s.io/docs/user/quick-start/#installation), then run the following commands against the needed [Kubernetes versions](https://hub.docker.com/r/kindest/node/tags):

```bash
kind create cluster --image kindest/node:v1.19.16
helm install my-release charts/<chart>
kind delete cluster
```

> [!NOTE]  
> Run all commands from the root of the repository.

## Contributing
Thanks for your interest in contributing! There are many ways to contribute to this project. Get started [here](https://github.com/StevenJDH/.github/blob/main/docs/CONTRIBUTING.md).

## Do you have any questions?
Many commonly asked questions are answered in the FAQ:
[https://github.com/StevenJDH/helm-charts/wiki/FAQ](https://github.com/StevenJDH/helm-charts/wiki/FAQ)

## Community contact
Feel free to contact me with any questions you may have, and I'll make sure to answer them as soon as possible!

| Platform  | Link        |
|:----------|:------------|
| 💬 Instant Message Chat (preferred) | [![Discord Banner](https://discord.com/api/guilds/851210657318961233/widget.png?style=banner2)](https://discord.gg/VzzzjetTkT)

Announcements of new releases and other topics of interest will be shared via the preferred channel.

## Want to show your support?

|Method          | Address                                                                                   |
|---------------:|:------------------------------------------------------------------------------------------|
|PayPal:         | [https://www.paypal.me/stevenjdh](https://www.paypal.me/stevenjdh "Steven's Paypal Page") |
|Cryptocurrency: | [Supported options](https://github.com/StevenJDH/StevenJDH/wiki/Donate-Cryptocurrency)    |


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
