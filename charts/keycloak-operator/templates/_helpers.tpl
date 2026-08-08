{{/*
This file is part of Keycloak Operator Helm Chart <https://github.com/StevenJDH/helm-charts>.
Copyright (C) 2026 Steven Jenkins De Haro.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/}}

{{/*
Create a fully qualified RBAC resource name.
Prefixes the resource name with the chart's fullname and truncates the result
to 63 characters to comply with Kubernetes DNS label length limits.
*/}}
{{- define "keycloak-operator.rbacFullname" -}}
{{- $ctx := index . 0 -}}
{{- $suffix := index . 1 -}}
{{- printf "%s-%s" (include "shared-library.fullname" $ctx) $suffix | trunc 63 | trimSuffix "-" -}}
{{- end -}}