# Strimzi Cluster Helm Chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.45.0](https://img.shields.io/badge/AppVersion-0.45.0-informational?style=flat-square) 

Installs Strimzi, Drain Cleaner, and a Kafka cluster in KRaft mode.

## Source Code

* <https://github.com/strimzi/strimzi-kafka-operator>

## Requirements

Kubernetes: `>= 1.25.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://StevenJDH.github.io/helm-charts | shared-library | ^0.x |
| oci://quay.io/strimzi-helm | strimzi-drain-cleaner | 1.2.0 |
| oci://quay.io/strimzi-helm | strimzi-kafka-operator | 0.45.0 |

## Usage example

```bash
helm repo add stevenjdh https://StevenJDH.github.io/helm-charts
helm repo update
helm upgrade --install my-strimzi-cluster stevenjdh/strimzi-cluster --version 0.1.0 \
    --set strimzi-kafka-operator.enabled=true \
    --set strimzi-drain-cleaner.enabled=true \
    --set strimzi-drain-cleaner.certManager.create=false \
    --set-file strimzi-drain-cleaner.secret.tls_crt=tls.crt.base64 \
    --set-file strimzi-drain-cleaner.secret.tls_key=tls.key.base64 \
    --set-file strimzi-drain-cleaner.secret.ca_bundle=ca.crt.base64 \
    --set kafka.rackTopology.enabled=false \
    --namespace example \
    --create-namespace \
    --atomic
```

> [!TIP]
> To test Drain Cleaner, run the command `kubectl drain <node-name> --delete-emptydir-data --ignore-daemonsets --timeout=6000s --force` against a node with a broker, which will fail the first time because the strimzi cluster operator will take over for relocating those workloads. Then, rerun the command again after a few minutes, and it will work this time. For more info, see [Using the Strimzi Drain Cleaner](https://github.com/strimzi/drain-cleaner?tab=readme-ov-file#see-it-in-action).

### Create Drain Cleaner certificate chain

The following shows how to create the needed TLS certificates if Drain Cleaner will be installed with `strimzi-drain-cleaner.certManager.create` set to `false` as per above example. OpenSSL CLI v1.1.1 or newer is required.

```bash
# 1. Set the namespace used by Drain Cleaner.
namespace=strimzi-drain-cleaner

# 2. Create CA certificate and key.
openssl req -x509 -sha256 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 11688 -noenc \
    -subj "/CN=Strimzi Drain Cleaner Root CA/O=StevenJDH" \
    -addext "basicConstraints=critical,CA:TRUE,pathlen:1" \
    -addext "keyUsage=critical,keyCertSign,cRLSign" \
    -addext "subjectKeyIdentifier=hash"

# 3. Create certificate signing request (*.csr) and private key.
openssl req -new -newkey rsa:4096 -keyout tls.key -out tls.csr -noenc \
    -subj "/CN=strimzi-drain-cleaner.$namespace.svc/O=StevenJDH" \
    -addext "basicConstraints=critical,CA:FALSE" \
    -addext "extendedKeyUsage=serverAuth" \
    -addext "keyUsage=critical,digitalSignature,keyEncipherment,keyAgreement" \
    -addext "subjectAltName=DNS:strimzi-drain-cleaner.$namespace.svc" \
    -addext "subjectKeyIdentifier=hash"

# 4. Created CA signed server certificate from CSR.
openssl x509 -req -sha256 -days 11688 -in tls.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out tls.crt \
    -copy_extensions copy

