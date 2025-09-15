{{/*
Expand the name of the JWT secret.
*/}}
{{- define "supabase.secret.jwt" -}}
{{- printf "%s-jwt" (include "supabase.fullname" .) }}
{{- end -}}

{{/*
Expand the name of the SMTP secret.
*/}}
{{- define "supabase.secret.smtp" -}}
{{- printf "%s-smtp" (include "supabase.fullname" .) }}
{{- end -}}

{{/*
Expand the name of the dashboard secret.
*/}}
{{- define "supabase.secret.dashboard" -}}
{{- printf "%s-dashboard" (include "supabase.fullname" .) }}
{{- end -}}

{{/*
Expand the name of the database secret.
*/}}
{{- define "supabase.secret.db" -}}
{{- printf "%s-db" (include "supabase.fullname" .) }}
{{- end -}}

{{/*
Expand the name of the auth database secret.
*/}}
{{- define "supabase.secret.auth-db" -}}
{{- printf "%s-auth-db" (include "supabase.fullname" .) }}
{{- end -}}

{{/*
Expand the name of the analytics secret.
*/}}
{{- define "supabase.secret.analytics" -}}
{{- printf "%s-analytics" (include "supabase.fullname" .) }}
{{- end -}}

{{/*
Expand the name of the s3 secret.
*/}}
{{- define "supabase.secret.s3" -}}
{{- printf "%s-s3" (include "supabase.fullname" .) }}
{{- end -}}

{{/*
Check if both s3 keys are valid
*/}}
{{- define "supabase.secret.s3.isValid" -}}
{{- $isValid := "false" -}}
{{- if .Values.legacySecret.s3.keyId -}}
{{- if .Values.legacySecret.s3.accessKey -}}
{{- printf "true" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Enhanced Secrets Management Helper Functions
Supports CSI drivers, External Secrets, and Kubernetes secrets
*/}}

{{/*
Get the effective secrets strategy for a service
Usage: {{ include "supabase.secrets.strategy" (dict "Values" .Values "service" "jwt") }}
*/}}
{{- define "supabase.secrets.strategy" -}}
{{- $service := .service -}}
{{- $strategy := "kubernetes" -}}
{{- if .Values.secrets.global.strategy -}}
{{- $strategy = .Values.secrets.global.strategy -}}
{{- end -}}
{{- if .Values.legacySecret.strategy -}}
{{- $strategy = .Values.legacySecret.strategy -}}
{{- end -}}
{{- if and .Values.secrets.microservices (index .Values.secrets.microservices $service) -}}
{{- if (index .Values.secrets.microservices $service).strategy -}}
{{- $strategy = (index .Values.secrets.microservices $service).strategy -}}
{{- end -}}
{{- end -}}
{{- printf "%s" $strategy -}}
{{- end -}}

{{/*
Get secret name based on strategy
Usage: {{ include "supabase.secrets.name" (dict "Values" .Values "service" "jwt" "context" .) }}
*/}}
{{- define "supabase.secrets.name" -}}
{{- $service := .service -}}
{{- $context := .context -}}
{{- $strategy := include "supabase.secrets.strategy" (dict "Values" .Values "service" $service) -}}
{{- $secretConfig := index .Values.secret $service -}}

{{- if eq $strategy "kubernetes" -}}
  {{- if $secretConfig.secretRef -}}
    {{- printf "%s" $secretConfig.secretRef -}}
  {{- else -}}
    {{- printf "%s-%s" (include "supabase.fullname" $context) $service -}}
  {{- end -}}
{{- else if eq $strategy "csi" -}}
  {{- printf "%s-%s-csi" (include "supabase.fullname" $context) $service -}}
{{- else if eq $strategy "external" -}}
  {{- printf "%s-%s-external" (include "supabase.fullname" $context) $service -}}
{{- end -}}
{{- end -}}

{{/*
Get secret key for a specific field
Usage: {{ include "supabase.secrets.key" (dict "Values" .Values "service" "jwt" "field" "secret") }}
*/}}
{{- define "supabase.secrets.key" -}}
{{- $service := .service -}}
{{- $field := .field -}}
{{- $strategy := include "supabase.secrets.strategy" (dict "Values" .Values "service" $service) -}}
{{- $secretConfig := index .Values.secret $service -}}

