<h1 align="center">Keycloak Stack Helm Chart</h1>

<p align="center">
  <img
    alt="Version: 0.1.0"
    src="https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square"
  />
  <img
    alt="Type: application"
    src="https://img.shields.io/badge/Type-application-informational?style=flat-square"
  />
  <img
    alt="AppVersion: 26.7.1"
    src="https://img.shields.io/badge/AppVersion-26.7.1-informational?style=flat-square"
  />
</p>

<p align="center">
    <a href="#requirements"><b>Requirements</b></a> •
    <a href="#usage-example"><b>Usage</b></a> •
    <a href="#monitoring-with-prometheus-and-grafana"><b>Monitoring</b></a> •
    <a href="#values"><b>Chart Values</b></a>
</p>

<p align="center">
Installs a fully managed Keycloak and its dependencies.
</p>

## Source Code

* <https://github.com/keycloak/keycloak>

## Requirements

Kubernetes: `>= 1.30.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://StevenJDH.github.io/helm-charts | keycloak-operator | 0.1.1 |
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

## Monitoring with Prometheus and Grafana
This section shows how to enable monitoring of the cluster via Prometheus and Grafana, which will also inject dashboards to represent the collected metrics. To get started, run the following commands with configuration from one of the options below.

```bash
helm upgrade --install kube-prometheus-stack oci://ghcr.io/prometheus-community/charts/kube-prometheus-stack --version 87.21.0
    -f prometheus-values.yaml \ # TODO: Check below for one of the options to use for this file.
    --namespace monitoring \
    --create-namespace \
    --atomic