# 5. Base64 encode the files as expected by the Drain Cleaner.
base64 -w0 tls.crt > tls.crt.base64
base64 -w0 tls.key > tls.key.base64
base64 -w0 ca.crt > ca.crt.base64
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cruiseControlRebalance.annotations."strimzi.io/rebalance-auto-approval" | string | `"true"` | Triggers the rebalance directly without any further approval step (e.g., setting `strimzi.io/rebalance=approve` when the `PROPOSALREADY` column is `TRUE`). Use `strimzi.io/rebalance=refresh` to trigger a new analysis. |
| cruiseControlRebalance.create | bool | `true` | Indicates whether or not to create a KafkaRebalance resource with an empty spec to use the default goals from the Cruise Control configuration for optimizing the cluster workloads. |
| cruiseControlRebalance.labels | object | `{}` | labels to be added to the Kafka Rebalance resource. |
| fullnameOverride | string | `""` | Override for generated resource names. |
| kafka.annotations | object | `{}` | annotations to be added to the Kafka resource. |
| kafka.authorization.superUsers | list | `[]` | superUsers is a list of users that are considered super users and can perform any operation regardless of any access restrictions configured because the ACL rules aren't queried. Reference: [Designating super users](https://strimzi.io/docs/operators/0.45.0/deploying#designating_super_users). |
| kafka.authorization.type | string | `"simple"` | type is the type of authorization to use on the Kafka brokers. Supported values are [simple](https://strimzi.io/docs/operators/0.45.0/configuring#type-KafkaAuthorizationSimple-schema-reference), [opa](https://strimzi.io/docs/operators/0.45.0/configuring#type-KafkaAuthorizationOpa-schema-reference), [keycloak](https://strimzi.io/docs/operators/0.45.0/configuring#type-KafkaAuthorizationKeycloak-reference), and [custom](https://strimzi.io/docs/operators/0.45.0/configuring#type-KafkaAuthorizationCustom-schema-reference). |
| kafka.clientsCa.generateCertificateAuthority | bool | `true` | generateCertificateAuthority indicates whether or not to generate a Certificate Authority for clients. Setting this to `false` requires providing a Secret with the CA certificate, and there will be several steps to consider for manually managing custom certificates and renewals. Reference: [Using your own CA certificates and private keys](https://strimzi.io/docs/operators/0.45.0/full/deploying.html#security-using-your-own-certificates-str). |
| kafka.clientsCa.generateSecretOwnerReference | bool | `true` | generateSecretOwnerReference indicates whether or not to set the `ownerReference` on the Client CA to the Kafka resource. If `true`, and the Kafka resource is deleted, the generated CA Secret is also deleted. If `false`, the `ownerReference` is disabled, which will retain the CA Secret for reuse when the Kafka resource is deleted. |
| kafka.clientsCa.renewalDays | int | `30` | renewalDays is the number of days in the certificate renewal period. This is the number of days before a certificate expires during which renewal actions may be performed. When generateCertificateAuthority is `true`, this will cause the generation of a new certificate, and this will cause extra logging at WARN level about the pending certificate expiry. |
| kafka.clientsCa.validityDays | int | `365` | validityDays is the number of days generated certificates should be valid for. |
| kafka.clusterCa.generateCertificateAuthority | bool | `true` | generateCertificateAuthority indicates whether or not to generate a Certificate Authority for the cluster. Setting this to `false` requires providing a Secret with the CA certificate, and there will be several steps to consider for manually managing custom certificates and renewals. Reference: [Using your own CA certificates and private keys](https://strimzi.io/docs/operators/0.45.0/full/deploying.html#security-using-your-own-certificates-str). |
| kafka.clusterCa.generateSecretOwnerReference | bool | `true` | generateSecretOwnerReference indicates whether or not to set the `ownerReference` on the Cluster CA to the Kafka resource. If `true`, and the Kafka resource is deleted, the generated CA Secret is also deleted. If `false`, the `ownerReference` is disabled, which will retain the CA Secret for reuse when the Kafka resource is deleted. |
| kafka.clusterCa.renewalDays | int | `30` | renewalDays is the number of days in the certificate renewal period. This is the number of days before a certificate expires during which renewal actions may be performed. When generateCertificateAuthority is `true`, this will cause the generation of a new certificate, and this will cause extra logging at WARN level about the pending certificate expiry. |
| kafka.clusterCa.validityDays | int | `365` | validityDays is the number of days generated certificates should be valid for. |
| kafka.config."auto.create.topics.enable" | string | `"false"` | auto.create.topics.enable indicates whether or not to allow the Kafka broker to auto-create topics. It is recommended that this be set to `false` to avoid races between the operator and Kafka applications auto-creating topics. |
| kafka.config."default.replication.factor" | int | `3` | default.replication.factor is the default replication factor for the Kafka topics. A replication factor of 1 will always affect availability when the brokers are restarted. |
| kafka.config."min.insync.replicas" | int | `2` | min.insync.replicas is the minimum number of in-sync replicas for the Kafka topics. The in-sync replicas count should always be set to a number lower than the `*.replication.factor` or it will always affect availability when the brokers are restarted. |
| kafka.config."offsets.topic.replication.factor" | int | `3` | offsets.topic.replication.factor is the replication factor for the offsets topic. A replication factor of 1 will always affect availability when the brokers are restarted. |
| kafka.config."transaction.state.log.min.isr" | int | `2` | transaction.state.log.min.isr is the minimum number of in-sync replicas for the transaction state log topic. The in-sync replicas count should always be set to a number lower than the `transaction.state.log.replication.factor` or it will always affect availability when the brokers are restarted. |
| kafka.config."transaction.state.log.replication.factor" | int | `3` | transaction.state.log.replication.factor is the replication factor for the transaction state log topic. A replication factor of 1 will always affect availability when the brokers are restarted. |
| kafka.cruiseControl | object | `{}` | cruiseControl deploys the Cruise Control component to optimize Kafka when specified. Being present and not null is enough to enable it. It will also enable `kafka.metricsEnabled` by default and configure metrics for cruise control, so no need to configure here (e.g., `kafka.cruiseControl.metricsConfig`). Reference: [CruiseControlSpec schema reference](https://strimzi.io/docs/operators/0.45.0/configuring.html#type-CruiseControlSpec-reference). |
| kafka.entityOperator.template | object | `{}` | template allows to customize how the resources belonging to the Entity Operator are generated. |
| kafka.entityOperator.topicOperator | object | `{}` | topicOperator allows to customize the configuration of the Topic Operator. By Default, the Topic Operator watches for KafkaTopic resources in the namespace of the Kafka cluster deployed by the Cluster Operator. Reference: [EntityTopicOperatorSpec schema properties](https://strimzi.io/docs/operators/0.45.0/configuring#type-EntityTopicOperatorSpec-schema-reference). |
| kafka.entityOperator.userOperator | object | `{}` | userOperator allows to customize the configuration of the User Operator. By Default, the User Operator watches for KafkaUser resources in the namespace of the Kafka cluster deployed by the Cluster Operator. Reference: [EntityUserOperatorSpec schema properties](https://strimzi.io/docs/operators/0.45.0/configuring#type-EntityUserOperatorSpec-schema-reference). |
| kafka.kafkaExporter | object | `{}` | kafkaExporter allows to customize the configuration of the Kafka Exporter. Reference: [KafkaExporterSpec schema reference](https://strimzi.io/docs/operators/0.45.0/configuring.html#type-KafkaExporterSpec-reference) |
| kafka.labels | object | `{}` | labels to be added to the Kafka resource. |
| kafka.listeners[0].name | string | `"plain"` | name is the unique name of the listener within given a Kafka cluster. It consists of lowercase characters and numbers and can be up to 11 characters long. |
| kafka.listeners[0].port | int | `9092` | port is the port number for the listener. When configuring listeners for client access to brokers, use port 9092 or higher, but with a few exceptions. The listeners cannot be configured to use the ports reserved for interbroker communication (9090 and 9091), Prometheus metrics (9404), and JMX (Java Management Extensions) monitoring (9999).  |
| kafka.listeners[0].tls | bool | `false` | tls indicates whether or not to enable TLS for the listener. For `route` and `ingress` type listeners, TLS encryption must be always enabled. |
| kafka.listeners[0].type | string | `"internal"` | type is the type of listener. Supported values are `ingress`, `internal`, `route` (OpenShift only), `loadbalancer`, `cluster-ip`, and `nodeport`. Reference: [Configuring listeners to connect to Kafka](https://strimzi.io/docs/operators/0.45.0/deploying#configuration-points-listeners-str). |
| kafka.listeners[1].authentication.type | string | `"tls"` | type is the type of authentication to use on the Kafka brokers. Supported values are `tls`, `scram-sha-512`, `oauth`, and `custom`. |
| kafka.listeners[1].configuration.useServiceDnsDomain | bool | `true` | useServiceDnsDomain indicates whether or not to use the service DNS domain for the listener. By default, `internal` and `cluster-ip` listeners and their headless service do not use the Kubernetes service DNS domain (typically .cluster.local). This makes them only accessible from within the same namespace (i.e., <service-name>). To enable cross-namespace communication, set this to `true`. Reference: [Using fully-qualified DNS names](https://strimzi.io/docs/operators/0.45.0/configuring#property-listener-config-dns-reference). |
| kafka.listeners[1].name | string | `"tls"` | name is the unique name of the listener within given a Kafka cluster. It consists of lowercase characters and numbers and can be up to 11 characters long. |
| kafka.listeners[1].port | int | `9094` | port is the port number for the listener. When configuring listeners for client access to brokers, use port 9092 or higher, but with a few exceptions. The listeners cannot be configured to use the ports reserved for interbroker communication (9090 and 9091), Prometheus metrics (9404), and JMX (Java Management Extensions) monitoring (9999). |
| kafka.listeners[1].tls | bool | `true` | tls indicates whether or not to enable TLS for the listener. For `route` and `ingress` type listeners, TLS encryption must be always enabled. |
| kafka.listeners[1].type | string | `"internal"` | type is the type of listener. Supported values are `ingress`, `internal`, `route` (OpenShift only), `loadbalancer`, `cluster-ip`, and `nodeport`. Reference: [Configuring listeners to connect to Kafka](https://strimzi.io/docs/operators/0.45.0/deploying#configuration-points-listeners-str). |
| kafka.logging | object | `{}` | logging allows to customize the logging configuration of the Kafka cluster. Reference: [Configuring logging levels](https://strimzi.io/docs/operators/0.45.0/deploying#external-logging_str). |
| kafka.maintenanceTimeWindows | list | `[]` | maintenanceTimeWindows is a list of time windows for maintenance tasks (e.g., certificate renewals). Each time window is defined by a [cron expression](http://www.cronmaker.com). Reference: [Quartz Tutorials - CronTrigger](https://www.quartz-scheduler.org/documentation/quartz-2.3.0/tutorials/tutorial-lesson-06.html). |
| kafka.metricsEnabled | bool | `true` | Indicates whether or not to enable the JMX Prometheus Exporter metrics for Kafka. This is enabled by default if `kafka.cruiseControl` is present. |
| kafka.rackTopology.customKey | string | `""` | customKey allows to override the standard `topology.kubernetes.io/zone` key used for the rack-aware feature. |
| kafka.rackTopology.enabled | bool | `true` | Indicates whether or not to enable the rack-aware feature for the node pools to improve resiliency, availability, and reliability. Strimzi will automatically add the Kubernetes preferred affinity rule to distribute the node pools across the different availability zones or actual racks in the data center, which is not guaranteed to be evenly done. As such, Cruise Control will make sure that replicas remain and get distributed properly if in use. When testing locally, set this  to `false`. |
| kafka.template | object | `{}` | template allows to customize the configuration of the Kafka cluster. Reference: [KafkaClusterTemplate schema reference](https://strimzi.io/docs/operators/0.45.0/configuring.html#type-KafkaClusterTemplate-reference). |
| kafka.version | string | `"3.9.0"` | version is the version of Kafka to use. |
| nameOverride | string | `""` | Override for chart name in helm common labels. |
| nodePools.broker.annotations | object | `{}` | annotations to be added to the KafkaNodePool resource. |
| nodePools.broker.enabled | bool | `true` | Indicates whether or not to deploy this broker node pool with the Kafka cluster. Should be set to `false` if using a dual-role broker pool. |
| nodePools.broker.jvmOptions | object | `{}` | jvmOptions allows to customize the JVM options for the node pool pods. |
| nodePools.broker.labels | object | `{}` | labels to be added to the KafkaNodePool resource. |
| nodePools.broker.nameOverride | string | `""` | nameOverride allows to override the generated pool name that is based on the config key, in this  case `<cluster-name>-broker`, to something custom. |
| nodePools.broker.replicas | int | `3` | replicas is the number of instances in the node pool. |
| nodePools.broker.resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| nodePools.broker.roles | list | `["broker"]` | roles is a list of roles that the node pool will have. Supported values are `broker` and `controller`. |
| nodePools.broker.storage.type | string | `"jbod"` | type is the type of storage to use. Supported values are `ephemeral` and `jbod`, or an older approach using `persistent-claim` directly. Reference: [KafkaNodePoolSpec schema reference](https://strimzi.io/docs/operators/0.45.0/configuring.html#type-KafkaNodePoolSpec-reference). |
| nodePools.broker.storage.volumes[0].class | string | `nil` | class is the storage class to use for the PersistentVolumeClaim. Omit or set to `null` to use the default storage class. |
| nodePools.broker.storage.volumes[0].deleteClaim | bool | `true` | deleteClaim indicates whether or not to delete the PersistentVolumeClaim when the Kafka cluster is deleted. |
| nodePools.broker.storage.volumes[0].id | int | `0` | id is the volume ID. |
| nodePools.broker.storage.volumes[0].kraftMetadata | string | `"shared"` | kraftMetadata indicates that this directory will be used to store and access the KRaft metadata log. |
| nodePools.broker.storage.volumes[0].size | string | `"1Gi"` | size is the size of the volume. |
| nodePools.broker.storage.volumes[0].type | string | `"persistent-claim"` | type is the type of volume to use. Supported values are `ephemeral` and `persistent-claim`. |
| nodePools.broker.template | object | `{}` | template allows to customize how the resources belonging to this pool are generated. Reference: [KafkaNodePoolTemplate schema reference](https://strimzi.io/docs/operators/0.45.0/configuring.html#type-KafkaNodePoolTemplate-reference). |
| nodePools.dual-role-broker.annotations | object | `{}` | annotations to be added to the KafkaNodePool resource. |
| nodePools.dual-role-broker.enabled | bool | `false` | Indicates whether or not to deploy this dual-role broker pool with the Kafka cluster. Should be set to `false` if using other broker and controller node pools. |
| nodePools.dual-role-broker.jvmOptions | object | `{}` | jvmOptions allows to customize the JVM options for the node pool pods. |
| nodePools.dual-role-broker.labels | object | `{}` | labels to be added to the KafkaNodePool resource. |
| nodePools.dual-role-broker.nameOverride | string | `""` | nameOverride allows to override the generated pool name that is based on the config key, in this  case `<cluster-name>-dual-role-broker`, to something custom. |
| nodePools.dual-role-broker.replicas | int | `3` | replicas is the number of instances in the node pool. |
| nodePools.dual-role-broker.resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| nodePools.dual-role-broker.roles | list | `["controller", "broker"]` | roles is a list of roles that the node pool will have. Supported values are `broker` and `controller`. |
| nodePools.dual-role-broker.storage.type | string | `"jbod"` | type is the type of storage to use. Supported values are `ephemeral` and `jbod`, or an older approach using `persistent-claim` directly. Reference: [KafkaNodePoolSpec schema reference](https://strimzi.io/docs/operators/0.45.0/configuring.html#type-KafkaNodePoolSpec-reference). |
| nodePools.dual-role-broker.storage.volumes[0].class | string | `nil` | class is the storage class to use for the PersistentVolumeClaim. Omit or set to `null` to use the default storage class. |
| nodePools.dual-role-broker.storage.volumes[0].deleteClaim | bool | `true` | deleteClaim indicates whether or not to delete the PersistentVolumeClaim when the Kafka cluster is deleted. |
| nodePools.dual-role-broker.storage.volumes[0].id | int | `0` | id is the volume ID. |
| nodePools.dual-role-broker.storage.volumes[0].kraftMetadata | string | `"shared"` | kraftMetadata indicates that this directory will be used to store and access the KRaft metadata log. |
| nodePools.dual-role-broker.storage.volumes[0].size | string | `"1Gi"` | size is the size of the volume. |
| nodePools.dual-role-broker.storage.volumes[0].type | string | `"persistent-claim"` | type is the type of volume to use. Supported values are `ephemeral` and `persistent-claim`. |
| nodePools.dual-role-broker.template | object | `{}` | template allows to customize how the resources belonging to this pool are generated. Reference: [KafkaNodePoolTemplate schema reference](https://strimzi.io/docs/operators/0.45.0/configuring.html#type-KafkaNodePoolTemplate-reference). |
| nodePools.kraft-controller.annotations | object | `{}` | annotations to be added to the KafkaNodePool resource. |
| nodePools.kraft-controller.enabled | bool | `true` | Indicates whether or not to deploy this controller node pool with the Kafka cluster. Should be set to `false` if using a dual-role broker pool. |
| nodePools.kraft-controller.jvmOptions | object | `{}` | jvmOptions allows to customize the JVM options for the node pool pods. |
| nodePools.kraft-controller.labels | object | `{}` | labels to be added to the KafkaNodePool resource. |
| nodePools.kraft-controller.nameOverride | string | `""` | nameOverride allows to override the generated pool name that is based on the config key, in this  case `<cluster-name>-kraft-controller`, to something custom. |
| nodePools.kraft-controller.replicas | int | `3` | replicas is the number of instances in the node pool. |
| nodePools.kraft-controller.resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| nodePools.kraft-controller.roles | list | `["controller"]` | roles is a list of roles that the node pool will have. Supported values are `broker` and `controller`. |
| nodePools.kraft-controller.storage.type | string | `"jbod"` | type is the type of storage to use. Supported values are `ephemeral` and `jbod`, or an older approach using `persistent-claim` directly. Reference: [KafkaNodePoolSpec schema reference](https://strimzi.io/docs/operators/0.45.0/configuring.html#type-KafkaNodePoolSpec-reference). |
| nodePools.kraft-controller.storage.volumes[0].class | string | `nil` | class is the storage class to use for the PersistentVolumeClaim. Omit or set to `null` to use the default storage class. |
| nodePools.kraft-controller.storage.volumes[0].deleteClaim | bool | `true` | deleteClaim indicates whether or not to delete the PersistentVolumeClaim when the Kafka cluster is deleted. |
| nodePools.kraft-controller.storage.volumes[0].id | int | `0` | id is the volume ID. |
| nodePools.kraft-controller.storage.volumes[0].kraftMetadata | string | `"shared"` | kraftMetadata indicates that this directory will be used to store and access the KRaft metadata log. |
| nodePools.kraft-controller.storage.volumes[0].size | string | `"1Gi"` | size is the size of the volume. |
| nodePools.kraft-controller.storage.volumes[0].type | string | `"persistent-claim"` | type is the type of volume to use. Supported values are `ephemeral` and `persistent-claim`. |
| nodePools.kraft-controller.template | object | `{}` | template allows to customize how the resources belonging to this pool are generated. Reference: [KafkaNodePoolTemplate schema reference](https://strimzi.io/docs/operators/0.45.0/configuring.html#type-KafkaNodePoolTemplate-reference). |
| strimzi-drain-cleaner.certManager.create | bool | `false` | Indicates whether or not to create the Certificate and Issuer custom resources used for the ValidatingWebhookConfiguration and ValidationWebhook when cert-manager is installed. |
| strimzi-drain-cleaner.enabled | bool | `true` | Indicates whether or not to deploy Drain Cleaner with the Kafka cluster. |
| strimzi-drain-cleaner.namespace.create | bool | `true` | Indicates whether or not to create the namespace defined at `strimzi-drain-cleaner.namespace.name` for where Drain Cleaner resources will be deployed. |
| strimzi-drain-cleaner.namespace.name | string | `"strimzi-drain-cleaner"` | name is the name of the namespace where the Drain Cleaner resources will be deployed, but also, it's used for RBAC permissions regardless of the `strimzi-drain-cleaner.namespace.create` state. |
| strimzi-drain-cleaner.replicaCount | int | `1` | replicaCount is for the number of Drain Cleaner instances. |
| strimzi-drain-cleaner.resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| strimzi-drain-cleaner.secret.ca_bundle | string | `""` | ca_bundle is the CA certificate bundle in PEM format used for the ValidatingWebhookConfiguration regardless of the `strimzi-drain-cleaner.secret.create` state. Required when `strimzi-drain-cleaner.certManager.create` is `false`. |
| strimzi-drain-cleaner.secret.create | bool | `true` | Indicates whether or not to create a TLS secret. Kubernetes requires ValidationWebhooks to be secured by TLS like the one used by Drain Cleaner's webhook service endpoint to receive Strimzi pod eviction events. |
| strimzi-drain-cleaner.secret.tls_crt | string | `""` | tls_crt is the TLS certificate in PEM format used for the ValidationWebhook. Required when `strimzi-drain-cleaner.certManager.create` is `false`. |
| strimzi-drain-cleaner.secret.tls_key | string | `""` | tls_key is the TLS private key in PEM format used for the ValidationWebhook. Required when `strimzi-drain-cleaner.certManager.create` is `false`. |
| strimzi-kafka-operator.affinity | object | `{}` | affinity for pod scheduling. Reference [Assign Pods to Nodes using Node Affinity](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity). |
| strimzi-kafka-operator.enabled | bool | `true` | Indicates whether or not to deploy Strimzi with the Kafka cluster. |
| strimzi-kafka-operator.nodeSelector | object | `{"kubernetes.io/os":"linux"}` | nodeSelector is the simplest way to constrain Pods to nodes with specific labels. Use affinity for more advance options. Reference [Assigning Pods to Nodes](https://kubernetes.io/docs/user-guide/node-selection). |
| strimzi-kafka-operator.replicas | int | `1` | replicas is for the number of cluster operator instances. |
| strimzi-kafka-operator.resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| strimzi-kafka-operator.tolerations | list | `[]` | tolerations allow the scheduler to schedule pods onto nodes with matching taints. Reference [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration). |
| testResources.create | bool | `false` | Indicates whether or not to create the test resources, which consist of a KafkaUser and a KafkaTopic. |


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
