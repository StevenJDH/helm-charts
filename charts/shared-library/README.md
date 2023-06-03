# Shared Library Helm Chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square) 

A Helm chart for Kubernetes.

## Source Code

* <https://github.com/StevenJDH/helm-charts/tree/main/charts/shared-library>

## Requirements

Kubernetes: `>= 1.19.0-0`

## Usage example

Run the following commands:

```bash
helm repo add stevenjdh https://StevenJDH.github.io/helm-charts
helm repo update
```

In the `Chart.yaml` file for the helm chart project, add the following dependency:

```yaml
dependencies:
  - name: shared-library
    version: 0.1.0
    repository: "https://StevenJDH.github.io/helm-charts"
```

Finally, run the following command from the same project folder:

```bash
helm dep update .
```


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
