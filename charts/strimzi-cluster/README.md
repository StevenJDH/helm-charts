# Strimzi Cluster Helm Chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.45.0](https://img.shields.io/badge/AppVersion-0.45.0-informational?style=flat-square) 

Installs Strimzi, Drain Cleaner, and a Kafka cluster in KRaft mode.

## Source Code

* <https://github.com/strimzi/strimzi-kafka-operator>

## Requirements

Kubernetes: `>= 1.25.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://StevenJDH.github.io/helm-charts | shared-library | 0.1.3 |
| oci://quay.io/strimzi-helm | strimzi-drain-cleaner | 1.2.0 |
| oci://quay.io/strimzi-helm | strimzi-kafka-operator | 0.45.0 |

## Usage example

```bash
helm repo add stevenjdh https://StevenJDH.github.io/helm-charts
helm repo update
helm upgrade --install my-strimzi-cluster stevenjdh/strimzi-cluster --version 0.1.0 \
    --set strimzi-kafka-operator.enabled=true \
    --set strimzi-drain-cleaner.enabled=true \
    --set-file strimzi-drain-cleaner.secret.tls_crt=tls.crt.base64 \
    --set-file strimzi-drain-cleaner.secret.tls_key=tls.key.base64 \
    --set-file strimzi-drain-cleaner.secret.ca_bundle=ca.crt.base64 \
    --namespace example \
    --create-namespace \
    --atomic
