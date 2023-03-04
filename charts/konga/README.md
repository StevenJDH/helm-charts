# Konga Helm Chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.14.9](https://img.shields.io/badge/AppVersion-0.14.9-informational?style=flat-square) 

A GUI to manage all Kong Admin API Objects.

## Source Code

* <https://github.com/pantsel/konga>

## Requirements

Kubernetes: `>= 1.19.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | kong | ^9.x |

## Usage example

```bash
helm repo add stevenjdh https://StevenJDH.github.io/helm-charts
helm repo update
helm upgrade --install my-konga stevenjdh/konga --version 0.1.0 \
    --set kong.enabled=true \
    --namespace example \
    --create-namespace \
    --atomic
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | affinity for pod scheduling. Reference [Assign Pods to Nodes using Node Affinity](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity). |
| annotations | object | `{}` | annotations to be added to the Deployment resource. |
| autoscaling.behavior | object | `{}` | behavior configures the scaling behavior of the target in both Up and Down directions (scaleUp and scaleDown fields respectively). |
| autoscaling.enabled | bool | `false` | Indicates whether or not a Horizontal Pod Autoscaling resource is created. Enabling is ignored if KEDA is enabled. |
| autoscaling.maxReplicas | int | `10` | maxReplicas is the upper limit for the number of replicas to which the autoscaler can scale up. It cannot be less that minReplicas. |
| autoscaling.minReplicas | int | `1` | minReplicas is the lower limit for the number of replicas to which the autoscaler can scale down. |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | targetCPUUtilizationPercentage represents the percentage of requested CPU over all the pods. |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` | targetMemoryUtilizationPercentage represents the percentage of requested memory over all the pods. |
| autoscaling.template | list | `[]` | template provides custom or additional autoscaling metrics that are not built in to Kubernetes or any Kubernetes component. Reference [Scaling on custom metrics](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#scaling-on-custom-metrics). |
| configMap.baseUrl | string | `""` | Define a base URL or relative path that Konga will be loaded from. Ex: www.example.com/konga. |
| configMap.dbAdapter | string | `"postgres"` | The database that Konga will use. If not set, the localDisk db will be used. Valid values are `mongo`, `mysql`, and `postgres`. |
| configMap.dbDatabase | string | `"konga_database"` | If `dbUri` is not specified, this is the name of Konga's db. Depends on `dbAdapter`. |
| configMap.dbHost | string | `"localhost"` | If `dbUri` is not specified, this is the database host. Depends on `dbAdapter`. |
| configMap.dbPgSchema | string | `"public"` | If using `postgres` as a database, `public` is the schema that will be used. |
| configMap.dbPort | string | `"5432"` | If `dbUri` is not specified, this is the database port. Depends on `dbAdapter`. |
| configMap.dbUri | string | `""` | The full db connection string. Depends on `dbAdapter`. If this is set, no other DB related var is needed. |
| configMap.dbUser | string | `""` | If `dbUri` is not specified, this is the database user. Depends on `dbAdapter`. |
| configMap.kongaAdminGroupReg | string | `^(admin\|konga)$` | Regular expression used to determine if a group should be considered as an admin user. |
| configMap.kongaAuthProvider | string | `"local"` | Defines what authentication provider to use. Valid values are `local` and `ldap`. |
| configMap.kongaHookTimeout | string | `"60000"` | The time in ms that Konga will wait for startup tasks to finish before exiting the process. |
| configMap.kongaLdapAttrEmail | string | `"mail"` | LDAP attribute name that should be used as the konga user's email address. |
| configMap.kongaLdapAttrFirstname | string | `"givenName"` | LDAP attribute name that should be used as the konga user's first name. |
| configMap.kongaLdapAttrLastname | string | `"sn"` | LDAP attribute name that should be used as the konga user's last name. |
| configMap.kongaLdapAttrUsername | string | `"uid"` | LDAP attribute name that should be used as the konga username. |
| configMap.kongaLdapBindDn | string | `""` | The DN that the konga should use to login to LDAP to search users. |
| configMap.kongaLdapGroupAttrs | string | `"cn"` | Comma separated list of attributes to pull from the LDAP server for groups. |
| configMap.kongaLdapGroupSearchBase | string | `"ou=groups,dc=com"` | The base DN used to search for groups. |
| configMap.kongaLdapGroupSearchFilter | string | `(\|(memberUid={{uid}})(memberUid={{uidNumber}})(sAMAccountName={{uid}}))` | The filter expression used to search for groups. Use {{some-attr}} where you expect a user attribute to be or {{dn}} for the user dn. |
| configMap.kongaLdapHost | string | `"ldap://localhost:389"` | The location of the LDAP server. |
| configMap.kongaLdapUserAttrs | string | `"uid,uidNumber,givenName,sn,mail"` | Comma separated list of attributes to pull from the LDAP server for users. |
| configMap.kongaLdapUserSearchBase | string | `"ou=users,dc=com"` | The base DN used to search for users. |
| configMap.kongaLdapUserSearchFilter | string | `(\|(uid={{username}})(sAMAccountName={{username}}))` | The filter expression used to search for users. Use {{username}} where you expect the username to be. |
| configMap.kongaLogLevel | string | `"debug"` | The logging level. Valid values are `silly`, `debug`, `info`, `warn`, and `error`. Set as `debug` if `nodeEnv` is set to `development`, otherwise, set as `warn` for production. |
| configMap.kongaSeedKongNodeDataSourceFile | string | `""` | Seed default Kong Admin API connections on first run. Reference [Adding a default kong node seed](https://github.com/pantsel/konga/blob/master/docs/SEED_DEFAULT_DATA.md#adding-a-default-kong-node-seed). |
| configMap.kongaSeedUserDataSourceFile | string | `""` | Seed default users on first run. Reference [Changing the default user seed data](https://github.com/pantsel/konga/blob/master/docs/SEED_DEFAULT_DATA.md#changing-the-default-user-seed-data). |
| configMap.noAuth | string | `"false"` | Run Konga without authentication. |
| configMap.nodeEnv | string | `"development"` | The environment. Valid values are `development` and `production`. |
| configMap.port | string | `"1337"` | The port that will be used by Konga's server. Must be aligned with `containerPorts.http` and `service.targetPort`. |
| configMap.sslCrtPath | string | `""` | If SSL is needed, this will be the absolute path to the .key file. Both `sslKeyPath` and `sslCrtPath` must be set.  |
| configMap.sslKeyPath | string | `""` | If SSL is needed, this will be the absolute path to the .key file. Both `sslKeyPath` and `sslCrtPath` must be set. |
| containerPorts | object | `{"http":1337}` | containerPort is the port or ports that the container listens on. |
| extraArgs | list | `[]` | Additional command line arguments to pass to the container. |
| extraEnvs | list | `[]` | Additional environment variables to set. |
| extraInitContainers | list | `[]` | Containers, which are run before the app containers are started. |
| extraVolumeMounts | list | `[]` | Additional volumeMounts for the main container. |
| extraVolumes | list | `[]` | Additional volumes for the pod. |
| fullnameOverride | string | `""` | Override for generated resource names. |
| image.pullPolicy | string | `"Always"` | pullPolicy is the strategy for pulling images from a registry. |
| image.pullSecret.password | string | `""` | password is the Docker password associated with the username with pull rights. |
| image.pullSecret.username | string | `""` | username is the Docker username associated with the password. |
| image.repository | string | `"pantsel/konga"` | repository holding the Konga container image. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| ingress.annotations | object | `{}` | annotations to add to the Ingress resource. |
| ingress.className | string | `"nginx"` | className is the name of the Ingress class. |
| ingress.enabled | bool | `true` | Indicates whether or not an Ingress resource is created. |
| ingress.hosts[0] | object | `{"host":"","paths":[{"path":"/","pathType":"Prefix"}]}` | host is the hostname of a request that must match exactly or use a wildcard as the subdomain. |
| ingress.hosts[0].paths[0] | object | `{"path":"/","pathType":"Prefix"}` | path is part of a list of one or more paths that are associated with a backend service. |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` | pathType is a field that can specify how Ingress paths should be matched. Reference [Path types](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types). |
| ingress.tls | list | `[]` | tls is a list of hosts that needs to explicitly match the host in the rules section. It also contains a secret with references to tls.crt and tls.key to use for TLS. |
| keda.apiVersion | string | `"keda.sh/v1alpha1"` | apiVersion is the KEDA API to use, which will be either `keda.k8s.io/v1alpha1` or `keda.sh/v1alpha1` depending on whether KEDA is version 1x or 2x respectively. |
| keda.behavior | object | `{}` | behavior is used to modify HPA's scaling behavior for the HPA definition that KEDA will create for a given resource. |
| keda.cooldownPeriod | int | `300` | cooldownPeriod is the period to wait after the last trigger reported active before scaling the resource back to 0. |
| keda.enabled | bool | `false` | Indicates whether or not a KEDA ScaleObject resource is created. Enabling this prevents a Horizontal Pod Autoscaling resource from being created. |
| keda.maxReplicas | int | `10` | maxReplicas is the maximum number of replicas KEDA will scale a target resource up to. |
| keda.minReplicas | int | `1` | minReplicas is the minimum number of replicas KEDA will scale a target resource down to. |
| keda.pollingInterval | int | `30` | pollingInterval is the interval to check each trigger on. |
| keda.restoreToOriginalReplicaCount | bool | `false` | restoreToOriginalReplicaCount specifies whether the target resource (Deployment, StatefulSet,…) should be scaled back to original replicas count, after the ScaledObject is deleted. Default behavior is to keep the replica count at the same number as it is in the moment of ScaledObject's deletion. |
| keda.scaledObject.annotations | object | `{}` | annotations to add to the ScaledObject resource. |
| keda.triggers | list | `[]` | triggers is a list of triggers to activate scaling on for a target resource. |
| kong.enabled | bool | `false` | Indicates whether or not to deploy Kong with Konga. |
| kong.ingressController.enabled | bool | `true` | Indicates whether or not to deploy the Kong Ingress Controller |
| kong.metrics.enabled | bool | `false` | Indicates whether or not to enable the export of Prometheus metrics for Kong. |
| kong.replicaCount | int | `2` | replicaCount is the number of Kong pod instances created by the Deployment owned ReplicaSet to increase availability when set to more than one. |
| migrations.annotations | object | `{}` | annotations to add to the DB migrations Job resource. |
| migrations.enabled | bool | `true` | Indicates whether or not to run DB migrations when `configMap.dbAdapter` is set to `mysql` or `postgres` because this isn't done automatically when `configMap.nodeEnv` is set to `production`. |
| migrations.job.podAnnotations | object | `{}` | podAnnotations are the annotations to be added to the job pods. |
| migrations.resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| nameOverride | string | `""` | Override for chart name in helm common labels. |
| nodeSelector | object | `{"kubernetes.io/os":"linux"}` | nodeSelector is the simplest way to constrain Pods to nodes with specific labels. Use affinity for more advance options. Reference [Assigning Pods to Nodes](https://kubernetes.io/docs/user-guide/node-selection). |
| podAnnotations | object | `{}` | podAnnotations are the annotations to be added to the deployment pods. |
| replicaCount | int | `1` | replicaCount is the number of pod instances created by the Deployment owned ReplicaSet to increase availability when set to more than one. |
| resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| secrets.dbPassword | string | `""` | If `dbUri` is not specified, this is the database user's password. Depends on `dbAdapter`. |
| secrets.kongaLdapBindPassword | string | `""` | The password for the user konga will use to search for users. |
| secrets.tokenSecret | string | `""` | The secret that will be used to sign JWT tokens issued by Konga. |
| service.annotations | object | `{}` | annotations to add to the service resource. |
| service.appProtocol | bool | `true` | appProtocol overrides annotations in a service resource that were used for setting a backend protocol. In AWS for example, `service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http`. See the following GitHub issue for more details [kubernetes/kubernetes#40244](https://github.com/kubernetes/kubernetes/issues/40244). Will be ignored for Kubernetes versions older than 1.20. |
| service.clusterIP | string | `""` | clusterIP allows for customizing the cluster IP address of a service resource. |
| service.externalIPs | list | `[]` | externalIPs is a list of IP addresses at which a service is available at. Reference [External IPs](https://kubernetes.io/docs/user-guide/services/#external-ips). |
| service.externalTrafficPolicy | string | `""` | externalTrafficPolicy is an annotation set on a service resource. It defines how traffic incoming to a node is load balanced. `Cluster` is normally the default policy, but `Local` is often used to preserve the source IP of traffic coming into a cluster node. With Local, requests are load balanced equally across nodes irrespective of how many pods are on each node. When set to Cluster, both nodes and pods are taken into consideration. Applicable only when `service.type` is `NodePort` or `LoadBalancer`. Reference [Preserving the client source IP](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip). |
| service.healthCheckNodePort | int | `0` | healthCheckNodePort specifies the health check node port (numeric port number) for the service. If healthCheckNodePort isn’t specified, the service controller allocates a port from your cluster’s NodePort range. Reference [Preserving the client source IP](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip). |
| service.ipFamilies | list | `["IPv4"]` | ipFamilies is a list of IP families (e.g. IPv4, IPv6) assigned to a service. This field is usually assigned automatically based on cluster configuration and the ipFamilyPolicy field. [IPv4/IPv6 dual-stack](https://kubernetes.io/docs/concepts/services-networking/dual-stack) |
| service.ipFamilyPolicy | string | `"SingleStack"` | ipFamilyPolicy represents the dual-stack-ness requested or required by this Service. Possible values are SingleStack, PreferDualStack or RequireDualStack. The ipFamilies and clusterIPs fields depend on the value of this field. Reference [IPv4/IPv6 dual-stack](https://kubernetes.io/docs/concepts/services-networking/dual-stack) |
| service.loadBalancerIP | string | `""` | loadBalancerIP is a field used by cloud providers to connect the resulting `LoadBalancer` created by a service resource to a pre-existing static IP. Reference [Type LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer). This field is deprecated as of Kubernetes 1.24.0 since it doesn't support dual-stack, but there is no replacement as of yet. Most likely cloud providers will adopt a provider specific annotation approach for this. Progress can be tracked here [kubernetes/enhancements#1992](https://github.com/kubernetes/enhancements/pull/1992). |
| service.loadBalancerSourceRanges | list | `[]` | loadBalancerSourceRanges is a list of one or more internal or external IP address ranges. If not set, a Service will accept traffic from any IP address (0.0.0.0/0). |
| service.sessionAffinity | string | `"None"` | sessionAffinity ensures that connections from a particular client are passed to the same Pod each time based on the client's IP address. Must be either "None" or "ClientIP" if set. Reference [User space proxy mode](https://kubernetes.io/docs/concepts/services-networking/service/#proxy-mode-userspace) |
| service.type | string | `"ClusterIP"` | type specifies what kind of Service resource to create. |
| serviceAccount.annotations | object | `{}` | annotations to add to the service account. |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created. |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations | list | `[]` | tolerations allow the scheduler to schedule pods onto nodes with matching taints. Reference [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration). |
| updateStrategy | object | `{}` | The update strategy to apply to the Deployment resource. |


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
