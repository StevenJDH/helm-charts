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
    <a href="#keycloak-operator-crd-references"><b>CRDs</b></a> •
    <a href="#creating-server-certificates-for-tls-scenarios"><b>TLS Scenarios</b></a> •
    <a href="#creating-client-certificates-for-mtls"><b>mTLS</b></a> •
    <a href="#monitoring-with-prometheus-and-grafana"><b>Monitoring</b></a> •
    <a href="#values"><b>Chart Values</b></a>
</p>

<p align="center">
Installs a fully managed Keycloak with its dependencies and support for declarative resources.
</p>

## Source Code

* <https://github.com/keycloak/keycloak>

## Requirements

Kubernetes: `>= 1.30.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://StevenJDH.github.io/helm-charts | keycloak-operator | 0.1.1 |
| https://StevenJDH.github.io/helm-charts | shared-library | ^0.x |
| oci://registry-1.docker.io/bitnamicharts | postgresql | 18.8.9 |

## Usage example

```bash
helm repo add stevenjdh https://StevenJDH.github.io/helm-charts
helm repo update
helm upgrade --install my-keycloak-stack stevenjdh/keycloak-stack --version 0.1.0 \
    --set devModeEnabled=true \
    --set hostname.host=keycloak.127.0.0.1.sslip.io \
    --set bootstrapAdmin.user.username=admin \
    --set bootstrapAdmin.user.password=admin \
    --set bootstrapAdmin.service.clientId=operator \
    --set bootstrapAdmin.service.clientSecret=operator \
    --namespace example \
    --create-namespace \
    --atomic
```

## Keycloak Operator CRD references
Currently, there isn't an official reference source containing all the properties supported by resources such as `KeycloakOIDCClient`, `KeycloakSAMLClient`, and `KeycloakRealmImport`. However, I've provided these [Generated CRD References](https://github.com/StevenJDH/helm-charts/tree/keycloak-operator-0.1.1/charts/keycloak-operator/docs/crds), which are generated directly from the CRD definitions and can be used as a reference when configuring these resources.

## Creating server certificates for TLS scenarios
This section provides the steps for creating the CA and server certificates needed for the different TLS scenarios supported by Keycloak. These scenarios include:

* [Passthrough](https://www.keycloak.org/operator/basic-deployment#passthrough)
* [Ingress Terminated/Edge](https://www.keycloak.org/operator/basic-deployment#_edge)
* [Reencrypt](https://www.keycloak.org/operator/basic-deployment#_reencrypt)
* [Custom Access](https://www.keycloak.org/operator/basic-deployment#_custom_access)

The below steps for creating self-signed certificates is meant for feature testing only. For production environments, certificates should be issued by a trusted public certificate authority or an internal one. OpenSSL CLI v1.1.1 or newer is required.

1. In a shell console, set the hostname used by Keycloak. Use `set hostname` if using Windows.

    ```bash
    hostname=keycloak.127.0.0.1.sslip.io
    ```

2. Create CA certificate and key.

    ```bash
    openssl req -x509 -sha256 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 11688 -noenc \
        -subj "/CN=Keycloak Stack Root CA/O=StevenJDH" \
        -addext "basicConstraints=critical,CA:TRUE,pathlen:1" \
        -addext "keyUsage=critical,keyCertSign,cRLSign" \
        -addext "subjectKeyIdentifier=hash"
    ```

3. Create certificate signing request (*.csr) and private key. Change `$hostname` to `%hostname%` if using Windows.

    ```bash
    openssl req -new -newkey rsa:4096 -keyout tls.key -out tls.csr -noenc \
        -subj "/CN=$hostname/O=StevenJDH" \
        -addext "basicConstraints=critical,CA:FALSE" \
        -addext "extendedKeyUsage=serverAuth" \
        -addext "keyUsage=critical,digitalSignature,keyEncipherment" \
        -addext "subjectAltName=DNS:$hostname" \
        -addext "nsComment=Keycloak Stack Test Server Certificate" \
        -addext "subjectKeyIdentifier=hash"
    ```

4. Create CA signed server certificate from CSR.

    ```bash
    openssl x509 -req -sha256 -days 11688 -in tls.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out tls.crt \
        -copy_extensions copy
    ```

5. Append the CA certificate to the server certificate to have the full chain. Use `type` instead of `cat` if using Windows.

    ```bash
    cat ca.crt >> tls.crt
    ```

6. Finally, apply the `tls.crt` and `tls.key` key-pair to Keycloak using one of the [TLS example configurations](./examples). Accept the browser warning for the untrusted self-signed certificate to view the Keycloak Admin Console. Third-party client applications can optionally use the following command to create the needed truststore to trust the server certificate:

    ```bash
    openssl pkcs12 -export -nokeys -in ca.crt -passout pass:changeit -out truststore.p12

    # For Java-based technologies, use this command instead. Both commands produce a truststore in the same
    # format, however, this one adds the required '2.16.840.1.113894.746875.1.1' Bag Attribute, which is used
    # for detecting trusted cert entries. If the above command is used with a Java app or keytool -list, the
    # entries will be 0. In the next section, the VERIFY CONTAINER STRUCTURE command can show this distinction.
    #
    # NOTE: openssl v3.2.0 now supports adding '-jdktrust anyExtendedKeyUsage' to solve this problem. Just
    # remove the -nokeys flag as it is implicitly added. Downside is the java specific 'friendlyName' Bag
    # Attribute still isn't added even in 4x versions of the CLI, so using keytool for truststores is preferred.
    keytool -importcert -alias keycloak-stack-ca -file ca.crt -keystore truststore.p12 -storetype PKCS12 \
        -storepass changeit \
        -noprompt
    ```

### Additional server-based openssl commands
Optionally, there may be a need to inspect details about a certificate's relation to a particular CA, or how it was configured. This is useful for troubleshooting issues that could affect their use. As such, use any of the following commands to analyze these points of interest.

📚 <ins>**CHECKS IF ISSUED BY THE CA**</ins>

```bash
openssl verify -CAfile ca.crt -purpose sslserver tls.crt
```

🔳 **Output**

```bash
tls.crt: OK
```

📚 <ins>**INSPECT SERVER CERTIFICATE DETAILS**</ins>

```bash
openssl x509 -in tls.crt -noout -subject -issuer \
    -ext basicConstraints,keyUsage,extendedKeyUsage,subjectAltName,nsComment
