

# Keycloak Operator Helm Chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 26.7.0](https://img.shields.io/badge/AppVersion-26.7.0-informational?style=flat-square) 

Installs the Keycloak operator for managing Keycloak instances declaratively.

## Source Code

* <https://github.com/keycloak/keycloak-k8s-resources>

## Requirements

Kubernetes: `>= 1.30.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://StevenJDH.github.io/helm-charts | shared-library | ^0.x |

## Usage example

```bash
helm repo add stevenjdh https://StevenJDH.github.io/helm-charts
helm repo update
helm upgrade --install my-keycloak-operator stevenjdh/keycloak-operator --version 0.1.0 \
    --namespace example \
    --create-namespace \
    --atomic
```

For information on how to get started, see the [Operator Guide](https://www.keycloak.org/guides#operator).

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | affinity for pod scheduling. Reference [Assign Pods to Nodes using Node Affinity](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity). |
| annotations | object | `{}` | annotations to be added to the Deployment resource. |
| command | list | `[]` | command corresponds to the entrypoint in some container images that can be overridden or used to run shell commands. |
| extraArgs | list | `[]` | Additional command line arguments to pass to the container. |
| extraInitContainers | list | `[]` | Containers, which are run before the app containers are started. |
| extraVolumeMounts | list | `[]` | Additional volumeMounts for the main container. |
| extraVolumes | list | `[]` | Additional volumes for the pod. |
| fullnameOverride | string | `""` | Override for generated resource names. |
| image.pullPolicy | string | `"Always"` | pullPolicy is the strategy for pulling images from a registry. |
| image.pullSecret.password | string | `""` | password is the Docker password associated with the username with pull rights. |
| image.pullSecret.username | string | `""` | username is the Docker username associated with the password. |
| image.repository | string | `"quay.io/keycloak/keycloak-operator"` | repository holding the container image. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| nameOverride | string | `""` | Override for chart name in helm common labels. |
| nodeSelector | object | `{"kubernetes.io/os":"linux"}` | nodeSelector is the simplest way to constrain Pods to nodes with specific labels. Use affinity for more advance options. Reference [Assigning Pods to Nodes](https://kubernetes.io/docs/user-guide/node-selection). |
| podAnnotations | object | `{}` | podAnnotations are the annotations to be added to the deployment pods. |
| priorityClassName | string | `""` | priorityClassName is the name of the PriorityClass resource that indicates the importance of a Pod relative to other Pods. If a Pod cannot be scheduled, the scheduler tries to preempt (evict) lower priority Pods to make scheduling of the pending Pod possible. Reference [Pod Priority and Preemption](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption). |
| replicaCount | int | `1` | replicaCount is the number of pod instances created by the Deployment owned ReplicaSet to increase availability when set to more than one. |
| restartPolicy | string | `"Always"` | restartPolicy defines how a pod will automatically repair itself when a problem arises. Reference [Container restart policy](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy). |
| service.annotations | object | `{}` | annotations to be added to the Service resource. |
| service.appProtocol | bool | `true` | appProtocol overrides annotations in a service resource that were used for setting a backend protocol. In AWS for example, `service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http`. See the following GitHub issue for more details [kubernetes/kubernetes#40244](https://github.com/kubernetes/kubernetes/issues/40244). Will be ignored for Kubernetes versions older than 1.20. |
| service.ipFamilies | list | `["IPv4"]` | ipFamilies is a list of IP families (e.g. IPv4, IPv6) assigned to a service. This field is usually assigned automatically based on cluster configuration and the ipFamilyPolicy field. [IPv4/IPv6 dual-stack](https://kubernetes.io/docs/concepts/services-networking/dual-stack). |
| service.ipFamilyPolicy | string | `"SingleStack"` | ipFamilyPolicy represents the dual-stack-ness requested or required by this Service. Possible values are SingleStack, PreferDualStack or RequireDualStack. The ipFamilies and clusterIPs fields depend on the value of this field. Reference [IPv4/IPv6 dual-stack](https://kubernetes.io/docs/concepts/services-networking/dual-stack). |
| service.type | string | `"ClusterIP"` | type specifies what kind of Service resource to create. |
| serviceAccount.annotations | object | `{}` | annotations to be added to the Service Account resource. |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created. |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations | list | `[]` | tolerations allow the scheduler to schedule pods onto nodes with matching taints. Reference [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration). |
| updateStrategy | object | `{}` | The update strategy to apply to the Deployment resource. |
| watchAllNamespaces | bool | `false` | watchAllNamespaces indicates whether or not the operator should watch all namespaces or just the namespace it is deployed in. If enabled, set the `configMap.quarkusOperatorSdkControllers*Namespaces` properties to `JOSDK_ALL_NAMESPACES` as needed. See the `configMap` section in the default values.yaml file for more information. |


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
