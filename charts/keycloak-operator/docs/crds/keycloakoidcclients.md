# KeycloakOIDCClients CRD Reference

This generated document lists the configurable properties available under `spec` for the `KeycloakOIDCClient` custom resource.

## v2alpha1 Reference

| Version | Property path | Type | Description |
|---------|---------------|------|-------------|
| `v2alpha1` | `spec.client.appUrl` | string | URL to the application's homepage that is represented by this client  |
| `v2alpha1` | `spec.client.auth.certificate` | string | Public key used to authenticate this client with Signed JWT authentication  |
| `v2alpha1` | `spec.client.auth.method` | string | Client authentication method (e.g. `client-secret`, `client-secret-jwt`)  |
| `v2alpha1` | `spec.client.auth.secretRef.key` | string |   |
| `v2alpha1` | `spec.client.auth.secretRef.name` | string |   |
| `v2alpha1` | `spec.client.auth.secretRef.optional` | boolean |   |
| `v2alpha1` | `spec.client.createdTimestamp` | integer | Timestamp when the client was created  |
| `v2alpha1` | `spec.client.description` | string | Human readable description of the client  |
| `v2alpha1` | `spec.client.displayName` | string | Human readable name of the client  |
| `v2alpha1` | `spec.client.enabled` | boolean | Whether this client is enabled  |
| `v2alpha1` | `spec.client.loginFlows` | array[string] | Login flows that are enabled for this client  |
| `v2alpha1` | `spec.client.redirectUris` | array[string] | URIs that the browser can redirect to after login  |
| `v2alpha1` | `spec.client.roles` | array[string] | Roles associated with this client  |
| `v2alpha1` | `spec.client.serviceAccountRoles` | array[string] | Roles assigned to the service account  |
| `v2alpha1` | `spec.client.updatedTimestamp` | integer | Timestamp when the client was last updated  |
| `v2alpha1` | `spec.client.webOrigins` | array[string] | Web origins that are allowed to make requests to this client  |
| `v2alpha1` | `spec.keycloakCRName` | string | The name of the Keycloak CR to reference, in the same namespace.  |
| `v2alpha1` | `spec.realm` | string | The realm of the Client  |