```

🔳 **Output**

```bash
subject=CN = keycloak.127.0.0.1.sslip.io, O = StevenJDH
issuer=CN = Keycloak Stack Root CA, O = StevenJDH
X509v3 Basic Constraints: critical
    CA:FALSE
X509v3 Extended Key Usage:
    TLS Web Server Authentication
X509v3 Key Usage: critical
    Digital Signature, Key Encipherment
X509v3 Subject Alternative Name:
    DNS:keycloak.127.0.0.1.sslip.io
Netscape Comment:
    Keycloak Stack Test Server Certificate
```

## Creating client certificates for mTLS
This section shows how to create a client certificate for mTLS communication. For the CA, reuse the one from the previous section or create a dedicated one for the client chain using Step 2 in that section. OpenSSL CLI v1.1.1 or newer is required.

1. Create certificate signing request (*.csr) and private key.

    ```bash
    openssl req -new -newkey rsa:4096 -keyout client.key -out client.csr -noenc \
        -subj "/CN=Trusted Client/O=StevenJDH" \
        -addext "basicConstraints=critical,CA:FALSE" \
        -addext "extendedKeyUsage=clientAuth" \
        -addext "keyUsage=critical,digitalSignature" \
        -addext "nsComment=Keycloak Stack Operator Test Client Certificate" \
        -addext "subjectKeyIdentifier=hash"
    ```

2. Create CA signed client certificate from CSR.

    ```bash
    openssl x509 -req -sha256 -days 11688 -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt \
        -copy_extensions copy
    ```

3. Apply the `client.crt` and `client.key` key-pair to Keycloak using the [mTLS example configuration](./examples/mtls-protected-admin-api.yaml). That example shows how to configure the Keycloak Operator with a client certificate to access the Admin API. Third-party client applications can optionally use the following command to create the needed keystore to properly authenticate themselves with the server:

    ```bash
    openssl pkcs12 -export -name client -in client.crt -inkey client.key -certfile ca.crt \
      -passout pass:changeit -out client-keystore.p12

    # OR

    # For certs with intermediary certs, use this one. Use 'type' instead of 'cat' on Window.
    # Structure: Key -> Child -> Parent.
    cat client.key client.crt intermediary.crt ca.crt > client-chain.pem
    openssl pkcs12 -export -name client -in client-chain.pem -passout pass:changeit -out client-keystore.p12
    ```

### Additional client-based openssl commands
Similar to the previous section for server certificates, the following are a few more commands for troubleshooting client certificates. However, some of the before mentioned commands are also still valid here but excluded for brevity.

📚 <ins>**INSPECT CLIENT CERTIFICATE DETAILS**</ins>

```bash
openssl x509 -in client.crt -noout -subject -issuer \
    -ext basicConstraints,keyUsage,extendedKeyUsage,nsComment
```

🔳 **Output**

```bash
subject=CN = Trusted Client, O = StevenJDH
issuer=CN = Keycloak Stack Root CA, O = StevenJDH
X509v3 Basic Constraints: critical
    CA:FALSE
X509v3 Extended Key Usage:
    TLS Web Client Authentication
X509v3 Key Usage: critical
    Digital Signature
Netscape Comment:
    Keycloak Stack Test Client Certificate
```

📚 <ins>**TEST MTLS HANDSHAKE**</ins>

```bash
# No error at bottom of output is good. However, you may need to set mTLS to 'required' to force a problem.
openssl s_client -brief -connect keycloak.127.0.0.1.sslip.io:443 \
    -servername keycloak.127.0.0.1.sslip.io
    -CAfile ca.crt -cert client.crt -key client.key
