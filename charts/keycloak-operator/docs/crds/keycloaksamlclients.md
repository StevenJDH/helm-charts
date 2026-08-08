# KeycloakSAMLClients CRD Reference

This generated document lists the configurable properties available under `spec` for the `KeycloakSAMLClient` custom resource.

## v2alpha1 Reference

| Version | Property path | Type | Description |
|---------|---------------|------|-------------|
| `v2alpha1` | `spec.client.allowEcpFlow` | boolean | Allow ECP (Enhanced Client or Proxy) flow  |
| `v2alpha1` | `spec.client.appUrl` | string | URL to the application's homepage that is represented by this client  |
| `v2alpha1` | `spec.client.clientSignatureRequired` | boolean | Require client to sign SAML requests  |
| `v2alpha1` | `spec.client.createdTimestamp` | integer | Timestamp when the client was created  |
| `v2alpha1` | `spec.client.description` | string | Human readable description of the client  |
| `v2alpha1` | `spec.client.displayName` | string | Human readable name of the client  |
| `v2alpha1` | `spec.client.enabled` | boolean | Whether this client is enabled  |
| `v2alpha1` | `spec.client.forceNameIdFormat` | boolean | Force the specified Name ID format even if the client requests a different one  |
| `v2alpha1` | `spec.client.forcePostBinding` | boolean | Force POST binding for SAML responses  |
| `v2alpha1` | `spec.client.frontChannelLogout` | boolean | Use front-channel logout (browser redirect)  |
| `v2alpha1` | `spec.client.includeAuthnStatement` | boolean | Include AuthnStatement in the SAML response  |
| `v2alpha1` | `spec.client.nameIdFormat` | string | Name ID format to use for the subject  |
| `v2alpha1` | `spec.client.redirectUris` | array[string] | URIs that the browser can redirect to after login  |
| `v2alpha1` | `spec.client.roles` | array[string] | Roles associated with this client  |
| `v2alpha1` | `spec.client.signAssertions` | boolean | Sign SAML assertions  |
| `v2alpha1` | `spec.client.signDocuments` | boolean | Sign SAML documents on the server side  |
| `v2alpha1` | `spec.client.signatureAlgorithm` | string | Signature algorithm for signing SAML documents  |
| `v2alpha1` | `spec.client.signatureCanonicalizationMethod` | string | Canonicalization method for XML signatures  |
| `v2alpha1` | `spec.client.signingCertificate` | string | X.509 certificate for signing (PEM format, without headers)  |
| `v2alpha1` | `spec.client.updatedTimestamp` | integer | Timestamp when the client was last updated  |
| `v2alpha1` | `spec.keycloakCRName` | string | The name of the Keycloak CR to reference, in the same namespace.  |
| `v2alpha1` | `spec.realm` | string | The realm of the Client  |
