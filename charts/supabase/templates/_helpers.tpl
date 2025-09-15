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
{{- define "supabase.auth.fullname" -}}
{{- printf "%s-auth" (include "supabase.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.rest.fullname" -}}
{{- printf "%s-rest" (include "supabase.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.realtime.fullname" -}}
{{- printf "%s-realtime" (include "supabase.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.storage.fullname" -}}
{{- printf "%s-storage" (include "supabase.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.meta.fullname" -}}
{{- printf "%s-meta" (include "supabase.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.studio.fullname" -}}
{{- printf "%s-studio" (include "supabase.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.functions.fullname" -}}
{{- printf "%s-functions" (include "supabase.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.imgproxy.fullname" -}}
{{- printf "%s-imgproxy" (include "supabase.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "supabase.analytics.fullname" -}}
{{- printf "%s-analytics" (include "supabase.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Component-specific labels
*/}}
{{- define "supabase.auth.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.auth.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: auth
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

{{- define "supabase.realtime.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.realtime.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: realtime
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

{{- define "supabase.meta.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.meta.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: meta
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

{{- define "supabase.functions.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.functions.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: functions
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

{{- define "supabase.analytics.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.analytics.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: analytics
{{- end }}

{{/*
Component-specific selector labels
*/}}
{{- define "supabase.auth.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: auth
{{- end }}

{{- define "supabase.rest.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: rest
{{- end }}

{{- define "supabase.realtime.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: realtime
{{- end }}

{{- define "supabase.storage.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: storage
{{- end }}

{{- define "supabase.meta.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: meta
{{- end }}

{{- define "supabase.studio.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: studio
{{- end }}

{{- define "supabase.functions.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: functions
{{- end }}

{{- define "supabase.imgproxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: imgproxy
{{- end }}

{{- define "supabase.analytics.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: analytics
{{- end }}

{{/*
Component-specific service account names
*/}}
{{- define "supabase.auth.serviceAccountName" -}}
{{- if .Values.auth.serviceAccount.create }}
{{- default (include "supabase.auth.fullname" .) .Values.auth.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.auth.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.rest.serviceAccountName" -}}
{{- if .Values.rest.serviceAccount.create }}
{{- default (include "supabase.rest.fullname" .) .Values.rest.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.rest.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.realtime.serviceAccountName" -}}
{{- if .Values.realtime.serviceAccount.create }}
{{- default (include "supabase.realtime.fullname" .) .Values.realtime.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.realtime.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.storage.serviceAccountName" -}}
{{- if .Values.storage.serviceAccount.create }}
{{- default (include "supabase.storage.fullname" .) .Values.storage.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.storage.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.meta.serviceAccountName" -}}
{{- if .Values.meta.serviceAccount.create }}
{{- default (include "supabase.meta.fullname" .) .Values.meta.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.meta.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.studio.serviceAccountName" -}}
{{- if .Values.studio.serviceAccount.create }}
{{- default (include "supabase.studio.fullname" .) .Values.studio.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.studio.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.functions.serviceAccountName" -}}
{{- if .Values.functions.serviceAccount.create }}
{{- default (include "supabase.functions.fullname" .) .Values.functions.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.functions.serviceAccount.name }}
{{- end }}
{{- end }}

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

{{- define "supabase.imgproxy.serviceAccountName" -}}
{{- if .Values.imgproxy.serviceAccount.create }}
{{- default (include "supabase.imgproxy.fullname" .) .Values.imgproxy.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.imgproxy.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.analytics.serviceAccountName" -}}
{{- if .Values.analytics.serviceAccount.create }}
{{- default (include "supabase.analytics.fullname" .) .Values.analytics.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.analytics.serviceAccount.name }}
{{- end }}
{{- end }}