```

🔳 **Output**

```bash
CONNECTION ESTABLISHED
Protocol version: TLSv1.3
Ciphersuite: TLS_AES_256_GCM_SHA384
Requested Signature Algorithms: ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:Ed25519:Ed448:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512
Peer certificate: CN = keycloak.127.0.0.1.sslip.io, O = StevenJDH
Hash used: SHA256
Signature type: RSA-PSS
Verification: OK
Server Temp Key: X25519, 253 bits
```

📚 <ins>**VERIFY CONTAINER STRUCTURE**</ins>

```bash
openssl pkcs12 -info -in client-keystore.p12 -passin pass:changeit -noout

# Alternatively, this command will show the certs, keys, and metadata.
openssl pkcs12 -info -in client-keystore.p12 -passin pass:changeit -nodes
```

🔳 **Output**

```bash
MAC: sha256, Iteration 2048
MAC length: 32, salt length: 8
PKCS7 Encrypted data: PBES2, PBKDF2, AES-256-CBC, Iteration 2048, PRF hmacWithSHA256
Certificate bag
Certificate bag
PKCS7 Data
Shrouded Keybag: PBES2, PBKDF2, AES-256-CBC, Iteration 2048, PRF hmacWithSHA256
```

## Monitoring with Prometheus and Grafana
This section shows how to enable monitoring of a Keycloak cluster via Prometheus and Grafana, which will also inject dashboards to represent the collected metrics. To get started, run the following commands with configuration from one of the options below.

```bash
helm upgrade --install kube-prometheus-stack oci://ghcr.io/prometheus-community/charts/kube-prometheus-stack --version 87.21.0
    -f prometheus-values.yaml \ # TODO: Check below for one of the options to use for this file.
    --namespace monitoring \
    --create-namespace \
    --atomic
```

> [!IMPORTANT]  
> Make sure to use the latest 3x version of the Helm CLI, and not 4x, or the installation/upgrade will hang.

<table>
  <tr>
    <td align="center">
      <img src="screenshots/Keycloak troubleshooting 0 - Dashboards - Grafana.png" width="260"
        title="Troubleshooting Dashboard - SLO Metrics" alt="Troubleshooting Dashboard - SLO Metrics"
      /><br>
      <b>Troubleshooting Dashboard - SLO Metrics</b><br>
      Service Level Objectives metrics.
    </td>
      <td align="center">
      <img src="screenshots/Keycloak troubleshooting 1 - Dashboards - Grafana.png" width="260"
        title="Troubleshooting Dashboard - JVM Metrics" alt="Troubleshooting Dashboard - JVM Metrics"
      /><br>
      <b>Troubleshooting Dashboard - JVM Metrics</b><br>
      JVM memory metrics.
    </td>
    <td align="center">
      <img src="screenshots/Keycloak troubleshooting 3 - Dashboards - Grafana.png" width="260"
        title="Troubleshooting Dashboard - HTTP Metrics" alt="Troubleshooting Dashboard - HTTP Metrics"
      /><br>
      <b>Troubleshooting Dashboard - HTTP Metrics</b><br>
      HTTP performance insights.
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="screenshots/Keycloak troubleshooting 4 - Dashboards - Grafana.png" width="260"
        title="Troubleshooting Dashboard - Sections" alt="Troubleshooting Dashboard - Sections"
      /><br>
      <b>Troubleshooting Dashboard - Sections</b><br>
      Categorized operational data.
    </td>
    <td align="center">
      <img src="screenshots/Keycloak capacity planning 0 - Dashboards - Grafana.png" width="260"
        title="Capacity Planning Dashboard" alt="Capacity Planning Dashboard"
      /><br>
      <b>Capacity Planning Dashboard</b><br>
      Performance capacity metrics.
    </td>
    <td align="center">
      <a href="./screenshots/">More...</a>
    </td>
  </tr>
</table>

### Option 1 - Using ServiceMonitor (Recommended)
This recommended approach will automatically detect and directly collect metrics from Keycloak related services. In general, the below configurations are the defaults, which only require that a ServiceMonitor in any namespace have the label `release: kube-prometheus-stack` to be detected.

**prometheus-values.yaml**

```yaml
grafana:
  defaultDashboardsEnabled: false
  adminUser: admin
  # Change adminPassword as needed.
  adminPassword: admin

prometheus:
  prometheusSpec:
    # Disabling this adds better support for third-party ServiceMonitor resource detection
    # across namespaces without having to deal with label filtering or compromising the
    # default discovery. When enabled, an empty 'serviceMonitorSelector' is replaced with a
    # label selector matching 'release: kube-prometheus-stack', which must be present on
    # ServiceMonitor resources to be detected. To get the release name if the chart is already
    # installed, use 'helm list -n monitoring' or the namespace used.
    #
    # DEPRECATED. Use 'matchLabels: null' in 'serviceMonitorSelector' for equivalent behavior
    # when set to false.
    #
    # Reference:
    # https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/UPGRADE.md#from-62x-to-63x
    serviceMonitorSelectorNilUsesHelmValues: true

    # ServiceMonitors to be selected for target discovery. If {}, and above is 'false', select
    # all ServiceMonitors. For the new approach, set 'matchLabels' to 'null' for equivalent
    # behavior to the deprecated 'serviceMonitorSelectorNilUsesHelmValues' property when set
    # to 'false' for all namespaces.
    serviceMonitorSelector: {}
      # matchLabels:
      #   prometheus: main
      
    # Namespaces matching labels to be selected for ServiceMonitor discovery. If {},
    # then it selects all namespaces. Useful for when wanting to keep resources
    # together with the app instead of grouped together in a monitoring namespace.
    serviceMonitorNamespaceSelector: {}
      # matchLabels:
      #   monitoring: prometheus
 
