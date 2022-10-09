# Helm Charts

[![Release Charts](https://github.com/StevenJDH/helm-charts/actions/workflows/chart-releaser-workflow.yml/badge.svg?branch=main)](https://github.com/StevenJDH/helm-charts/actions/workflows/chart-releaser-workflow.yml)
![Maintenance](https://img.shields.io/maintenance/yes/2022)
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
Pull requests will trigger automatic chart testing and tests against Kubernetes 1.19.x, 1.24.x, and 1.25.x before they can be merged into `main`. To avoid issues, run the same tests locally before submitting a PR.

### Manual chart testing

```bash
docker pull quay.io/helmpack/chart-testing:v3.6.0
docker run -it --rm --name ct --workdir=/data \
    --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.6.0 sh \
    -c "ct lint --print-config --config ct.yaml"
```

### Manual kind (Kubernetes in Docker) tests
Install the needed CLI from [here](https://kind.sigs.k8s.io/docs/user/quick-start/#installation), then run the following commands against the needed [Kubernetes versions](https://hub.docker.com/r/kindest/node/tags):

```bash
kind create cluster --image kindest/node:v1.19.16
helm install my-release charts/<chart>
kind delete cluster
```

**Note:** Run all commands from the root of the repository.

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

|Method       | Address                                                                                                    |
|------------:|:-----------------------------------------------------------------------------------------------------------|
|PayPal:      | [https://www.paypal.me/stevenjdh](https://www.paypal.me/stevenjdh "Steven's Paypal Page")                  |
|Bitcoin:     | 3GyeQvN6imXEHVcdwrZwKHLZNGdnXeDfw2                                                                         |
|Litecoin:    | MAJtR4ccdyUQtiiBpg9PwF2AZ6Xbk5ioLm                                                                         |
|Ethereum:    | 0xa62b53c1d49f9C481e20E5675fbffDab2Fcda82E                                                                 |
|Dash:        | Xw5bDL93fFNHe9FAGHV4hjoGfDpfwsqAAj                                                                         |
|Zcash:       | t1a2Kr3jFv8WksgPBcMZFwiYM8Hn5QCMAs5                                                                        |
|PIVX:        | DQq2qeny1TveZDcZFWwQVGdKchFGtzeieU                                                                         |
|Ripple:      | rLHzPsX6oXkzU2qL12kHCH8G8cnZv1rBJh<br />Destination Tag: 2357564055                                        |
|Monero:      | 4GdoN7NCTi8a5gZug7PrwZNKjvHFmKeV11L6pNJPgj5QNEHsN6eeX3D<br />&#8618;aAQFwZ1ufD4LYCZKArktt113W7QjWvQ7CWDXrwM8yCGgEdhV3Wt|


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