```

> [!TIP]
> To test Drain Cleaner, run the command `kubectl drain <node-name> --delete-emptydir-data --ignore-daemonsets --timeout=6000s --force` against a node with a broker, which will fail the first time because the strimzi cluster operator will take over for relocating those workloads. Then, rerun the command again after a few minutes, and it will work this time.

### Create Drain Cleaner certificate chain

The following will create the needed TLS certificates if Drain Cleaner will be installed as per above example. OpenSSL CLI v1.1.1 or newer is required.

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
| cruiseControlRebalance.labels | object | `{}` |  |
| fullnameOverride | string | `""` | Override for generated resource names. |
| kafka.affinity | object | `{}` |  |
| kafka.annotations | object | `{}` |  |
| kafka.authorization.type | string | `"simple"` |  |
| kafka.certificates.clientsCa.generateCertificateAuthority | bool | `true` |  |
| kafka.certificates.clientsCa.generateSecretOwnerReference | bool | `true` |  |
| kafka.certificates.clientsCa.renewalDays | int | `30` |  |
| kafka.certificates.clientsCa.validityDays | int | `365` |  |
| kafka.certificates.clusterCa.generateCertificateAuthority | bool | `true` | If `true`, then Certificate Authority certificates will be generated automatically. Otherwise, a Secret needs to be provided with the CA certificate. Note: Setting this to `false` requires several steps for manually managing custom certificates and renewals. Reference: https://strimzi.io/docs/operators/0.45.0/full/deploying.html#security-using-your-own-certificates-str. |
| kafka.certificates.clusterCa.generateSecretOwnerReference | bool | `true` | If `true`, the Cluster and Client CA Secrets are configured with the ownerReference set to the Kafka resource. If the Kafka resource is deleted, the CA Secrets are also deleted. If `false`, the ownerReference is disabled. If the Kafka resource is deleted, the CA Secrets are retained and available for reuse. |
| kafka.certificates.clusterCa.renewalDays | int | `30` | The number of days in the certificate renewal period. This is the number of days before the a certificate expires during which renewal actions may be performed. When generateCertificateAuthority is `true`, this will cause the generation of a new certificate, and this will cause extra logging at WARN level about the pending certificate expiry. |
| kafka.certificates.clusterCa.validityDays | int | `365` | The number of days generated certificates should be valid for. |
| kafka.config."auto.create.topics.enable" | string | `"false"` |  |
| kafka.config."default.replication.factor" | int | `3` |  |
| kafka.config."min.insync.replicas" | int | `2` |  |
| kafka.config."offsets.topic.replication.factor" | int | `3` |  |
| kafka.config."transaction.state.log.min.isr" | int | `2` |  |
| kafka.config."transaction.state.log.replication.factor" | int | `3` |  |
| kafka.cruiseControl | object | `{}` | cruiseControl deploys the Cruise Control component to optimize Kafka when specified. Being present and not null is enough to enable it. It will also enable `kafka.metricsEnabled` by default and configure metrics for cruise control, so no need to configure here (e.g., `kafka.cruiseControl.metricsConfig`). Reference: https://strimzi.io/docs/operators/0.45.0/configuring.html#type-CruiseControlSpec-reference. |
| kafka.entityOperator.template.pod | object | `{}` |  |
| kafka.entityOperator.topicOperator | object | `{}` |  |
| kafka.entityOperator.userOperator | object | `{}` |  |
| kafka.kafkaExporter | object | `{}` | kafkaExporter allows to customize the configuration of the Kafka Exporter. Reference: https://strimzi.io/docs/operators/0.45.0/configuring.html#type-KafkaExporterSpec-reference |
| kafka.labels | object | `{}` |  |
| kafka.listeners[0].name | string | `"plain"` |  |
| kafka.listeners[0].port | int | `9092` |  |
| kafka.listeners[0].tls | bool | `false` |  |
| kafka.listeners[0].type | string | `"internal"` |  |
| kafka.listeners[1].authentication.type | string | `"tls"` |  |
| kafka.listeners[1].name | string | `"tls"` |  |
| kafka.listeners[1].port | int | `9093` |  |
| kafka.listeners[1].tls | bool | `true` |  |
| kafka.listeners[1].type | string | `"internal"` |  |
| kafka.logging | object | `{}` |  |
| kafka.metricsEnabled | bool | `true` | Indicates whether or not to enable the JMX Prometheus Exporter metrics for Kafka. This is enabled by default if `kafka.cruiseControl` is present. |
| kafka.nodeSelector | object | `{}` |  |
| kafka.tolerations | list | `[]` |  |
| kafka.version | string | `"3.9.0"` |  |
| nameOverride | string | `""` | Override for chart name in helm common labels. |
| nodePools.broker.annotations | object | `{}` |  |
| nodePools.broker.enabled | bool | `true` |  |
| nodePools.broker.jvmOptions | object | `{}` |  |
| nodePools.broker.labels | object | `{}` |  |
| nodePools.broker.nameOverride | string | `""` |  |
| nodePools.broker.replicas | int | `3` |  |
| nodePools.broker.resources | object | `{}` |  |
| nodePools.broker.roles[0] | string | `"broker"` |  |
| nodePools.broker.storage.type | string | `"jbod"` |  |
| nodePools.broker.storage.volumes[0].class | string | `"default"` |  |
| nodePools.broker.storage.volumes[0].deleteClaim | bool | `false` |  |
| nodePools.broker.storage.volumes[0].id | int | `0` |  |
| nodePools.broker.storage.volumes[0].size | string | `"1Gi"` |  |
| nodePools.broker.storage.volumes[0].type | string | `"persistent-claim"` |  |
| nodePools.dual-role-pool.annotations | object | `{}` |  |
| nodePools.dual-role-pool.enabled | bool | `false` |  |
| nodePools.dual-role-pool.jvmOptions | object | `{}` |  |
| nodePools.dual-role-pool.labels | object | `{}` |  |
| nodePools.dual-role-pool.nameOverride | string | `""` |  |
| nodePools.dual-role-pool.replicas | int | `3` |  |
| nodePools.dual-role-pool.resources | object | `{}` |  |
| nodePools.dual-role-pool.roles[0] | string | `"controller"` |  |
| nodePools.dual-role-pool.roles[1] | string | `"broker"` |  |
| nodePools.dual-role-pool.storage.type | string | `"jbod"` |  |
| nodePools.dual-role-pool.storage.volumes[0].class | string | `"default"` |  |
| nodePools.dual-role-pool.storage.volumes[0].deleteClaim | bool | `false` |  |
| nodePools.dual-role-pool.storage.volumes[0].id | int | `0` |  |
| nodePools.dual-role-pool.storage.volumes[0].size | string | `"1Gi"` |  |
| nodePools.dual-role-pool.storage.volumes[0].type | string | `"persistent-claim"` |  |
| nodePools.kraft-controller.annotations | object | `{}` |  |
| nodePools.kraft-controller.enabled | bool | `true` |  |
| nodePools.kraft-controller.jvmOptions | object | `{}` |  |
| nodePools.kraft-controller.labels | object | `{}` |  |
| nodePools.kraft-controller.nameOverride | string | `""` |  |
| nodePools.kraft-controller.replicas | int | `3` |  |
| nodePools.kraft-controller.resources | object | `{}` |  |
| nodePools.kraft-controller.roles[0] | string | `"controller"` |  |
| nodePools.kraft-controller.storage.type | string | `"jbod"` |  |
| nodePools.kraft-controller.storage.volumes[0].class | string | `"default"` |  |
| nodePools.kraft-controller.storage.volumes[0].deleteClaim | bool | `false` |  |
| nodePools.kraft-controller.storage.volumes[0].id | int | `0` |  |
| nodePools.kraft-controller.storage.volumes[0].size | string | `"1Gi"` |  |
| nodePools.kraft-controller.storage.volumes[0].type | string | `"persistent-claim"` |  |
| strimzi-drain-cleaner.enabled | bool | `true` | Indicates whether or not to deploy Drain Cleaner with the Kafka cluster. |
| strimzi-drain-cleaner.namespace.create | bool | `true` |  |
| strimzi-drain-cleaner.namespace.name | string | `"strimzi-drain-cleaner"` | name is the name of the namespace where the Drain Cleaner resources will be deployed, but also, it's used for RBAC permissions regardless of the `strimzi-drain-cleaner.namespace.create` state. |
| strimzi-drain-cleaner.replicaCount | int | `1` | replicaCount is for the number of Drain Cleaner instances. |
| strimzi-drain-cleaner.resources | object | `{}` |  |
| strimzi-drain-cleaner.secret.ca_bundle | string | `""` | ca_bundle is the CA certificate bundle in PEM format used for the ValidatingWebhookConfiguration truststore regardless of the `strimzi-drain-cleaner.secret.create` state. |
| strimzi-drain-cleaner.secret.create | bool | `true` |  |
| strimzi-drain-cleaner.secret.tls_crt | string | `""` |  |
| strimzi-drain-cleaner.secret.tls_key | string | `""` |  |
| strimzi-kafka-operator.enabled | bool | `true` | Indicates whether or not to deploy Strimzi with the Kafka cluster. |
| strimzi-kafka-operator.replicas | int | `1` | replicas is for the number of cluster operator instances. |
| strimzi-kafka-operator.resources | object | `{}` |  |


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
