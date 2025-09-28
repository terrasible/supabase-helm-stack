{{/*
Copyright 2024 Bibek Rauniyar
SPDX-License-Identifier: MIT

Licensed under the MIT License (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://opensource.org/licenses/MIT

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "supabase.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "supabase.fullname" -}}
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
{{- define "supabase.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "supabase.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "supabase.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Database host
*/}}
{{- define "supabase.database.host" -}}
{{- if .Values.postgresql.enabled -}}
{{- printf "%s-postgresql" (include "supabase.fullname" .) -}}
{{- else -}}
{{- .Values.externalDatabase.host -}}
{{- end -}}
{{- end }}

{{/*
Database fullname
*/}}
{{- define "supabase.db.fullname" -}}
{{- if .Values.postgresql.enabled -}}
{{- printf "%s-postgresql" (include "supabase.fullname" .) -}}
{{- else -}}
{{- .Values.externalDatabase.host -}}
{{- end -}}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "supabase.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "supabase.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Component-specific naming helpers
*/}}



{{/*
Create the name of the secret to use
*/}}
{{- define "supabase.secretName" -}}
{{- if and .Values.secrets .Values.secrets.existingSecret }}
{{- .Values.secrets.existingSecret }}
{{- else }}
{{- printf "%s-secrets" (include "supabase.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Simplified secrets management - choose between secretKeyRef or CSI
*/}}
{{- define "supabase.secrets.get" -}}
{{- if and .Values.global.csi .Values.global.csi.enabled -}}
  envFrom:
    - secretRef:
        name: {{ .Values.global.csi.secretName | default "" }}
{{- else }}
  envFrom:
    - secretRef:
        name: {{ .Values.global.defaultSecretName | default (include "supabase.secretName" .context) }}
        key: {{ .service }}
{{- end -}}
{{- end -}}

{{/*
Get secret key reference for a specific service and field
*/}}
{{- define "supabase.secrets.secretKeyRef" -}}
{{- $secretName := .Values.global.defaultSecretName | default (include "supabase.secretName" .context) -}}
name: {{ $secretName }}
key: {{ .field }}
{{- end -}}

{{/*
Generic component name template
*/}}
{{- define "supabase.component.name" -}}
{{- .Values.component.nameOverride | default (printf "%s-%s" .Chart.Name .component) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Generic component fullname template
*/}}
{{- define "supabase.component.fullname" -}}
{{- if .Values.component.fullnameOverride }}
{{- .Values.component.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "supabase.component.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Generic component labels template
*/}}
{{- define "supabase.component.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.component.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{/*
Generic component selector labels template
*/}}
{{- define "supabase.component.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.component.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Component-specific name templates for backward compatibility
*/}}
{{- define "supabase.auth.name" -}}
{{- .Values.auth.nameOverride | default (printf "%s-auth" .Chart.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.auth.fullname" -}}
{{- if .Values.auth.fullnameOverride }}
{{- .Values.auth.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "supabase.auth.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "supabase.auth.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.auth.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: auth
{{- end }}

{{- define "supabase.auth.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.auth.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "supabase.auth.serviceAccountName" -}}
{{- if .Values.auth.serviceAccount.create }}
{{- default (include "supabase.auth.fullname" .) .Values.auth.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.auth.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.studio.name" -}}
{{- .Values.studio.nameOverride | default (printf "%s-studio" .Chart.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.studio.fullname" -}}
{{- if .Values.studio.fullnameOverride }}
{{- .Values.studio.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "supabase.studio.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "supabase.studio.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.studio.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: studio
{{- end }}

{{- define "supabase.studio.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.studio.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "supabase.studio.serviceAccountName" -}}
{{- if .Values.studio.serviceAccount.create }}
{{- default (include "supabase.studio.fullname" .) .Values.studio.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.studio.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.rest.name" -}}
{{- .Values.rest.nameOverride | default (printf "%s-rest" .Chart.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.rest.fullname" -}}
{{- if .Values.rest.fullnameOverride }}
{{- .Values.rest.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "supabase.rest.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "supabase.rest.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.rest.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: rest
{{- end }}

{{- define "supabase.rest.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.rest.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "supabase.rest.serviceAccountName" -}}
{{- if .Values.rest.serviceAccount.create }}
{{- default (include "supabase.rest.fullname" .) .Values.rest.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.rest.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.realtime.name" -}}
{{- .Values.realtime.nameOverride | default (printf "%s-realtime" .Chart.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.realtime.fullname" -}}
{{- if .Values.realtime.fullnameOverride }}
{{- .Values.realtime.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "supabase.realtime.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "supabase.realtime.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.realtime.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: realtime
{{- end }}

{{- define "supabase.realtime.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.realtime.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "supabase.realtime.serviceAccountName" -}}
{{- if .Values.realtime.serviceAccount.create }}
{{- default (include "supabase.realtime.fullname" .) .Values.realtime.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.realtime.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.storage.name" -}}
{{- .Values.storage.nameOverride | default (printf "%s-storage" .Chart.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.storage.fullname" -}}
{{- if .Values.storage.fullnameOverride }}
{{- .Values.storage.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "supabase.storage.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "supabase.storage.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.storage.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: storage
{{- end }}

{{- define "supabase.storage.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.storage.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "supabase.storage.serviceAccountName" -}}
{{- if .Values.storage.serviceAccount.create }}
{{- default (include "supabase.storage.fullname" .) .Values.storage.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.storage.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.meta.name" -}}
{{- .Values.meta.nameOverride | default (printf "%s-meta" .Chart.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.meta.fullname" -}}
{{- if .Values.meta.fullnameOverride }}
{{- .Values.meta.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "supabase.meta.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "supabase.meta.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.meta.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: meta
{{- end }}

{{- define "supabase.meta.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.meta.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "supabase.meta.serviceAccountName" -}}
{{- if .Values.meta.serviceAccount.create }}
{{- default (include "supabase.meta.fullname" .) .Values.meta.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.meta.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.functions.name" -}}
{{- .Values.functions.nameOverride | default (printf "%s-functions" .Chart.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.functions.fullname" -}}
{{- if .Values.functions.fullnameOverride }}
{{- .Values.functions.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "supabase.functions.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "supabase.functions.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.functions.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: functions
{{- end }}

{{- define "supabase.functions.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.functions.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "supabase.functions.serviceAccountName" -}}
{{- if .Values.functions.serviceAccount.create }}
{{- default (include "supabase.functions.fullname" .) .Values.functions.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.functions.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.analytics.name" -}}
{{- .Values.analytics.nameOverride | default (printf "%s-analytics" .Chart.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.analytics.fullname" -}}
{{- if .Values.analytics.fullnameOverride }}
{{- .Values.analytics.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "supabase.analytics.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "supabase.analytics.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.analytics.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: analytics
{{- end }}

{{- define "supabase.analytics.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.analytics.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "supabase.analytics.serviceAccountName" -}}
{{- if .Values.analytics.serviceAccount.create }}
{{- default (include "supabase.analytics.fullname" .) .Values.analytics.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.analytics.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.imgproxy.name" -}}
{{- .Values.imgproxy.nameOverride | default (printf "%s-imgproxy" .Chart.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.imgproxy.fullname" -}}
{{- if .Values.imgproxy.fullnameOverride }}
{{- .Values.imgproxy.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "supabase.imgproxy.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "supabase.imgproxy.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.imgproxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: imgproxy
{{- end }}

{{- define "supabase.imgproxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.imgproxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "supabase.imgproxy.serviceAccountName" -}}
{{- if .Values.imgproxy.serviceAccount.create }}
{{- default (include "supabase.imgproxy.fullname" .) .Values.imgproxy.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.imgproxy.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generic component service account name template
*/}}
{{- define "supabase.component.serviceAccountName" -}}
{{- if .Values.component.serviceAccount.create }}
{{- default (include "supabase.component.fullname" .) .Values.component.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.component.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generic health check template
*/}}
{{- define "supabase.component.healthChecks" -}}
{{- if (index .Values .component "livenessProbe") }}
livenessProbe:
  {{- toYaml (index .Values .component "livenessProbe") | nindent 12 }}
{{- end }}
{{- if (index .Values .component "readinessProbe") }}
readinessProbe:
  {{- toYaml (index .Values .component "readinessProbe") | nindent 12 }}
{{- end }}
{{- end }}

{{/*
Generic resources template
*/}}
{{- define "supabase.component.resources" -}}
{{- if (index .Values .component "resources") }}
resources:
  {{- toYaml (index .Values .component "resources") | nindent 12 }}
{{- end }}
{{- end }}

{{/*
Generic node selector, affinity, tolerations template
*/}}
{{- define "supabase.component.scheduling" -}}
{{- with (index .Values .component "nodeSelector") }}
nodeSelector:
  {{- toYaml . | nindent 8 }}
{{- end }}
{{- with (index .Values .component "affinity") }}
affinity:
  {{- toYaml . | nindent 8 }}
{{- end }}
{{- with (index .Values .component "tolerations") }}
tolerations:
  {{- toYaml . | nindent 8 }}
{{- end }}
{{- end }}

{{/*
Generic security context template
*/}}
{{- define "supabase.component.securityContext" -}}
securityContext:
  {{- toYaml (index .Values .component "securityContext") | nindent 12 }}
{{- end }}

{{/*
Generic pod security context template
*/}}
{{- define "supabase.component.podSecurityContext" -}}
{{- toYaml (index .Values .component "podSecurityContext") | nindent 8 }}
{{- end }}
