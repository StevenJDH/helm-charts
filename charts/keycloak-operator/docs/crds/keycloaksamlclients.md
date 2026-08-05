# KeycloakSAMLClients CRD Reference

This generated document lists the configurable properties available under `spec` for the `KeycloakSAMLClient` custom resource.

## Reference

| Property path | Type | Description |
|---------------|------|-------------|
| `spec.client.allowEcpFlow` | boolean | Allow ECP (Enhanced Client or Proxy) flow  |
| `spec.client.appUrl` | string | URL to the application's homepage that is represented by this client  |
| `spec.client.clientSignatureRequired` | boolean | Require client to sign SAML requests  |
| `spec.client.createdTimestamp` | integer | Timestamp when the client was created  |
| `spec.client.description` | string | Human readable description of the client  |
| `spec.client.displayName` | string | Human readable name of the client  |
| `spec.client.enabled` | boolean | Whether this client is enabled  |
| `spec.client.forceNameIdFormat` | boolean | Force the specified Name ID format even if the client requests a different one  |
| `spec.client.forcePostBinding` | boolean | Force POST binding for SAML responses  |
| `spec.client.frontChannelLogout` | boolean | Use front-channel logout (browser redirect)  |
| `spec.client.includeAuthnStatement` | boolean | Include AuthnStatement in the SAML response  |
| `spec.client.nameIdFormat` | string | Name ID format to use for the subject  |
| `spec.client.redirectUris` | array[string] | URIs that the browser can redirect to after login  |
| `spec.client.roles` | array[string] | Roles associated with this client  |
| `spec.client.signAssertions` | boolean | Sign SAML assertions  |
| `spec.client.signDocuments` | boolean | Sign SAML documents on the server side  |
| `spec.client.signatureAlgorithm` | string | Signature algorithm for signing SAML documents  |
| `spec.client.signatureCanonicalizationMethod` | string | Canonicalization method for XML signatures  |
| `spec.client.signingCertificate` | string | X.509 certificate for signing (PEM format, without headers)  |
| `spec.client.updatedTimestamp` | integer | Timestamp when the client was last updated  |
| `spec.keycloakCRName` | string | The name of the Keycloak CR to reference, in the same namespace.  |
| `spec.realm` | string | The realm of the Client  |