{{- if eq $strategy "kubernetes" -}}
  {{- if $secretConfig.secretRef -}}
    {{- printf "%s" (index $secretConfig.secretRefKey $field) -}}
  {{- else -}}
    {{- printf "%s" $field -}}
  {{- end -}}
{{- else if eq $strategy "csi" -}}
  {{- printf "%s" (index $secretConfig.csi.keys $field) -}}
{{- else if eq $strategy "external" -}}
  {{- printf "%s" $field -}}
{{- end -}}
{{- end -}}

{{/*
Generate secretKeyRef for environment variables
Usage: {{ include "supabase.secrets.secretKeyRef" (dict "Values" .Values "service" "jwt" "field" "secret" "context" .) }}
*/}}
{{- define "supabase.secrets.secretKeyRef" -}}
{{- $service := .service -}}
{{- $field := .field -}}
{{- $context := .context -}}
name: {{ include "supabase.secrets.name" (dict "Values" .Values "service" $service "context" $context) }}
key: {{ include "supabase.secrets.key" (dict "Values" .Values "service" $service "field" $field) }}
{{- end -}}

{{/*
Check if CSI is enabled for a service
Usage: {{ include "supabase.secrets.csi.enabled" (dict "Values" .Values "service" "jwt") }}
*/}}
{{- define "supabase.secrets.csi.enabled" -}}
{{- $service := .service -}}
{{- $strategy := include "supabase.secrets.strategy" (dict "Values" .Values "service" $service) -}}
{{- $secretConfig := index .Values.secret $service -}}
{{- if and (eq $strategy "csi") $secretConfig.csi.enabled .Values.secrets.global.csi.enabled -}}
{{- printf "true" -}}
{{- else -}}
{{- printf "false" -}}
{{- end -}}
{{- end -}}

{{/*
Check if External Secrets is enabled for a service
Usage: {{ include "supabase.secrets.external.enabled" (dict "Values" .Values "service" "jwt") }}
*/}}
{{- define "supabase.secrets.external.enabled" -}}
{{- $service := .service -}}
{{- $strategy := include "supabase.secrets.strategy" (dict "Values" .Values "service" $service) -}}
{{- $secretConfig := index .Values.secret $service -}}
{{- if and (eq $strategy "external") $secretConfig.external.enabled .Values.secrets.global.external.enabled -}}
{{- printf "true" -}}
{{- else -}}
{{- printf "false" -}}
{{- end -}}
{{- end -}}

{{/*
Generate CSI SecretProviderClass name
Usage: {{ include "supabase.secrets.csi.providerClassName" (dict "Values" .Values "service" "jwt" "context" .) }}
*/}}
{{- define "supabase.secrets.csi.providerClassName" -}}
{{- $service := .service -}}
{{- $context := .context -}}
{{- printf "%s-%s-csi-provider" (include "supabase.fullname" $context) $service -}}
{{- end -}}

{{/*
Generate External Secret name
Usage: {{ include "supabase.secrets.external.name" (dict "Values" .Values "service" "jwt" "context" .) }}
*/}}
{{- define "supabase.secrets.external.name" -}}
{{- $service := .service -}}
{{- $context := .context -}}
{{- printf "%s-%s-external-secret" (include "supabase.fullname" $context) $service -}}
{{- end -}}

{{/*
Get CSI volume mount configuration
Usage: {{ include "supabase.secrets.csi.volumeMount" (dict "Values" .Values "service" "jwt") }}
*/}}
{{- define "supabase.secrets.csi.volumeMount" -}}
{{- $service := .service -}}
- name: {{ $service }}-csi-secrets
  mountPath: /mnt/secrets/{{ $service }}
  readOnly: true
{{- end -}}

{{/*
Get CSI volume configuration
Usage: {{ include "supabase.secrets.csi.volume" (dict "Values" .Values "service" "jwt" "context" .) }}
*/}}
{{- define "supabase.secrets.csi.volume" -}}
{{- $service := .service -}}
{{- $context := .context -}}
- name: {{ $service }}-csi-secrets
  csi:
    driver: secrets-store.csi.x-k8s.io
    readOnly: true
    volumeAttributes:
      secretProviderClass: {{ include "supabase.secrets.csi.providerClassName" (dict "Values" .Values "service" $service "context" $context) }}
{{- end -}}
