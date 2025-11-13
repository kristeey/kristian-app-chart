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
Deployment labels - merges common labels with deployment-specific labels
*/}}
{{- define "kristian-app.deploymentLabels" -}}
{{- include "kristian-app.labels" . }}
{{- with .Values.additionalLabels.global }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- with .Values.additionalLabels.deployment }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Pod labels - merges common labels with pod-specific labels
*/}}
{{- define "kristian-app.podLabels" -}}
{{- include "kristian-app.labels" . }}
{{- with .Values.additionalLabels.global }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- with .Values.additionalLabels.pod }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Service Account labels - merges common labels with serviceAccount-specific labels
*/}}
{{- define "kristian-app.serviceAccountLabels" -}}
{{- include "kristian-app.labels" . }}
{{- with .Values.additionalLabels.global }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- with .Values.additionalLabels.serviceAccount }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Ingress labels - merges common labels with ingress-specific labels
*/}}
{{- define "kristian-app.ingressLabels" -}}
{{- include "kristian-app.labels" . }}
{{- with .Values.additionalLabels.global }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- with .Values.additionalLabels.ingress }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
PDB labels - merges common labels with PDB-specific labels
*/}}
{{- define "kristian-app.pdbLabels" -}}
{{- include "kristian-app.labels" . }}
{{- with .Values.additionalLabels.global }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- with .Values.additionalLabels.podDisruptionBudget }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Deployment annotations - merges global with deployment-specific annotations
*/}}
{{- define "kristian-app.deploymentAnnotations" -}}
{{- with .Values.additionalAnnotations.global }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- with .Values.additionalAnnotations.deployment }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Pod annotations - merges global with pod-specific annotations
*/}}
{{- define "kristian-app.podAnnotations" -}}
{{- with .Values.additionalAnnotations.global }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- with .Values.additionalAnnotations.pod }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Service Account annotations - merges global with serviceAccount-specific annotations
*/}}
{{- define "kristian-app.serviceAccountAnnotations" -}}
{{- with .Values.additionalAnnotations.global }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- with .Values.additionalAnnotations.serviceAccount }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Ingress annotations - merges global with ingress-specific annotations
*/}}
{{- define "kristian-app.ingressAnnotations" -}}
{{- with .Values.additionalAnnotations.global }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- with .Values.additionalAnnotations.ingress }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
PDB annotations - merges global with PDB-specific annotations
*/}}
{{- define "kristian-app.pdbAnnotations" -}}
{{- with .Values.additionalAnnotations.global }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- with .Values.additionalAnnotations.podDisruptionBudget }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Build the full image name
*/}}
{{- define "kristian-app.image" -}}
{{- printf "%s:%s" .Values.image.repo (.Values.image.tag | toString) }}
{{- end }}

{{/*
Merge environment variables from variables list
*/}}
{{- define "kristian-app.envVars" -}}
{{- if .Values.envVars.variables }}
{{- range .Values.envVars.variables }}
- name: {{ .name | quote }}
  {{- if .value }}
  value: {{ .value | quote }}
  {{- else if .valueFrom }}
  valueFrom:
    {{- if .valueFrom.fieldRef }}
    fieldRef:
      fieldPath: {{ .valueFrom.fieldRef.field }}
    {{- else if .valueFrom.secretKeyRef }}
    secretKeyRef:
      name: {{ .valueFrom.secretKeyRef.name }}
      key: {{ .valueFrom.secretKeyRef.key }}
    {{- else if .valueFrom.configMapKeyRef }}
    configMapKeyRef:
      name: {{ .valueFrom.configMapKeyRef.name }}
      key: {{ .valueFrom.configMapKeyRef.key }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}
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