crds:
  upgradeJob:
    enabled: true
    forceConflicts: false
```

After the kube-prometheus-stack chart has been deployed, or updated with the config above, set `metrics.enabled`, `serviceMonitor.enabled`, and `dashboards.enabled` to `true` in the keycloak-stack chart. Review what `additionalOptions` to set for the dashboards using the [dev-mode example](./examples/dev-mode.yaml) so that the correct metrics are exposed.

### Option 2 - Static Config
This option replicates the behavior of Option 1 without relying on ServiceMonitor CRs. Remove the `namespaces` section from `kubernetes_sd_configs` to support all namespaces.

**prometheus-values.yaml**

```yaml
grafana:
  defaultDashboardsEnabled: false
  # Change adminPassword as needed.
  adminUser: admin  
  adminPassword: admin

prometheus:
  prometheusSpec:
    additionalScrapeConfigs:
    - job_name: keycloak-service
      honor_timestamps: true
      scrape_interval: 30s
      scrape_timeout: 10s
      metrics_path: /metrics
      scheme: http
      follow_redirects: true
      enable_http2: true
      kubernetes_sd_configs:
      - role: pod
        namespaces:
          names:
            - keycloak
      relabel_configs:
      - source_labels: [__meta_kubernetes_pod_label_app]
        action: keep
        regex: keycloak
      - source_labels: [__meta_kubernetes_namespace]
        target_label: namespace
      - source_labels: [__meta_kubernetes_pod_name]
        target_label: pod
      - source_labels: [__meta_kubernetes_pod_container_name]
        target_label: container
      - source_labels: [__meta_kubernetes_pod_container_port_name]
        action: keep
        regex: management
      - target_label: endpoint
        replacement: management
      - source_labels: [__meta_kubernetes_pod_label_app_kubernetes_io_instance]
        regex: (.+)
        target_label: service
        replacement: ${1}-service

crds:
  upgradeJob:
    enabled: true
    forceConflicts: false
