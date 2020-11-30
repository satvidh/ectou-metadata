{{/*
Expand the name of the chart.
*/}}
{{- define "mock_ec2_metadata.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mock_ec2_metadata.fullname" -}}
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
{{- define "mock_ec2_metadata.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mock_ec2_metadata.labels" -}}
helm.sh/chart: {{ include "mock_ec2_metadata.chart" . }}
{{ include "mock_ec2_metadata.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mock_ec2_metadata.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mock_ec2_metadata.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mock_ec2_metadata.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mock_ec2_metadata.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the secrets to use
*/}}
{{- define "charts.secrets" -}}
{{- if .Values.mockMetadata.secretsName }}
{{- .Values.mockMetadata.secretsName -}}
{{- else -}}
mock-ec2-metadata-secrets
{{- end }}
{{- end }}
