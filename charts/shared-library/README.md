# Shared Library Helm Chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square) 

A contract-based Helm library chart for Kubernetes.

## Features

* Common templates and tools.
* Override support to allow for further customization.

**Note:** Current version doesn't support multiple contexts, so only one instance of each template can be used.

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

In the `Chart.yaml` file of a helm chart project, add the following dependency:

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

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | affinity for pod scheduling. Reference [Assign Pods to Nodes using Node Affinity](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity). |
| annotations | object | `{}` | annotations to be added to the Deployment resource. |
| autoscaling.annotations | object | `{}` | annotations to be added to the HorizontalPodAutoscaler resource. |
| autoscaling.behavior | object | `{}` | behavior configures the scaling behavior of the target in both Up and Down directions (scaleUp and scaleDown fields respectively). |
| autoscaling.enabled | bool | `false` | Indicates whether or not a Horizontal Pod Autoscaling resource is created. Enabling is ignored if KEDA is enabled. |
| autoscaling.maxReplicas | int | `10` | maxReplicas is the upper limit for the number of replicas to which the autoscaler can scale up. It cannot be less that minReplicas. |
| autoscaling.minReplicas | int | `1` | minReplicas is the lower limit for the number of replicas to which the autoscaler can scale down. |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | targetCPUUtilizationPercentage represents the percentage of requested CPU over all the pods. |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` | targetMemoryUtilizationPercentage represents the percentage of requested memory over all the pods. |
| autoscaling.template | list | `[]` | template provides custom or additional autoscaling metrics that are not built in to Kubernetes or any Kubernetes component. Reference [Scaling on custom metrics](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#scaling-on-custom-metrics). |
| command | list | `[]` | command corresponds to the entrypoint in some container images that can be overridden or used to run shell commands. |
| configMap | object | `{}` | configMap is used to store non-confidential data in key-value pairs. |
| containerPorts | object | `{"actuator":8081,"http":8080}` | containerPort is the port or ports that the container listens on. |
| cronjob.annotations | object | `{}` | annotations to be added to the CronJob resource. |
| cronjob.job.command | list | `[]` | command corresponds to the entrypoint in some container images that can be overridden or used to run shell commands. |
| cronjob.job.extraArgs | list | `[]` | Additional command line arguments to pass to the container. |
| cronjob.job.extraEnvs | list | `[]` | Additional environment variables to set. |
| cronjob.job.extraInitContainers | list | `[]` | Containers, which are run before the app containers are started. |
| cronjob.job.extraVolumeMounts | list | `[]` | Additional volumeMounts for the main container. |
| cronjob.job.extraVolumes | list | `[]` | Additional volumes for the pod. |
| cronjob.job.image.containerNameOverride | string | `""` | Overrides the container name whose default is the chart name. |
| cronjob.job.image.pullPolicyOverride | string | `""` | Overrides the strategy for pulling images from a registry. |
| cronjob.job.image.repositoryOverride | string | `"busybox"` | Overrides the repository holding the container image. |
| cronjob.job.image.tagOverride | string | `"latest"` | Overrides the image tag whose default is the chart appVersion. |
| cronjob.job.podAnnotations | object | `{}` | podAnnotations are the annotations to be added to the job pods. |
| cronjob.job.resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| cronjob.schedule | string | `"0 8 * * *"` | The Cron schedule to run a support status check. Default is 08:00 every day. |
| extraArgs | list | `[]` | Additional command line arguments to pass to the container. |
| extraEnvs | list | `[]` | Additional environment variables to set. |
| extraInitContainers | list | `[]` | Containers, which are run before the app containers are started. |
| extraVolumeMounts | list | `[]` | Additional volumeMounts for the main container. |
| extraVolumes | list | `[]` | Additional volumes for the pod. |
| fullnameOverride | string | `""` | Override for generated resource names. |
| image.pullPolicy | string | `"Always"` | pullPolicy is the strategy for pulling images from a registry. |
| image.pullSecret.password | string | `""` | password is the Docker password associated with the username with pull rights. |
| image.pullSecret.username | string | `""` | username is the Docker username associated with the password. |
| image.repository | string | `"nginx"` | repository holding the container image. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| ingress.annotations | object | `{}` | annotations to be added to the Ingress resource. |
| ingress.className | string | `"nginx"` | className is the name of the Ingress class. |
| ingress.enabled | bool | `true` | Indicates whether or not an Ingress resource is created. |
| ingress.hosts[0] | object | `{"host":"","paths":[{"path":"/","pathType":"Prefix"}]}` | host is the hostname of a request that must match exactly or use a wildcard as the subdomain. |
| ingress.hosts[0].paths[0] | object | `{"path":"/","pathType":"Prefix"}` | path is part of a list of one or more paths that are associated with a backend service. |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` | pathType is a field that can specify how Ingress paths should be matched. Reference [Path types](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types). |
| ingress.tls | list | `[]` | tls is a list of hosts that needs to explicitly match the host in the rules section. It also contains a secret with references to tls.crt and tls.key to use for TLS. |
| job.annotations | object | `{}` | annotations to be added to the Job resource. |
| job.command | list | `[]` | command corresponds to the entrypoint in some container images that can be overridden or used to run shell commands. |
| job.extraArgs | list | `[]` | Additional command line arguments to pass to the container. |
| job.extraEnvs | list | `[]` | Additional environment variables to set. |
| job.image.containerNameOverride | string | `""` | Overrides the container name whose default is the chart name. |
| job.image.pullPolicyOverride | string | `""` | Overrides the strategy for pulling images from a registry. |
| job.image.repositoryOverride | string | `"busybox"` | Overrides the repository holding the container image. |
| job.image.tagOverride | string | `"latest"` | Overrides the image tag whose default is the chart appVersion. |
| job.podAnnotations | object | `{}` | podAnnotations are the annotations to be added to the job pods. |
| job.resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| keda.annotations | object | `{}` | annotations to be added to the ScaledObject resource. |
| keda.apiVersion | string | `"keda.sh/v1alpha1"` | apiVersion is the KEDA API to use, which will be either `keda.k8s.io/v1alpha1` or `keda.sh/v1alpha1` depending on whether KEDA is version 1x or 2x respectively. |
| keda.behavior | object | `{}` | behavior is used to modify HPA's scaling behavior for the HPA definition that KEDA will create for a given resource. |
| keda.cooldownPeriod | int | `300` | cooldownPeriod is the period to wait after the last trigger reported active before scaling the resource back to 0. |
| keda.enabled | bool | `false` | Indicates whether or not a KEDA ScaleObject resource is created. Enabling this prevents a Horizontal Pod Autoscaling resource from being created. |
| keda.maxReplicas | int | `10` | maxReplicas is the maximum number of replicas KEDA will scale a target resource up to. |
| keda.minReplicas | int | `1` | minReplicas is the minimum number of replicas KEDA will scale a target resource down to. |
| keda.pollingInterval | int | `30` | pollingInterval is the interval to check each trigger on. |
| keda.restoreToOriginalReplicaCount | bool | `false` | restoreToOriginalReplicaCount specifies whether the target resource (Deployment, StatefulSet,…) should be scaled back to original replicas count, after the ScaledObject is deleted. Default behavior is to keep the replica count at the same number as it is in the moment of ScaledObject's deletion. |
| keda.triggers | list | `[]` | triggers is a list of triggers to activate scaling on for a target resource. |
| nameOverride | string | `""` | Override for chart name in helm common labels. |
| networkPolicy.egress | list | `[{}]` | egress may include a list of allowed egress rules. Each rule allows traffic which matches both the `to` and `ports` sections. The `to` section supports four kinds of selectors which are `podSelector`, `namespaceSelector`, and `ipBlock`. Both `namespaceSelector` and `podSelector` can be combined, but the semantics mean `and` instead of `or` when evaluating. Note: Specifying `- {}` whitelists all outbound traffic and `{}` does the same but on a specific selector, and `- to: []` will block all outbound traffic. Allow policies will override deny policies. Reference [Behavior of to and from selectors](https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors). |
| networkPolicy.enabled | bool | `false` | Specifies whether a network policy should be created. Note: This will have no effect unless the chosen CNI supports network policies like Calico, Weave, Cilium, Romana, etc. |
| networkPolicy.ingress | list | `[{}]` | ingress may include a list of allowed ingress rules. Each rule allows traffic which matches both the `from` and `ports` sections. The `from` section supports four kinds of selectors which are `podSelector`, `namespaceSelector`, and `ipBlock`. Both `namespaceSelector` and `podSelector` can be combined, but the semantics mean `and` instead of `or` when evaluating. Note: Specifying `- {}` whitelists all inbound traffic and `{}` does the same but on a specific selector, and `- to: []` will block all inbound traffic. Allow policies will override deny policies. Reference [Behavior of to and from selectors](https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors). |
| networkPolicy.policyTypes | list | `["Ingress","Egress"]` | policyTypes indicates whether or not the given policy applies to ingress traffic to the selected pod, egress traffic from the selected pods, or both. If no policy types are specified, then by default, Ingress will always be set and Egress will be set if any egress rules are defined. Reference [The NetworkPolicy resource](https://kubernetes.io/docs/concepts/services-networking/network-policies/#networkpolicy-resource). |
| nodeSelector | object | `{"kubernetes.io/os":"linux"}` | nodeSelector is the simplest way to constrain Pods to nodes with specific labels. Use affinity for more advance options. Reference [Assigning Pods to Nodes](https://kubernetes.io/docs/user-guide/node-selection). |
| podAnnotations | object | `{}` | podAnnotations are the annotations to be added to the deployment pods. |
| podDisruptionBudget.create | bool | `false` | Indicates whether or not a PodDisruptionBudget resource is created. |
| podDisruptionBudget.minAvailable | int | `1` | minAvailable is the number of pods from that set that must still be available after the eviction, even in the absence of the evicted pod. Only integer values are supported. |
| replicaCount | int | `1` | replicaCount is the number of pod instances created by the Deployment owned ReplicaSet to increase availability when set to more than one. |
| resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| restartPolicy | string | `"Always"` | restartPolicy defines how a pod will automatically repair itself when a problem arises. Reference [Container restart policy](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy). |
| secrets | object | `{}` | secrets is used to store confidential data in key-value pairs. |
| service.annotations | object | `{}` | annotations to be added to the Service resource. |
| service.appProtocol | bool | `true` | appProtocol overrides annotations in a service resource that were used for setting a backend protocol. In AWS for example, `service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http`. See the following GitHub issue for more details [kubernetes/kubernetes#40244](https://github.com/kubernetes/kubernetes/issues/40244). Will be ignored for Kubernetes versions older than 1.20. |
| service.clusterIP | string | `""` | clusterIP allows for customizing the cluster IP address of a service resource. |
| service.externalIPs | list | `[]` | externalIPs is a list of IP addresses at which a service is available at. Reference [External IPs](https://kubernetes.io/docs/user-guide/services/#external-ips). |
| service.externalTrafficPolicy | string | `""` | externalTrafficPolicy is an annotation set on a service resource. It defines how traffic incoming to a node is load balanced. `Cluster` is normally the default policy, but `Local` is often used to preserve the source IP of traffic coming into a cluster node. With Local, requests are load balanced equally across nodes irrespective of how many pods are on each node. When set to Cluster, both nodes and pods are taken into consideration. Applicable only when `service.type` is `NodePort` or `LoadBalancer`. Reference [Preserving the client source IP](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip). |
| service.healthCheckNodePort | int | `0` | healthCheckNodePort specifies the health check node port (numeric port number) for the service. If healthCheckNodePort isn’t specified, the service controller allocates a port from your cluster’s NodePort range. Reference [Preserving the client source IP](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip). |
| service.ipFamilies | list | `["IPv4"]` | ipFamilies is a list of IP families (e.g. IPv4, IPv6) assigned to a service. This field is usually assigned automatically based on cluster configuration and the ipFamilyPolicy field. [IPv4/IPv6 dual-stack](https://kubernetes.io/docs/concepts/services-networking/dual-stack). |
| service.ipFamilyPolicy | string | `"SingleStack"` | ipFamilyPolicy represents the dual-stack-ness requested or required by this Service. Possible values are SingleStack, PreferDualStack or RequireDualStack. The ipFamilies and clusterIPs fields depend on the value of this field. Reference [IPv4/IPv6 dual-stack](https://kubernetes.io/docs/concepts/services-networking/dual-stack). |
| service.loadBalancerIP | string | `""` | loadBalancerIP is a field used by cloud providers to connect the resulting `LoadBalancer` created by a service resource to a pre-existing static IP. This field is deprecated as of Kubernetes 1.24.0 since it doesn't support dual-stack, but there is no replacement as of yet. Most likely cloud providers will adopt a provider specific annotation approach for this. Progress can be tracked here [kubernetes/enhancements#1992](https://github.com/kubernetes/enhancements/pull/1992). Reference [Type LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer). |
| service.loadBalancerSourceRanges | list | `[]` | loadBalancerSourceRanges is a list of one or more internal or external IP address ranges. If not set, a Service will accept traffic from any IP address (0.0.0.0/0). |
| service.sessionAffinity | string | `"None"` | sessionAffinity ensures that connections from a particular client are passed to the same Pod each time based on the client's IP address. Must be either "None" or "ClientIP" if set. Reference [User space proxy mode](https://kubernetes.io/docs/concepts/services-networking/service/#proxy-mode-userspace). |
| service.type | string | `"ClusterIP"` | type specifies what kind of Service resource to create. |
| serviceAccount.annotations | object | `{}` | annotations to be added to the Service Account resource. |
| serviceAccount.aws.irsa.audience | string | `"sts.amazonaws.com"` | audience sets the intended recipient of the token. |
| serviceAccount.aws.irsa.enabled | bool | `true` | Specifies whether or not to enable support for AWS IAM Roles for Service Accounts (IRSA). Static credentials will be required if this is set to false. |
| serviceAccount.aws.irsa.roleArn | string | `""` | roleArn is the ARN of an IAM role with a web identity provider. For example, `arn:aws:iam::000000000000:role/example-irsa-role`. |
| serviceAccount.aws.irsa.stsRegionalEndpoints | string | `"true"` | stsRegionalEndpoints specifies whether or not to use an STS regional endpoint instead of a global one. It is recommended to use a regional endpoint in almost all cases. |
| serviceAccount.aws.irsa.tokenExpiration | int | `86400` | tokenExpiration is the token expiration duration in seconds. Default is 1 day. |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created. |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations | list | `[]` | tolerations allow the scheduler to schedule pods onto nodes with matching taints. Reference [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration). |
| updateStrategy | object | `{}` | The update strategy to apply to the Deployment resource. |


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
