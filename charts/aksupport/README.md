# AKSupport Helm Chart

![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square) 

An automation tool that regularly checks for the current supported status of an AKS cluster to alert and maintain Microsoft support.

## Source Code

* <https://github.com/StevenJDH/AKSupport>

## Requirements

Kubernetes: `>= 1.19.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://StevenJDH.github.io/helm-charts | shared-library | 0.1.2 |

## Usage example

```bash
helm repo add stevenjdh https://StevenJDH.github.io/helm-charts
helm repo update
helm upgrade --install my-aksupport stevenjdh/aksupport --version 1.1.0 \
    --set-string configMap.azureSubscriptionId=<subscriptionId> \
    --set-string configMap.azureAppTenant=<tenant> \
    --set-string configMap.azureAksRegion=<region> \
    --set-string configMap.azureAppId=<appId> \
    --set-string secrets.azureAppPassword=<password> \
    --namespace example \
    --create-namespace \
    --atomic
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | affinity for pod scheduling. Reference [Assign Pods to Nodes using Node Affinity](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity). |
| configMap.avatarImageUrl | string | `"https://raw.githubusercontent.com/StevenJDH/AKSupport/main/Avatars/aksupport-256x256-transparent-bg.png"` | Teams and Office Mail configuration. Avatar image source url for Teams and Mail cards. |
| configMap.azureAksClusterName | string | `""` | Teams and Office Mail configuration. AKS cluster name for Teams and Mail cards. |
| configMap.azureAksClusterUrl | string | `""` | Teams and Office Mail configuration. Azure Portal URL for the AKS cluster. |
| configMap.azureAksRegion | string | `""` | Required. AKS region used for checking support status. |
| configMap.azureAppId | string | `""` | Required. App (Client) Id for application registration. |
| configMap.azureAppTenant | string | `""` | Required. App Tenant Id for application registration. |
| configMap.azureSubscriptionId | string | `""` | Required. Subscription Id of Azure account. |
| configMap.mailAppId | string | `""` | Office Mail configuration. Office 365 AD App (Client) Id for application registration. |
| configMap.mailAppTenant | string | `""` | Office Mail configuration. Office 365 AD App Directory (Tenant) Id for application registration. |
| configMap.mailRecipientAddress | string | `""` | Office Mail configuration. Email address of the recipient. |
| configMap.mailSenderId | string | `""` | Office Mail configuration. Email address or Object Id of the sender. Object Id is recommended. |
| cronjob.annotations | object | `{}` | annotations to be added to the CronJob resource. |
| cronjob.job.extraArgs | list | `[]` | extraArgs is used here to provide a specific Kubernetes version for testing. For example, --set "cronjob.job.extraArgs={1.17.0}" or --set cronjob.job.extraArgs[0]=1.17.0. |
| cronjob.job.extraInitContainers | list | `[]` | Containers, which are run before the app containers are started. |
| cronjob.job.podAnnotations | object | `{}` | podAnnotations are the annotations to be added to the job pods. |
| cronjob.job.priorityClassName | string | `""` | priorityClassName is the name of the PriorityClass resource that indicates the importance of a Pod relative to other Pods. If a Pod cannot be scheduled, the scheduler tries to preempt (evict) lower priority Pods to make scheduling of the pending Pod possible. Reference [Pod Priority and Preemption](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption). |
| cronjob.job.resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| cronjob.schedule | string | `"0 8 * * *"` | The Cron schedule to run a support status check. Default is 08:00 every day. |
| fullnameOverride | string | `""` | Override for generated resource names. |
| image.pullPolicy | string | `"Always"` | pullPolicy is the strategy for pulling images from a registry. |
| image.pullSecret.password | string | `""` | password is a PAT with at least read:packages permissions. |
| image.pullSecret.username | string | `""` | username is the GitHub username associated with the password. |
| image.repository | string | `"stevenjdh/aksupport"` | repository can alternatively use "ghcr.io/stevenjdh/aksupport", which requires a pull secret, or "public.ecr.aws/stevenjdh/aksupport". |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| nameOverride | string | `""` | Override for chart name in helm common labels. |
| nodeSelector | object | `{"kubernetes.io/os":"linux"}` | nodeSelector is the simplest way to constrain Pods to nodes with specific labels. Use affinity for more advance options. Reference [Assigning Pods to Nodes](https://kubernetes.io/docs/user-guide/node-selection). |
| secrets.azureAppPassword | string | `""` | Required. App Password (Client Secret) for application registration. |
| secrets.mailAppPassword | string | `""` | Office Mail configuration. Office 365 AD App Password (Client Secret) for application registration. |
| secrets.teamsChannelWebhookUrl | string | `""` | Teams configuration. Url for the Teams channel incoming webhook. |
| serviceAccount.annotations | object | `{}` | annotations to be added to the Service Account resource. |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created. |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations | list | `[]` | tolerations allow the scheduler to schedule pods onto nodes with matching taints. Reference [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration). |


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
