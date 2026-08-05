

# Keycloak Stack Helm Chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 26.7.0](https://img.shields.io/badge/AppVersion-26.7.0-informational?style=flat-square) 

Installs a fully managed Keycloak and its dependencies.

## Source Code

* <https://github.com/keycloak/keycloak>

## Requirements

Kubernetes: `>= 1.30.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://StevenJDH.github.io/helm-charts | keycloakOperator(keycloak-operator) | 0.1.0 |
| https://StevenJDH.github.io/helm-charts | shared-library | ^0.x |
| oci://registry-1.docker.io/bitnamicharts | postgresql | 18.8.0 |

## Usage example

```bash
helm repo add stevenjdh https://StevenJDH.github.io/helm-charts
helm repo update
helm upgrade --install my-keycloak-stack stevenjdh/keycloak-stack --version 0.1.0 \
    --set devModeEnabled=true
    --namespace example \
    --create-namespace \
    --atomic
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalOptions | list | `[]` | Additional options to set for the Keycloak server. These should be expressed as key-value pairs that can be either direct values or references to secrets. See [All configuration](https://www.keycloak.org/server/all-config) for details. |
| affinity | object | `{}` | affinity for pod scheduling. Reference [Assign Pods to Nodes using Node Affinity](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity). |
| annotations | object | `{}` | annotations to be added to the Deployment resource. |
| bootstrapAdmin.service.clientId | string | `""` | clientId is the client ID for the Keycloak bootstrap admin service account. |
| bootstrapAdmin.service.clientSecret | string | `""` | clientSecret is the client secret for the Keycloak bootstrap admin service account. |
| bootstrapAdmin.user.password | string | `"admin"` | password is the password for the Keycloak bootstrap admin user. |
| bootstrapAdmin.user.username | string | `"admin"` | username is the username for the Keycloak bootstrap admin user. |
| configMap | object | `{"KC_CACHE":"ispn","KC_HEALTH_ENABLED":"true","KC_HTTPS_ENABLED":"false","KC_HTTP_ENABLED":"true","KC_HTTP_PORT":8080,"KC_HTTP_RELATIVE-PATH":"/","KC_PROXY-HEADERS":"xforwarded","KC_SPI-ADMIN_REALM":"master"}` | configMap is used to store non-confidential data in key-value pairs. Quoting is required if the value is 0. |
| containerPorts | object | `{}` | containerPort is the port or ports that the container listens on. |
| db.external.auth.password | string | `""` | password is the password for the external database user. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.auth.username | string | `""` | username is the username for the external database user. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.database | string | `"keycloak"` | database is the name of the external database to use for Keycloak. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.host | string | `""` | host is the hostname of the external database server. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.port | int | `5432` | port is the port number of the external database server. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.schema | string | `"public"` | schema is the name of the external database schema to use for Keycloak. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.vendor | string | `"postgres"` | vendor is the external database vendor to use for Keycloak. Supported values are: postgres, mariadb, mysql, oracle, mssql, etc. This setting is ignored if `postgresql.enabled` is `true`. |
| db.hostOverride | string | `""` | hostOverride is the hostname of the database server. If not set, it will be auto configured for the postgresql headless service of the managed database. This setting is ignored if `postgresql.enabled` is `false`. |
| db.poolInitialSize | int | `1` | poolInitialSize is the initial number of connections that are created when the pool is started. |
| db.poolMaxSize | int | `30` | poolMaxSize is the maximum number of connections that can be allocated from the pool at a given time. |
| db.poolMinSize | int | `2` | poolMinSize is the minimum number of connections that are maintained in the pool. |
| db.port | int | `5432` | port is the port number of the database server. This setting is ignored if `postgresql.enabled` is `false`. |
| db.schema | string | `"public"` | schema is the name of the database schema to use for Keycloak. This setting is ignored if `postgresql.enabled` is `false`. |
| db.vendor | string | `"postgres"` | vendor is the database vendor to use for Keycloak. Supported values are: postgres, mariadb, mysql, oracle, mssql, etc. This setting is ignored if `postgresql.enabled` is `false`. |
| devModeEnabled | bool | `false` | Indicates whether or not Keycloak is running in development mode. This will disable features and configurations that are only suitable for development environments. |
| extraEnvs | list | `[]` | Additional environment variables to set for the Keycloak server. These should be expressed as key-value pairs that can be either direct values or references to secrets.. Use the `additionalOptions` section for first-class options rather than KC_ values here. |
| fullnameOverride | string | `""` | Override for generated resource names. |
| hostname.host | string | `"keycloak.127.0.0.1.sslip.io"` | host is the hostname for the Keycloak server. Applicable for Hostname v1 and v2. |
| hostname.strict | bool | `true` | strict indicates whether the hostname should be treated as strict. This dynamically resolves the hostname from request headers. Applicable for Hostname v1 and v2. |
| image.pullPolicy | string | `"Always"` | pullPolicy is the strategy for pulling images from a registry. |
| image.pullSecret.password | string | `""` | password is the Docker password associated with the username with pull rights. |
| image.pullSecret.username | string | `""` | username is the Docker username associated with the password. |
| image.repository | string | `"quay.io/keycloak/keycloak"` | repository holding the container image. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| ingress.annotations | object | `{}` | annotations to be added to the Ingress resource. |
| ingress.className | string | `"traefik"` | className is the name of the Ingress class. |
| ingress.enabled | bool | `true` | Indicates whether or not an Ingress resource is created. |
| ingress.hosts[0].host | string | `"keycloak.127.0.0.1.sslip.io"` | host is the hostname of a request that must match exactly or use a wildcard as the subdomain. |
| ingress.hosts[0].paths[0].path | string | `"/"` | path is part of a list of one or more paths that are associated with a backend service. |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` | pathType is a field that can specify how Ingress paths should be matched. Reference [Path types](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types). |
| ingress.tls | list | `[]` | tls is a list of hosts that needs to explicitly match the host in the rules section. It also contains a secret with references to tls.crt and tls.key to use for TLS. |
| keycloakOperator.enabled | bool | `true` | Indicates whether or not the Keycloak Operator is installed. |
| keycloakOperator.watchAllNamespacesFor.keycloak | bool | `false` | keycloak is for indicating whether or not Keycloak resources will be watched in all namespaces. |
| keycloakOperator.watchAllNamespacesFor.keycloakOIDCClient | bool | `false` | keycloakOIDCClient is for indicating whether or not KeycloakOIDCClient resources will be watched in all namespaces. |
| keycloakOperator.watchAllNamespacesFor.keycloakRealmImport | bool | `false` | keycloakRealmImport is for indicating whether or not KeycloakRealmImport resources will be watched in all namespaces. |
| keycloakOperator.watchAllNamespacesFor.keycloakSAMLClient | bool | `false` | keycloakSAMLClient is for indicating whether or not KeycloakSAMLClient resources will be watched in all namespaces. |
| nameOverride | string | `""` | Override for chart name in helm common labels. |
| networkPolicy.egress | list | `[{}]` | egress may include a list of allowed egress rules. Each rule allows traffic which matches both the `to` and `ports` sections. The `to` section supports four kinds of selectors which are `podSelector`, `namespaceSelector`, and `ipBlock`. Both `namespaceSelector` and `podSelector` can be combined, but the semantics mean `and` instead of `or` when evaluating. Note: Specifying `- {}` whitelists all outbound traffic and `{}` does the same but on a specific selector, and `- to: []` will block all outbound traffic. Allow policies will override deny policies. Reference [Behavior of to and from selectors](https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors). |
| networkPolicy.enabled | bool | `false` | Specifies whether a network policy should be created. Note: This will have no effect unless the chosen CNI supports network policies like Calico, Weave, Cilium, Romana, etc. |
| networkPolicy.ingress | list | `[{}]` | ingress may include a list of allowed ingress rules. Each rule allows traffic which matches both the `from` and `ports` sections. The `from` section supports four kinds of selectors which are `podSelector`, `namespaceSelector`, and `ipBlock`. Both `namespaceSelector` and `podSelector` can be combined, but the semantics mean `and` instead of `or` when evaluating. Note: Specifying `- {}` whitelists all inbound traffic and `{}` does the same but on a specific selector, and `- to: []` will block all inbound traffic. Allow policies will override deny policies. Reference [Behavior of to and from selectors](https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors). |
| networkPolicy.policyTypes | list | `["Ingress","Egress"]` | policyTypes indicates whether or not the given policy applies to ingress traffic to the selected pod, egress traffic from the selected pods, or both. If no policy types are specified, then by default, Ingress will always be set and Egress will be set if any egress rules are defined. Reference [The NetworkPolicy resource](https://kubernetes.io/docs/concepts/services-networking/network-policies/#networkpolicy-resource). |
| nodeSelector | object | `{"kubernetes.io/os":"linux"}` | nodeSelector is the simplest way to constrain Pods to nodes with specific labels. Use affinity for more advance options. Reference [Assigning Pods to Nodes](https://kubernetes.io/docs/user-guide/node-selection). |
| podDisruptionBudget.create | bool | `false` | Indicates whether or not a PodDisruptionBudget resource is created. |
| podDisruptionBudget.minAvailable | int | `1` | minAvailable is the number of pods from that set that must still be available after the eviction, even in the absence of the evicted pod. Only integer values are supported. |
| postgresql.auth.database | string | `"keycloak"` | database is the name of the database to use for Keycloak. |
| postgresql.auth.password | string | `""` |  |
| postgresql.auth.username | string | `"postgres"` |  |
| postgresql.enabled | bool | `true` | Indicates whether or not a PostgreSQL database is created. |
| postgresql.nameOverride | string | `"keycloak-postgresql"` |  |
| priorityClassName | string | `""` | priorityClassName is the name of the PriorityClass resource that indicates the importance of a Pod relative to other Pods. If a Pod cannot be scheduled, the scheduler tries to preempt (evict) lower priority Pods to make scheduling of the pending Pod possible. Reference [Pod Priority and Preemption](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption). |
| replicaCount | int | `1` | replicaCount is the number of pod instances created by the Deployment owned ReplicaSet to increase availability when set to more than one. |
| resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| restartPolicy | string | `"Always"` | restartPolicy defines how a pod will automatically repair itself when a problem arises. Reference [Container restart policy](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy). |
| secrets | object | `{"foo":"bar"}` | secrets is used to store confidential data in key-value pairs. Quoting is required if the value is 0. |
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
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created. |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations | list | `[]` | tolerations allow the scheduler to schedule pods onto nodes with matching taints. Reference [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration). |
| updateStrategy | object | `{}` | The update strategy to apply to the Deployment resource. |


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
