# KeycloakOIDCClients CRD Reference

This generated document lists the configurable properties available under `spec` for the `KeycloakOIDCClient` custom resource.

## Reference

| Property path | Type | Description |
|---------------|------|-------------|
| `spec.client.appUrl` | string | URL to the application's homepage that is represented by this client  |
| `spec.client.auth.certificate` | string | Public key used to authenticate this client with Signed JWT authentication  |
| `spec.client.auth.method` | string | Client authentication method (e.g. `client-secret`, `client-secret-jwt`)  |
| `spec.client.auth.secretRef.key` | string |   |
| `spec.client.auth.secretRef.name` | string |   |
| `spec.client.auth.secretRef.optional` | boolean |   |
| `spec.client.createdTimestamp` | integer | Timestamp when the client was created  |
| `spec.client.description` | string | Human readable description of the client  |
| `spec.client.displayName` | string | Human readable name of the client  |
| `spec.client.enabled` | boolean | Whether this client is enabled  |
| `spec.client.loginFlows` | array[string] | Login flows that are enabled for this client  |
| `spec.client.redirectUris` | array[string] | URIs that the browser can redirect to after login  |
| `spec.client.roles` | array[string] | Roles associated with this client  |
| `spec.client.serviceAccountRoles` | array[string] | Roles assigned to the service account  |
| `spec.client.updatedTimestamp` | integer | Timestamp when the client was last updated  |
| `spec.client.webOrigins` | array[string] | Web origins that are allowed to make requests to this client  |
| `spec.keycloakCRName` | string | The name of the Keycloak CR to reference, in the same namespace.  |
| `spec.realm` | string | The realm of the Client  |
