{{/*
This file is part of Shared Library Helm Chart <https://github.com/StevenJDH/helm-charts>.
Copyright (C) 2023 Steven Jenkins De Haro.

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
Return the appropriate apiVersion for cronjob APIs.
Don't use {{- if .Capabilities.APIVersions.Has "batch/v1" }}
because api-version might be present, but resource might not
be available for it. For example, 1.19.x has batch/v1 as an 
available api-resource, but no CronJob under it, so 
batch/v1beta1 must be used.
*/}}
{{- define "cronjob.apiVersion" -}}
{{- if semverCompare ">= 1.21-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "batch/v1" }}
{{- else }}
{{- print "batch/v1beta1" }}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "shared-library.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "shared-library.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "shared-library.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "shared-library.labels" -}}
helm.sh/chart: {{ include "shared-library.chart" . }}
{{ include "shared-library.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "shared-library.selectorLabels" -}}
app.kubernetes.io/name: {{ include "shared-library.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "shared-library.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "shared-library.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create pull secret credentials for a private registry.
*/}}
{{- define "shared-library.imagePullSecret" }}
{{- with .Values.image.pullSecret }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{/*
Create AWS IRSA annotations for the service account.
*/}}
{{- define "shared-library.irsaAnnotations" -}}
eks.amazonaws.com/audience: {{ .Values.serviceAccount.aws.irsa.audience | default "sts.amazonaws.com" | quote }}
eks.amazonaws.com/role-arn: {{ .Values.serviceAccount.aws.irsa.roleArn | quote }}
eks.amazonaws.com/sts-regional-endpoints: {{ .Values.serviceAccount.aws.irsa.stsRegionalEndpoints | default "true" | quote }}
eks.amazonaws.com/token-expiration: {{ .Values.serviceAccount.aws.irsa.tokenExpiration | default "3600" | quote }}
{{- end }}