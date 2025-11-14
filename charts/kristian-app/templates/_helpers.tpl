{{/*
Expand the name of the chart.
*/}}
{{- define "kristian-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "kristian-app.fullname" -}}
{{- if .Values.fullNameOverride }}
{{- .Values.fullNameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kristian-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kristian-app.labels" -}}
helm.sh/chart: {{ include "kristian-app.chart" . }}
{{ include "kristian-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.team }}
team: {{ .Values.team | quote }}
{{- end }}
{{- if .Values.product }}
product: {{ .Values.product | quote }}
{{- end }}
{{- if .Values.environment }}
environment: {{ .Values.environment | quote }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kristian-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kristian-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kristian-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kristian-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Build the full image name
*/}}
{{- define "kristian-app.image" -}}
{{- printf "%s:%s" .Values.image.repo (.Values.image.tag | toString) }}
{{- end }}

{{/*
Domain
*/}}
{{- define "kristian-app.domain" -}}
{{- default "example.com" .Values.domain }}
{{- end }}

{{/*
Environment variables from Azure Key Vault secrets
*/}}
{{- define "kristian-app.secretEnvVars" -}}
{{- if .Values.envVars.secrets }}
{{- range .Values.envVars.secrets }}
- name: {{ .envVarName | quote }}
  value: {{ printf "%s@azurekeyvault" .keyVaultSecret }}
{{- end }}
{{- end }}
{{- end }}