```

> [!IMPORTANT]  
> Make sure to use the latest 3x version of the Helm CLI, and not 4x, or the installation/upgrade will hang.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalOptions | list | `[]` | Additional options to set for the Keycloak server. These should be expressed as key-value pairs that can be either direct values or references to secrets. Use quotes for numbers and boolean values. Do not set `metrics-enabled`, `telemetry-metrics-enabled`, and `http-metrics-histograms-enabled` as these will be added when needed automatically. See [All configuration](https://www.keycloak.org/server/all-config) for details. |
| admin.tlsSecret | string | `""` | tlsSecret specifies the TLS Secret containing the client certificate and private key used by the operator for mTLS connections to Keycloak. See [Managing Keycloak Clients](https://www.keycloak.org/operator/managing-clients) for more information. |
| annotations | object | `{}` | annotations to be added to the Deployment resource. |
| automountServiceAccountToken | bool | `true` | Indicates whether or not to automatically mount the Kubernetes ServiceAccount token into the Keycloak pod. If set to `false`, this will also disable the Kubernetes CA truststore auto-discovery logic. Keep this set to `true` if planning to use an external Infinispan cluster, the Kubernetes ServiceAccount identity provider, or any custom provider logic that expects to implicitly use the Kubernetes API. See [Truststores](https://www.keycloak.org/operator/advanced-configuration#_truststores) for more information. |
| bootstrapAdmin.service.clientId | string | `""` | clientId is the client ID for the Keycloak bootstrap admin service account. |
| bootstrapAdmin.service.clientSecret | string | `""` | clientSecret is the client secret for the Keycloak bootstrap admin service account. |
| bootstrapAdmin.user.password | string | `"admin"` | password is the temporary password for the Keycloak bootstrap admin user. |
| bootstrapAdmin.user.username | string | `"admin"` | username is the temporary username for the Keycloak bootstrap admin user. See [Accessing the Admin Console](https://www.keycloak.org/operator/basic-deployment#_accessing_the_admin_console) for more information. |
| cache.configMapFile | object | `{}` | configMapFile references a ConfigMap key containing a custom Infinispan cache configuration XML. When specified, Keycloak uses this file instead of the default cache configuration. See [Configuring caches](https://www.keycloak.org/server/caching#_configuring_caches) for more information. |
| dashboards.enabled | bool | `false` | Indicates whether or not to deploy a set of Keycloak related Grafana dashboards that will be imported automatically. |
| dashboards.namespace | string | `"monitoring"` | namespace is the namespace where the Grafana dashboards will be deployed. This should be the same namespace as the Prometheus Operator and Grafana instance. |
| db.external.auth.password | string | `""` | password is the password for the external database user. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.auth.username | string | `""` | username is the username for the external database user. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.database | string | `"keycloak"` | database is the name of the external database to use for Keycloak. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.host | string | `""` | host is the hostname of the external database server. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.port | int | `5432` | port is the port number of the external database server. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.schema | string | `"public"` | schema is the name of the external database schema to use for Keycloak. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.vendor | string | `"postgres"` | vendor is the external database vendor to use for Keycloak. Supported values are: postgres, mariadb, mysql, oracle, mssql, etc. This setting is ignored if `postgresql.enabled` is `true`. See [Supported databases](https://www.keycloak.org/server/db#_supported_databases) and [Preparing for PostgreSQL](https://www.keycloak.org/server/db#_preparing_for_postgresql) for more information. |
| db.hostOverride | string | `""` | hostOverride is the hostname of the database server. If not set, it will be auto configured for the postgresql headless service of the managed database. This setting is ignored if `postgresql.enabled` is `false`. |
| db.poolInitialSize | int | `1` | poolInitialSize is the initial number of connections that are created when the pool is started. |
| db.poolMaxSize | int | `30` | poolMaxSize is the maximum number of connections that can be allocated from the pool at a given time. |
| db.poolMinSize | int | `2` | poolMinSize is the minimum number of connections that are maintained in the pool. |
| db.port | int | `5432` | port is the port number of the database server. This setting is ignored if `postgresql.enabled` is `false`. |
| db.schema | string | `"public"` | schema is the name of the database schema to use for Keycloak. This setting is ignored if `postgresql.enabled` is `false`. |
| db.vendor | string | `"postgres"` | vendor is the database vendor to use for Keycloak. Supported values are: postgres, mariadb, mysql, oracle, mssql, etc. This setting is ignored if `postgresql.enabled` is `false`. See [Supported databases](https://www.keycloak.org/server/db#_supported_databases) for more information. |
| devModeEnabled | bool | `false` | Indicates whether or not Keycloak is running in development mode. This will disable features and configurations that are only suitable for development environments. |
| extraEnvs | list | `[]` | Additional environment variables to set for the Keycloak server. These should be expressed as key-value pairs that can be either direct values or references to secrets.. Use the `additionalOptions` section for first-class options rather than KC_ values here. |
| features.disabled | list | `[]` | disabled is used to disable Keycloak features. See [Feature](https://www.keycloak.org/server/all-config#category-feature) for more information. |
| features.enabled | list | `[]` | enabled is used to enable Keycloak features. See [Feature](https://www.keycloak.org/server/all-config#category-feature) for more information. |
| fullnameOverride | string | `""` | Override for generated resource names. |
| hostname.adminHost | string | `""` | adminHost is the hostname for the Admin Console and Admin REST API. If unset, the value of `hostname.host` is used. Applicable for Hostname v1 and v2. See [Exposing the Administration Console on a separate hostname](https://www.keycloak.org/server/hostname#administration-console-on-a-separate-hostname) for more information. |
| hostname.backchannelDynamic | bool | `false` | Indicates whether or not to enable dynamic backchannel URLs, allowing internal clients to access Keycloak through a different address than external clients. Applicable for Hostname v2. See [Utilizing an internal URL for communication among clients](https://www.keycloak.org/server/hostname#_utilizing_an_internal_url_for_communication_among_clients) for more information. |
| hostname.host | string | `"keycloak.127.0.0.1.sslip.io"` | host is the hostname for the Keycloak server. Applicable for Hostname v1 and v2. |
| hostname.strict | bool | `true` | strict indicates whether the hostname should be treated as strict. This dynamically resolves the hostname from request headers. Applicable for Hostname v1 and v2. Disabled when `devModeEnabled` is set to `true` |
| http.annotations | object | `{}` | annotations to be added to the Service resource. |
| http.httpEnabled | bool | `false` | Indicates whether or not the HTTP listener is enabled, which is blocked by default. This setting is always `true` when `devModeEnabled` is `true`. |
| http.httpPort | int | `8080` | httpPort is the port used for HTTP connections. |
| http.httpsPort | int | `8443` | httpsPort is the port used for HTTPS connections. |
| http.labels | object | `{}` | labels to be added to the Service resource. |
| http.serviceHttpPort | int | `0` | serviceHttpPort is the HTTP port exposed on the Kubernetes Service. When set, the Service will use this port while the pod still listens on `http.httpPort`. This setting is ignored when set to `0`. |
| http.serviceHttpsPort | int | `0` | serviceHttpsPort is the HTTPS port exposed on the Kubernetes Service. When set, the Service will use this port while the pod still listens on `http.httpsPort`. This setting is ignored when set to `0`. |
| http.serviceName | string | `""` | serviceName is used to override the default Service resource name. When not set, the name defaults to the Keycloak CR name with a "-service" suffix. |
| http.tlsSecret | string | `""` | tlsSecret is a secret containing the TLS configuration for the Passthrough TLS scenario. Requires `ingress.enabled` set to `true` and `ingress.tlsSecret` must be unset. See [TLS Termination with default Ingress](https://www.keycloak.org/operator/basic-deployment#_tls_termination_with_default_ingress) for more information. |
| httpManagement.port | int | `9000` | port is the port of the management interface. |
| image | string | `""` | image is used to specify a custom Keycloak image to be used. |
| imagePullSecrets | list | `[]` | imagePullSecrets is a list of secrets for pulling an image from a private container registry. |
| import.scheduling | object | `{}` | scheduling is used to configure Kubernetes affinity, tolerations, topology spread constraints, and the priority class name to fine tune the scheduling and placement of Pods. |
| ingress.annotations | object | `{}` | annotations to be added to the Ingress resource. |
| ingress.className | string | `""` | className is the name of the Ingress class. |
| ingress.enabled | bool | `true` | Indicates whether or not an Ingress resource is created to enable outside access. See [TLS Termination with default Ingress](https://www.keycloak.org/operator/basic-deployment#_tls_termination_with_default_ingress) for more information. |
| ingress.labels | object | `{}` | labels to be added to the Ingress resource. |
| ingress.tlsSecret | string | `""` | tlsSecret is a secret containing the TLS configuration for re-encrypt or TLS termination scenarios. See [TLS Secrets](https://kubernetes.io/docs/concepts/configuration/secret/#tls-secrets) for more information. |
| instances | int | `1` | instances is the number of Keycloak instances created to increase availability when set to more than one. |
| keycloak-operator.enabled | bool | `true` | Indicates whether or not the Keycloak Operator is installed. |
| keycloak-&#8203;operator.&#8203;watchAllNamespacesFor.&#8203;keycloak | bool | `false` | keycloak is for indicating whether or not Keycloak resources will be watched in all namespaces. |
| keycloak-&#8203;operator.&#8203;watchAllNamespacesFor.&#8203;keycloakOIDCClient | bool | `false` | keycloakOIDCClient is for indicating whether or not KeycloakOIDCClient resources will be watched in all namespaces. |
| keycloak-&#8203;operator.&#8203;watchAllNamespacesFor.&#8203;keycloakRealmImport | bool | `false` | keycloakRealmImport is for indicating whether or not KeycloakRealmImport resources will be watched in all namespaces. |
| keycloak-&#8203;operator.&#8203;watchAllNamespacesFor.&#8203;keycloakSAMLClient | bool | `false` | keycloakSAMLClient is for indicating whether or not KeycloakSAMLClient resources will be watched in all namespaces. |
| keycloakRealmImport.enabled | bool | `false` | Indicates whether or not to import a realm backup or configuration. |
| keycloakRealmImport.labels | object | `{}` | labels to be added to the Job created for the import. |
| keycloakRealmImport.placeholders | object | `{}` | placeholders is used to replace ENV variable placeholders in the realm import. For example, if 'realm' property has ${REALM_NAME}, then 'REALM_NAME: production' will perform a substitution. |
| keycloakRealmImport.realm | object | `{}` | realm allows for defining the realm configuration inline. The structure is the same as any realm backup converted to YAML. This setting cannot be used when `keycloakRealmImport.realmContent` is defined. |
| keycloakRealmImport.realmContent | string | `""` | realmContent contains a realm backup provided as raw `JSON` or `YAML` content. This is primarily intended for use with Helm's `--set-file` option, but supports inline when using a pipe. However, please use the dedicate inline property `keycloakRealmImport.realm` if inline is needed. The format must match `keycloakRealmImport.realmContentFormat`. This setting cannot be used when `keycloakRealmImport.realm` is defined. |
| keycloakRealmImport.realmContentFormat | string | `"json"` | realmContentFormat specifies the format of the content provided via `keycloakRealmImport.realmContent`. Supported values are `json` and `yaml`. This setting is ignored unless `keycloakRealmImport.realmContent` is defined. |
| keycloakRealmImport.resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the import job needs. If no resources are configured, the values from the Keycloak resource, or their defaults, will be used. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| livenessProbe | object | `{}` | livenessProbe configures the liveness probe. This type of probe does not wait for the readiness probe to succeed. To make the the probe wait, use the `startupProbe`. Only a subnet of features are support by the CR. |
| metrics.enabled | bool | `false` | Indicates whether or not Keycloak metrics should be enabled. Before enabling this, make sure `serviceMonitor.enabled` is set `false`, otherwise, a ServiceMonitor resource will also be created. This will also enabled the `http-metrics-histograms-enabled` option. |
| nameOverride | string | `""` | Override for chart name in helm common labels. |
| networkPolicy.enabled | bool | `true` | Specifies whether a network policy should be created. By default, the operator automatically creates a NetworkPolicy resource to deny access to the clustering port of the Keycloak Pods. The HTTP(S) endpoint is open to traffic from any namespace and the outside world. Note: This will have no effect unless the chosen CNI supports network policies like Calico, Weave, Cilium, Romana, etc. |
| networkPolicy.http | list | `[]` | http is a list of source rules which should be able to access this endpoint (port 8080 by default). Items in this list are combined using a logical OR operation. If this field is empty or missing, this rule matches all sources (traffic not restricted by source). If this field is present and contains at least one item, this rule allows traffic only if the traffic matches at least one item in the from list. Due to security reasons, the HTTP endpoint is disabled by default, unless `devModeEnabled` is set to `true`. Reference [Behavior of to and from selectors](https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors). |
| networkPolicy.https | list | `[]` | https is a list of source rules which should be able to access this endpoint (port 8443 by default). Items in this list are combined using a logical OR operation. If this field is empty or missing, this rule matches all sources (traffic not restricted by source). If this field is present and contains at least one item, this rule allows traffic only if the traffic matches at least one item in the from list. Reference [Behavior of to and from selectors](https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors). |
| networkPolicy.management | list | `[]` | management is a list of source rules which should be able to access this endpoint (port 9000 by default). Items in this list are combined using a logical OR operation. If this field is empty or missing, this rule matches all sources (traffic not restricted by source). If this field is present and contains at least one item, this rule allows traffic only if the traffic matches at least one item in the from list. Reference [Behavior of to and from selectors](https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors). |
| podTemplate | object | `{}` | podTemplate is a raw API representation that is used for the Deployment Template. This field is a temporary workaround in case no supported field exists at the top level of the CR for a use case. However, no guarantee exists that the Deployment will work as expected. |
| postgresql.auth.database | string | `"keycloak"` | database is the name of the database to use for Keycloak. |
| postgresql.auth.password | string | `""` | password is the password for the database user. If unset, a random password is generated and stored in a secret. |
| postgresql.auth.username | string | `"postgres"` | username is the username for the database user. |
| postgresql.enabled | bool | `true` | Indicates whether or not a PostgreSQL database is created. |
| proxy.headers | string | `""` | headers are the proxy headers that should be accepted by the server. Misconfiguration might leave the server exposed to security vulnerabilities. Check the load balancer or reverse proxy configuration in use to determine whether it utilizes the Forwarded (RFC 7239) or X-Forwarded-* (e.g., X-Forwarded-For) mechanism for header propagation. Use with Edge and Re-encrypt scenarios, but not Passthrough. Valid values are `forwarded` and `xforwarded`. See [Configuring a reverse proxy](https://www.keycloak.org/server/reverseproxy) for more information. |
| readinessProbe | object | `{}` | readinessProbe configures the readiness probe. Only a subnet of features are support by the CR. |
| resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. When using a KeycloakRealmImport resource, if no resources are configured there, these values here, or their defaults, will be used. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| scheduling | object | `{}` | scheduling is used to configure Kubernetes affinity, tolerations, topology spread constraints, and the priority class name to fine tune the scheduling and placement of Pods. |
| secrets | object | `{}` | secrets is used to store confidential data in key-value pairs. Can be used by other properties such as `additionalOptions` that can reference keys without having to provide a pre-existing secret resource. |
| serviceMonitor.annotations | object | `{}` | annotations specifies additional annotations for the ServiceMonitor. |
| serviceMonitor.enabled | bool | `false` | Indicates whether or not to create a ServiceMonitor for Keycloak. Requires that `metrics.enabled` be set to `true`. |
| serviceMonitor.interval | string | `"30s"` | interval is the frequency at which metrics should be scraped. |
| serviceMonitor.labels | object | `{}` | labels specifies additional labels for the ServiceMonitor. |
| serviceMonitor.scrapeTimeout | string | `"10s"` | scrapeTimeout sets the scrape timeout for the ServiceMonitor. |
| startOptimized | bool | `false` | Indicates whether or not to start Keycloak in optimized mode with the `--optimized` flag when using custom pre-augmented images. Keep disabled when using non-optimized images or the official Keycloak image. When using an optimized custom image, `health-enabled`, `metrics-enabled` and `telemetry-metrics-enabled` options need to be explicitly set in the Dockerfile. Any build time options passed through first-class fields or `additionalOptions` will be ignored if not moved to the Dockerfile. See [Best practice](https://www.keycloak.org/operator/customizing-keycloak#_best_practice) for more information. |
| startupProbe | object | `{}` | startupProbe configures the startup probe. Only a subnet of features are support by the CR. |
| telemetry.enabled | bool | `false` | Indicates whether or not to enable OpenTelemetry metrics. Requires `metrics.enabled` to be `true`, and `features` to include `opentelemetry-metrics:v1`. |
| telemetry.endpoint | string | `"http://otel-collector:4317"` | endpoint is the OpenTelemetry endpoint to connect to. |
| telemetry.resourceAttributes | object | `{}` | resourceAttributes is the OpenTelemetry resource attributes present in the exported telemetry data to characterize the telemetry producer. |
| telemetry.serviceName | string | `""` | serviceName is the OpenTelemetry service name. Takes precedence over 'service.name' defined in `telemetry.resourceAttributes`. |
| tracing.compression | string | `"none"` | compression is the OpenTelemetry method used to compress payloads. Possible values are: gzip, none. |
| tracing.enabled | bool | `false` | Indicates whether or not to enable OpenTelemetry tracing. Requires `metrics.enabled` to be `true`. |
| tracing.endpoint | string | `"http://otel-collector:4317"` | endpoint is the OpenTelemetry endpoint to connect to. |
| tracing.protocol | string | `"grpc"` | protocol is the OpenTelemetry protocol used for the transmitting the data. |
| tracing.samplerRatio | float | `0.1` | samplerRatio is the OpenTelemetry sampler ratio. Probability that a span will be sampled using a double type value. For example, 1.0 is equal to 100%. |
| tracing.samplerType | string | `"traceidratio"` | samplerType is the OpenTelemetry sampler to use for tracing. |
| transaction.xaEnabled | bool | `false` | Indicates whether or not Keycloak should use a non-XA datasource in case the database does not support XA transactions. If supported, then this option can be enabled. See [Using Database Vendors with XA transaction support](https://www.keycloak.org/server/db#_using_database_vendors_with_xa_transaction_support) for more information. |
| truststores | object | `{}` | truststores is used to configure the Keycloak truststores using Secrets or ConfigMaps containing PEM encoded files, or PKCS12 files with extension .p12, .pfx, or .pkcs12. See [Truststores](https://www.keycloak.org/operator/advanced-configuration#_truststores) for more information. |
| update.labels | object | `{}` | labels is for setting additional labels on the Job created for the update. |
| update.revision | string | `"example-v1"` | revision is used for when `update.strategy` is set to `Explicit` strategy, and is ignored for other strategies. The Keycloak Operator checks this value, and if it matches the previous deployment, it performs a rolling update. See [Configuring the Update Strategy](https://www.keycloak.org/operator/rolling-updates#_configuring_the_update_strategy) for more information. |
| update.scheduling | object | `{}` | scheduling is used to configure Kubernetes affinity, tolerations, topology spread constraints, and the priority class name to fine tune the scheduling and placement of Pods. |
| update.strategy | string | `"RecreateOnImageChange"` | strategy is the update strategy to use for updates. Valid values are `RecreateOnImageChange`, `Auto`, and `Explicit`. See [Configuring the Update Strategy](https://www.keycloak.org/operator/rolling-updates#_configuring_the_update_strategy) for more information. |


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
