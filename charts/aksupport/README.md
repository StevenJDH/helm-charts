# AKSupport Helm Chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square) 

An automation tool that regularly checks for the current supported status of an AKS cluster to alert and maintain Microsoft support.

## Source Code

* <https://github.com/StevenJDH/AKSupport>

## Requirements

Kubernetes: `>= 1.19.0-0`

## Usage example

```bash
helm repo add stevenjdh https://StevenJDH.github.io/helm-charts
helm repo update
helm upgrade --install my-aksupport stevenjdh/aksupport --version 0.1.0 \
    --set-string configMaps.azureSubscriptionId=<subscriptionId> \
    --set-string configMaps.azureAppTenant=<tenant> \
    --set-string configMaps.azureAksRegion=<region> \
    --set-string configMaps.azureAppId=<appId> \
    --set-string secrets.azureAppPassword=<password> \
    --namespace example \
    --atomic
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for pod scheduling. Reference [Assign Pods to Nodes using Node Affinity](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity). |
| configMaps.avatarImageUrl | string | `"https://raw.githubusercontent.com/StevenJDH/AKSupport/main/Avatars/aksupport-256x256-transparent-bg.png"` | Teams and Office Mail configuration. Avatar image source url for Teams and Mail cards. |
| configMaps.azureAksClusterName | string | `""` | Teams and Office Mail configuration. AKS cluster name for Teams and Mail cards. |
| configMaps.azureAksClusterUrl | string | `""` | Teams and Office Mail configuration. Azure Portal URL for the AKS cluster. |
| configMaps.azureAksRegion | string | `""` | Required. AKS region used for checking support status. |
| configMaps.azureAppId | string | `""` | Required. App (Client) Id for application registration. |
| configMaps.azureAppTenant | string | `""` | Required. App Tenant Id for application registration. |
| configMaps.azureSubscriptionId | string | `""` | Required. Subscription Id of Azure account. |
| configMaps.mailAppId | string | `""` | Office Mail configuration. Office 365 AD App (Client) Id for application registration. |
| configMaps.mailAppTenant | string | `""` | Office Mail configuration. Office 365 AD App Directory (Tenant) Id for application registration. |
| configMaps.mailRecipientAddress | string | `""` | Office Mail configuration. Email address of the recipient. |
| configMaps.mailSenderId | string | `""` | Office Mail configuration. Email address or Object Id of the sender. Object Id is recommended. |
| cronjob.annotations | object | `{}` | Annotations to be added to the CronJob. |
| cronjob.schedule | string | `"0 8 * * *"` | The Cron schedule to run a support status check. Default is 08:00 every day. |
| fullnameOverride | string | `""` | Override for generated resource names. |
| image.pullPolicy | string | `"Always"` | pullPolicy is the strategy for pulling images from a registry. |
| image.pullSecret.password | string | `""` | password is a PAT with at least read:packages permissions. |
| image.pullSecret.username | string | `""` | username is the GitHub username associated with the PAT below, like StevenJDH. |
| image.repository | string | `"public.ecr.aws/stevenjdh/aksupport"` | repository can alternatively use "ghcr.io/stevenjdh/aksupport", which requires a pull secret, or Docker Hub using "stevenjdh/aksupport". |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| nameOverride | string | `""` | Override for chart name in helm common labels. |
| nodeSelector | object | `{"kubernetes.io/os":"linux"}` | Node labels for controller pod assignment. Reference [Assigning Pods to Nodes](https://kubernetes.io/docs/user-guide/node-selection). |
| podAnnotations | object | `{}` | Annotations to be added to the job pods. |
| resources | object | `{}` | Optionally limit how much CPU and memory (RAM) the container needs. |
| secrets.azureAppPassword | string | `""` | Required. App Password (Client Secret) for application registration. |
| secrets.mailAppPassword | string | `""` | Office Mail configuration. Office 365 AD App Password (Client Secret) for application registration. |
| secrets.teamsChannelWebhookUrl | string | `""` | Teams configuration. Url for the Teams channel incoming webhook. |
| testVersion | string | `""` | testVersion is for providing a specific version like 1.17.0 for testing. |
| tolerations | list | `[]` | Node tolerations for server scheduling to nodes with taints. Reference [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration). |


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
