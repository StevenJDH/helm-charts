# AKSupport Helm Chart
See the [AKSupport](https://github.com/StevenJDH/AKSupport) repository for more details about the application that will be deployed with this chart.

## Prerequisites
* Kubernetes 1.19+
* [Helm](https://github.com/helm/helm/releases) 3.8.0+

## Usage example

```bash
helm repo add stevenjdh https://StevenJDH.github.io/helm-charts
helm repo update
helm install my-aksupport stevenjdh/aksupport --version 1.0.0 \
    --set-string configMaps.AZURE_SUBSCRIPTION_ID=<subscriptionId> \
    --set-string configMaps.AZURE_APP_TENANT=<tenant> \
    --set-string configMaps.AZURE_AKS_REGION=<region> \
    --set-string configMaps.AZURE_APP_ID=<appId> \
    --set-string secrets.AZURE_APP_PASSWORD=<password> \
    --namespace example \
    --atomic
```