```

> [!NOTE]  
> The name of the job must be either `keycloak-metrics` or `keycloak-service` as this is hardcoded in the dashboards for some of the queries.

After the kube-prometheus-stack chart has been deployed or updated with the config above, set `metrics.enabled` and `dashboards.enabled` to `true` in the keycloak-stack chart. Review what `additionalOptions` to set for the dashboards using the [dev-mode example](./examples/dev-mode.yaml) so that the correct metrics are exposed.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalOptions | list | `[]` | Additional options to set for the Keycloak server. These should be expressed as key-value pairs that can be either direct values or references to secrets. Use quotes for numbers and boolean values. Do not set `metrics-enabled`, `http-metrics-histograms-enabled`, `cache-metrics-histograms-enabled`, `event-metrics-user-enabled`, or `telemetry-metrics-enabled` as these will be added automatically when needed. See [All configuration](https://www.keycloak.org/server/all-config) for details. |
| admin.operatorSecret.clientId | string | `""` | clientId is the client ID for the main admin service account used by the Keycloak Operator for managing `KeycloakOIDCClient` and `KeycloakSAMLClient` resources in any realm. When unset, it uses `bootstrapAdmin.service.clientId` if set. For initial deployments, configure the fallback property instead as it will create the needed service account with `admin` role. After, a different service account can be created and configured here if desired, since this will create the required `<keycloak-cr-name>-admin` secret needed by the operator. |
| admin.operatorSecret.clientSecret | string | `""` | clientSecret is the client secret for the main admin service account used by the Keycloak Operator for managing `KeycloakOIDCClient` and `KeycloakSAMLClient` resources in any realm. When unset, it uses `bootstrapAdmin.service.clientSecret` if set. For initial deployments, configure the fallback property instead as it will create the needed service account with `admin` role. After, a different service account can be created and configured here if desired, since this will create the required `<keycloak-cr-name>-admin` secret needed by the operator. |
| admin.tls.certContent | string | `""` | certContent specifies PEM-encoded client certificate used to create a TLS Secret when `admin.tlsSecret` is not specified. This property is primarily intended for use with Helm's `--set-file` option, but supports inline when using a pipe. Ignored if `admin.tlsSecret` is set. |
| admin.tls.keyContent | string | `""` | keyContent specifies PEM-encoded client private key used to create a TLS Secret when `admin.tlsSecret` is not specified. This property is primarily intended for use with Helm's `--set-file` option, but supports inline when using a pipe. Ignored if `admin.tlsSecret` is set. |
| admin.tlsSecret | string | `""` | tlsSecret specifies an existing TLS Secret containing the client certificate and private key used by the operator for mTLS connections to Keycloak. Requires setting `http.tlsSecret` or `http.tls.certContent` and `http.tls.keyContent` to enable TLS passthrough. See [Managing Keycloak Clients](https://www.keycloak.org/operator/managing-clients) for more information. |
| annotations | object | `{}` | annotations to be added to the Keycloak resource. |
| automountServiceAccountToken | bool | `true` | Indicates whether or not to automatically mount the Kubernetes ServiceAccount token into the Keycloak pod. If set to `false`, this will also disable the Kubernetes CA truststore auto-discovery logic. Keep this set to `true` if planning to use an external Infinispan cluster, the Kubernetes ServiceAccount identity provider, or any custom provider logic that expects to implicitly use the Kubernetes API. See [Truststores](https://www.keycloak.org/operator/advanced-configuration#_truststores) for more information. |
| bootstrapAdmin.service.clientId | string | `""` | clientId is the temporary client ID for the Keycloak bootstrap admin service account with an admin role. This is used to support creating and managing `KeycloakOIDCClient` and `KeycloakSAMLClient` clients in any realm. Later, this value can be managed via the `admin.operatorSecret.clientId` property. |
| bootstrapAdmin.service.clientSecret | string | `""` | clientSecret is the temporary client secret for the Keycloak bootstrap admin service account with an admin role. This is used to support creating and managing `KeycloakOIDCClient` and `KeycloakSAMLClient` clients in any realm. Later, this value can be managed via the `admin.operatorSecret.clientSecret` property. |
| bootstrapAdmin.user.password | string | `"admin"` | password is the temporary password for the Keycloak bootstrap admin user. |
| bootstrapAdmin.user.username | string | `"admin"` | username is the temporary username for the Keycloak bootstrap admin user. See [Accessing the Admin Console](https://www.keycloak.org/operator/basic-deployment#_accessing_the_admin_console) for more information. |
| cache.configMapFile | object | `{}` | configMapFile references a ConfigMap key containing a custom Infinispan cache configuration XML. When specified, Keycloak uses this file instead of the default cache configuration. See [Configuring caches](https://www.keycloak.org/server/caching#_configuring_caches) for more information. |
| dashboards.enabled | bool | `false` | Indicates whether or not to deploy a set of Keycloak related Grafana dashboards that will be imported automatically. Requires `metrics.enabled` and `serviceMonitor.enabled` to be set as `true`. |
| dashboards.namespace | string | `"monitoring"` | namespace is the namespace where the Grafana dashboards will be deployed. This should ideally be the same namespace as the Prometheus Operator and Grafana instance, but any namespace is supported when using the default settings of the kube-prometheus-stack helm chart. |
| db.external.auth.password | string | `""` | password is the password for the external database user. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.auth.username | string | `""` | username is the username for the external database user. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.database | string | `"keycloak"` | database is the name of the external database to use for Keycloak. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.host | string | `""` | host is the hostname of the external database server. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.port | int | `5432` | port is the port number of the external database server. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.schema | string | `"public"` | schema is the name of the external database schema to use for Keycloak. This setting is ignored if `postgresql.enabled` is `true`. |
| db.external.vendor | string | `"postgres"` | vendor is the external database vendor to use for Keycloak. Supported values are: postgres, mariadb, mysql, oracle, mssql, etc. This setting is ignored if `postgresql.enabled` is `true`. See [Supported databases](https://www.keycloak.org/server/db#_supported_databases) and [Preparing for PostgreSQL](https://www.keycloak.org/server/db#_preparing_for_postgresql) for more information. |
| db.hostOverride | string | `""` | hostOverride is the hostname of the database server. If not set, it will be auto configured for the postgresql headless service of the managed database. This setting is ignored if `postgresql.enabled` is `false`. |
| db.poolInitialSize | int | `10` | poolInitialSize is the initial number of connections that are created when the pool is started. For production environments, Keycloak recommends that the initial, minimal, and maximum pool sizes be equal. See [Concepts for database connection pools](https://www.keycloak.org/high-availability/multi-cluster/concepts-database-connections#multi-cluster-db-concepts) for more information. |
| db.poolMaxSize | int | `100` | poolMaxSize is the maximum number of connections that can be allocated from the pool at a given time. For production environments, Keycloak recommends that the initial, minimal, and maximum pool sizes be equal. See [Concepts for database connection pools](https://www.keycloak.org/high-availability/multi-cluster/concepts-database-connections#multi-cluster-db-concepts) for more information. |
| db.poolMinSize | int | `10` | poolMinSize is the minimum number of connections that are maintained in the pool. For production environments, Keycloak recommends that the initial, minimal, and maximum pool sizes be equal. See [Concepts for database connection pools](https://www.keycloak.org/high-availability/multi-cluster/concepts-database-connections#multi-cluster-db-concepts) for more information. |
| db.port | int | `5432` | port is the port number of the database server. This setting is ignored if `postgresql.enabled` is `false`. |
| db.schema | string | `"public"` | schema is the name of the database schema to use for Keycloak. This setting is ignored if `postgresql.enabled` is `false`. |
| db.vendor | string | `"postgres"` | vendor is the database vendor to use for Keycloak. Supported values are: postgres, mariadb, mysql, oracle, mssql, etc. This setting is ignored if `postgresql.enabled` is `false`. See [Supported databases](https://www.keycloak.org/server/db#_supported_databases) for more information. |
| devModeEnabled | bool | `false` | Indicates whether or not Keycloak is running in development mode. This will disable features and configurations that are not suitable for development environments. |
| extraEnvs | list | `[]` | Additional environment variables to set for the Keycloak server. These should be expressed as key-value pairs that can be either direct values or references to secrets. Use the `additionalOptions` section for first-class options rather than KC_ values here. |
| features.disabled | list | `[]` | disabled is used to disable Keycloak features. See [Feature](https://www.keycloak.org/server/all-config#category-feature) for more information. |
| features.enabled | list | `[]` | enabled is used to enable Keycloak features. Do not set `client-admin-api:v2` since this is enabled by default. Also, do not set `user-event-metrics` or `opentelemetry-metrics` as these will be enabled automatically when needed. See [Feature](https://www.keycloak.org/server/all-config#category-feature) for more information. |
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
| http.tls.certContent | string | `""` | certContent specifies PEM-encoded server certificate used to create a TLS Secret when `http.tlsSecret` is not specified. This property is primarily intended for use with Helm's `--set-file` option, but supports inline when using a pipe. Ignored if `http.tlsSecret` is set. |
| http.tls.keyContent | string | `""` | keyContent specifies PEM-encoded server private key used to create a TLS Secret when `http.tlsSecret` is not specified. This property is primarily intended for use with Helm's `--set-file` option, but supports inline when using a pipe. Ignored if `http.tlsSecret` is set. |
| http.tlsSecret | string | `""` | tlsSecret is an existing secret containing the TLS configuration for the Passthrough TLS scenario. This scenario requires `ingress.enabled` set to `true` and `ingress.tlsSecret`, `ingress.tls.certContent`, and `ingress.tls.keyContent` to be unset. See [TLS Termination with default Ingress](https://www.keycloak.org/operator/basic-deployment#_tls_termination_with_default_ingress) for more information. |
| httpManagement.port | int | `9000` | port is the port of the management interface. |
| image | string | `""` | image is used to specify a custom Keycloak image to be used (e.g., an optimized image). |
| imagePullSecrets | list | `[]` | imagePullSecrets is a list of secrets for pulling an image from a private container registry. |
| import.scheduling | object | `{}` | scheduling is used to configure Kubernetes affinity, tolerations, topology spread constraints, and the priority class name to fine tune the scheduling and placement of Pods. |
| ingress.annotations | object | `{}` | annotations to be added to the Ingress resource. |
| ingress.className | string | `""` | className is the name of the Ingress class. |
| ingress.enabled | bool | `true` | Indicates whether or not an Ingress resource is created to enable outside access. For Ingress Termination/Edge TLS scenario, make sure to set `http.httpEnabled` to `true`, and configure `proxy.headers` as needed. See [TLS Termination with default Ingress](https://www.keycloak.org/operator/basic-deployment#_tls_termination_with_default_ingress) for more information. |
| ingress.labels | object | `{}` | labels to be added to the Ingress resource. |
| ingress.tls.certContent | string | `""` | certContent specifies PEM-encoded server certificate used to create a TLS Secret when `ingress.tlsSecret` is not specified. This property is primarily intended for use with Helm's `--set-file` option, but supports inline when using a pipe. Ignored if `ingress.tlsSecret` is set. |
| ingress.tls.keyContent | string | `""` | keyContent specifies PEM-encoded server private key used to create a TLS Secret when `ingress.tlsSecret` is not specified. This property is primarily intended for use with Helm's `--set-file` option, but supports inline when using a pipe. Ignored if `ingress.tlsSecret` is set. |
| ingress.tlsSecret | string | `""` | tlsSecret is an existing secret containing the TLS configuration for re-encrypt or TLS termination scenarios. See [TLS Secrets](https://kubernetes.io/docs/concepts/configuration/secret/#tls-secrets) for more information. |
| instances | int | `1` | instances is the number of Keycloak instances created to increase availability when set to more than one. |
| keycloak-operator.enabled | bool | `true` | Indicates whether or not the Keycloak Operator is installed. |
| keycloak-&#8203;operator.&#8203;watchAllNamespacesFor.&#8203;keycloak | bool | `false` | keycloak is for indicating whether or not Keycloak resources will be watched in all namespaces. |
| keycloak-&#8203;operator.&#8203;watchAllNamespacesFor.&#8203;keycloakOIDCClient | bool | `false` | keycloakOIDCClient is for indicating whether or not `KeycloakOIDCClient` resources will be watched in all namespaces. |
| keycloak-&#8203;operator.&#8203;watchAllNamespacesFor.&#8203;keycloakRealmImport | bool | `false` | keycloakRealmImport is for indicating whether or not `KeycloakRealmImport` resources will be watched in all namespaces. |
| keycloak-&#8203;operator.&#8203;watchAllNamespacesFor.&#8203;keycloakSAMLClient | bool | `false` | keycloakSAMLClient is for indicating whether or not `KeycloakSAMLClient` resources will be watched in all namespaces. |
| keycloakRealmImport.create | bool | `false` | Indicates whether or not to create a job to import a realm backup or configuration. This is a one-time activity, and it can be safely disabled after a successful import. |
| keycloakRealmImport.labels | object | `{}` | labels to be added to the Job created for the import. |
| keycloakRealmImport.placeholders | object | `{}` | placeholders is used to replace ENV variable placeholders in the realm import. For example, if the 'realm' property has a ${REALM_NAME} placeholder, then 'REALM_NAME: production' will be used to perform a substitution. |
| keycloakRealmImport.realm | object | `{}` | realm allows for defining the realm configuration inline. The structure is the same as any realm backup converted to YAML. This setting cannot be used when `keycloakRealmImport.realmContent` is defined. |
| keycloakRealmImport.realmContent | string | `""` | realmContent contains a realm backup provided as raw `JSON` or `YAML` content. This is primarily intended for use with Helm's `--set-file` option, but supports inline when using a pipe. However, please use the dedicate inline property `keycloakRealmImport.realm` if inline is needed. The format must match `keycloakRealmImport.realmContentFormat`. This setting cannot be used when `keycloakRealmImport.realm` is defined. |
| keycloakRealmImport.realmContentFormat | string | `"json"` | realmContentFormat specifies the format of the content provided via `keycloakRealmImport.realmContent`. Supported values are `json` and `yaml`. This setting is ignored unless `keycloakRealmImport.realmContent` is defined. |
| keycloakRealmImport.resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the import job needs. If no resources are configured, the values from the Keycloak resource, or their defaults, will be used. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| livenessProbe | object | `{}` | livenessProbe is used to override the default configuration of the liveness probe. This type of probe does not wait for the readiness probe to succeed. To make the the probe wait, use the `startupProbe`. Only a subset of features are supported by the CR. |
| metrics.enabled | bool | `false` | Indicates whether or not Keycloak metrics should be enabled. This also enables the `http-metrics-histograms-enabled`, `cache-metrics-histograms-enabled`, and `event-metrics-user-enabled` options and the `user-event-metrics` feature. |
| nameOverride | string | `""` | Override for chart name in helm common labels. |
| networkPolicy.enabled | bool | `true` | Specifies whether a network policy should be created. By default, the operator automatically creates a NetworkPolicy resource to deny access to the clustering port of the Keycloak Pods. The HTTP(S) endpoint is open to traffic from any namespace and the outside world. Note: This will have no effect unless the chosen CNI supports network policies like Calico, Weave, Cilium, Romana, etc. |
| networkPolicy.http | list | `[]` | http is a list of source rules which should be able to access this endpoint (port 8080 by default). Items in this list are combined using a logical OR operation. If this field is empty or missing, this rule matches all sources (traffic not restricted by source). If this field is present and contains at least one item, this rule allows traffic only if the traffic matches at least one item in the list. Due to security reasons, the HTTP endpoint is disabled by default, unless `devModeEnabled` is set to `true`. Reference [Behavior of to and from selectors](https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors). |
| networkPolicy.https | list | `[]` | https is a list of source rules which should be able to access this endpoint (port 8443 by default). Items in this list are combined using a logical OR operation. If this field is empty or missing, this rule matches all sources (traffic not restricted by source). If this field is present and contains at least one item, this rule allows traffic only if the traffic matches at least one item in the list. Reference [Behavior of to and from selectors](https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors). |
| networkPolicy.management | list | `[]` | management is a list of source rules which should be able to access this endpoint (port 9000 by default). Items in this list are combined using a logical OR operation. If this field is empty or missing, this rule matches all sources (traffic not restricted by source). If this field is present and contains at least one item, this rule allows traffic only if the traffic matches at least one item in the list. Reference [Behavior of to and from selectors](https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors). |
| podTemplate | object | `{}` | podTemplate is a raw API representation that is used for the Deployment Template. This field is a temporary workaround in case no supported field exists at the top level of the Keycloak CR for a use case. As such, no guarantees exist that the Deployment will work as expected. |
| postgresql.auth.database | string | `"keycloak"` | database is the name of the database to use for Keycloak. |
| postgresql.auth.password | string | `""` | password is the password for the database user. If unset, a random password is generated and stored in a secret. |
| postgresql.auth.username | string | `"postgres"` | username is the username for the database user. |
| postgresql.enabled | bool | `true` | Indicates whether or not a PostgreSQL database is created. |
| proxy.headers | string | `""` | headers are the proxy headers that should be accepted by the server. Misconfiguration might leave the server exposed to security vulnerabilities. Check the load balancer or reverse proxy configuration in use to determine whether it utilizes the Forwarded (RFC 7239) or X-Forwarded-* (e.g., X-Forwarded-For) mechanism for header propagation. Use with Edge and Re-encrypt scenarios, but not Passthrough. Valid values are `forwarded` and `xforwarded`. See [Configuring a reverse proxy](https://www.keycloak.org/server/reverseproxy) for more information. |
| readinessProbe | object | `{}` | readinessProbe is used to override the default configuration of the readiness probe. Only a subset of features are supported by the CR. |
| resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. When using a `KeycloakRealmImport` resource, if no resources are configured there, these values here, or their defaults, will be used. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| scheduling | object | `{}` | scheduling is used to configure Kubernetes affinity, tolerations, topology spread constraints, and the priority class name to fine tune the scheduling and placement of Pods. |
| secrets | object | `{}` | secrets is used to store confidential data in key-value pairs. Can be used by other properties such as `additionalOptions` that can reference keys without having to provide a pre-existing secret resource. |
| serviceMonitor.annotations | object | `{}` | annotations to be added to the ServiceMonitor resource. |
| serviceMonitor.enabled | bool | `false` | Indicates whether or not to create a ServiceMonitor for Keycloak. Requires that `metrics.enabled` be set to `true`. |
| serviceMonitor.interval | string | `"30s"` | interval is the frequency at which metrics should be scraped. |
| serviceMonitor.labels | object | `{"release":"kube-prometheus-stack"}` | labels to be added to the ServiceMonitor resource. This is useful for the auto-discovery feature of the prometheus operator, which by default uses the release name of the kube-prometheus-stack chart used when installing. See [Monitoring with Prometheus and Grafana](#monitoring-with-prometheus-and-grafana) for more information. |
| serviceMonitor.scrapeTimeout | string | `"10s"` | scrapeTimeout sets the scrape timeout for the ServiceMonitor. |
| startOptimized | bool | `false` | Indicates whether or not to start Keycloak in optimized mode with the `--optimized` flag when using custom pre-augmented images. Keep disabled when using non-optimized images or the official Keycloak image. When using an optimized custom image, `health-enabled`, `metrics-enabled` and `telemetry-metrics-enabled` options need to be explicitly set in the Dockerfile. Any build time options passed through first-class fields or `additionalOptions` will be ignored if not moved to the Dockerfile. See [Best practice](https://www.keycloak.org/operator/customizing-keycloak#_best_practice) for more information. |
| startupProbe | object | `{}` | startupProbe is used to override the default configuration of the startup probe. Only a subset of features are supported by the CR. |
| telemetry.enabled | bool | `false` | Indicates whether or not to enable OpenTelemetry metrics. Requires `metrics.enabled` to be `true`. |
| telemetry.endpoint | string | `"http://otel-collector:4317"` | endpoint is the OpenTelemetry endpoint to connect to. |
| telemetry.protocol | string | `"grpc"` | protocol is the OpenTelemetry protocol used for the transmitting the data. |
| telemetry.resourceAttributes | object | `{}` | resourceAttributes is the OpenTelemetry resource attributes present in the exported telemetry data to characterize the telemetry producer. |
| telemetry.serviceName | string | `""` | serviceName is the OpenTelemetry service name. Takes precedence over 'service.name' defined in `telemetry.resourceAttributes`. |
| tracing.compression | string | `"none"` | compression is the OpenTelemetry method used to compress payloads. Possible values are `gzip` and `none`. |
| tracing.enabled | bool | `false` | Indicates whether or not to enable OpenTelemetry tracing. Requires `metrics.enabled` to be `true`. |
| tracing.endpoint | string | `"http://otel-collector:4317"` | endpoint is the OpenTelemetry endpoint to connect to. |
| tracing.protocol | string | `"grpc"` | protocol is the OpenTelemetry protocol used for the transmitting the data. |
| tracing.samplerRatio | float | `0.1` | samplerRatio is the OpenTelemetry sampler ratio. It represents the probability that a span will be sampled using a double type value. For example, 1.0 is equal to 100%. |
| tracing.samplerType | string | `"traceidratio"` | samplerType is the OpenTelemetry sampler to use for tracing. |
| transaction.xaEnabled | bool | `false` | Indicates whether or not Keycloak should use a non-XA datasource in case the database does not support XA transactions. If supported, then this option can be enabled. See [Using Database Vendors with XA transaction support](https://www.keycloak.org/server/db#_using_database_vendors_with_xa_transaction_support) for more information. |
| truststores | object | `{}` | truststores is used to configure the Keycloak truststores using Secrets or ConfigMaps containing PEM encoded files, or PKCS12 files with extension .p12, .pfx, or .pkcs12. See [Truststores](https://www.keycloak.org/operator/advanced-configuration#_truststores) for more information. |
| update.labels | object | `{}` | labels is for setting additional labels on the Job created for the update. |
| update.revision | string | `"example-v1"` | revision is used for when `update.strategy` is set to the `Explicit` strategy, and is ignored for other strategies. The Keycloak Operator checks this value, and if it matches the previous deployment, it performs a rolling update. See [Configuring the Update Strategy](https://www.keycloak.org/operator/rolling-updates#_configuring_the_update_strategy) for more information. |
| update.scheduling | object | `{}` | scheduling is used to configure Kubernetes affinity, tolerations, topology spread constraints, and the priority class name to fine tune the scheduling and placement of Pods. |
| update.strategy | string | `"RecreateOnImageChange"` | strategy is the update strategy to use for updates. Valid values are `RecreateOnImageChange`, `Auto`, and `Explicit`. See [Configuring the Update Strategy](https://www.keycloak.org/operator/rolling-updates#_configuring_the_update_strategy) for more information. |


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
