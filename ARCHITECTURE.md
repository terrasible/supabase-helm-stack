# Supabase Helm Chart Architecture (Production-Ready)

## Overview

This Helm chart provides a production-ready architecture for deploying Supabase on Kubernetes with simplified secrets management.

## Key Principles

- **Cloud-agnostic & modular**: All components toggleable.
- **Simplified secrets management**: Choose between secretKeyRef or CSI driver path.
- **Metrics & observability**: Per-component ServiceMonitor + Prometheus rules.
- **Kong Operator mandatory** for API gateway with TLS.
- **Database**: Optional internal Postgres or external DB with migration Job.

## High-Level Decisions

- **Database**
  - Postgres subchart (StatefulSet, PVCs) by default.
  - External DB supported via externalDB.enabled=true.
  - Global DB secrets from either k8s secrets or CSI.
  - Post-install DB migration Job executes all SQL scripts.
- **Secrets**
  - Option 1: secretKeyRef in K8s secrets.
  - Option 2: CSI Driver with file-based injection.
  - Simple binary choice in configuration.
- **Service Accounts & RBAC**
  - One SA per component, minimal Role + RoleBinding.
  - IRSA/GCP Workload Identity annotations supported.
- **Ingress & API Gateway**
  - Kong Operator mandatory.
  - Per-component KongService + KongPlugin.
  - Only Studio exposed externally via KongIngress.
- **Observability**
  - ServiceMonitor per component for Prometheus scraping.
  - Prometheus rules per component for alerts.

## Directory Structure

```text
charts/supabase/
├── Chart.yaml
├── values.yaml
├── values-dev.yaml
├── values-prod.yaml
├── README.md
├── examples/
│   ├── eks/
│   ├── gke/
│   └── minikube/
└── templates/
    ├── _helpers.tpl
    ├── NOTES.txt
    ├── configmap.yaml
    ├── secrets/
    │   ├── csi-secretproviderclass.yaml
    │   └── sealedsecret.yaml
    ├── monitoring/
    │   ├── prometheus-rules.yaml
    │   └── grafana-dashboards.yaml
    ├── network/
    │   ├── default-deny.yaml
    │   └── allow-internal.yaml
    ├── jobs/
    │   └── db-migration.yaml
    ├── realtime/
    │   ├── deployment.yaml
    │   ├── service.yaml
    │   ├── pdb.yaml
    │   ├── networkpolicy.yaml
    │   ├── serviceaccount.yaml
    │   ├── role.yaml
    │   ├── rolebinding.yaml
    │   ├── hpa.yaml
    │   ├── servicemonitor.yaml
    │   ├── prometheus-rules.yaml
    │   └── kongservice.yaml
    ├── auth/
    ├── studio/
    ├── rest/
    ├── storage/
    ├── meta/
    ├── functions/
    ├── analytics/
    ├── imgproxy/
    ├── db/
    ├── minio/
    └── kong/
```

## Component Matrix

| Component | Type | Notes |
|-----------|------|-------|
| postgres | StatefulSet | PVCs, leader election |
| postgres-repl | StatefulSet | Read replicas |
| pgbouncer | Deployment | Connection pooling |
| minio | StatefulSet | Optional, otherwise S3 |
| realtime | Deployment | Stateless, HPA, metrics |
| gotrue | Deployment | Stateless |
| postgrest | Deployment | Stateless |
| studio | Deployment | Frontend, exposed via KongIngress |
| storage | Deployment | Stateless, optional PVC cache |
| functions | Deployment/Job | Stateless |
| imageproxy | Deployment | Stateless, optional PVC cache |
| pg_meta | Deployment | Stateless |
| pg_graphql | Deployment | Optional |
| vector | Deployment | Logs forwarder |
| analytics | Deployment | Stateless, external datastore |

## Secrets Management

### Two Simple Options

**Option 1: Kubernetes Secrets (Default)**

```yaml
global:
  csi:
    enabled: false
  defaultSecretName: "supabase-secrets"
```

**Option 2: CSI Driver**

```yaml
global:
  csi:
    enabled: true
    secretName: "csi-supabase-secrets"
    mountPath: "/mnt/secrets"
```

### Helper Template

```yaml
{{- define "supabase.secrets.get" -}}
{{- if .Values.global.csi.enabled -}}
  envFrom:
    - secretRef:
        name: {{ .Values.global.csi.secretName }}
{{- else }}
  envFrom:
    - secretRef:
        name: {{ .Values.global.defaultSecretName }}
        key: {{ .service }}
{{- end -}}
{{- end -}}
```

## DB Migration Job

- Runs after Postgres is ready.
- Executes all SQL files from /db.
- Dynamically configures schema.

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "supabase.fullname" . }}-db-migration
spec:
  template:
    spec:
      serviceAccountName: {{ include "supabase.fullname" . }}-postgres
      restartPolicy: OnFailure
      containers:
      - name: db-migration
        image: {{ .Values.postgres.migrationImage }}
        command: ["supabase", "db", "push"]
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: {{ include "supabase.secrets.get" . }}
        volumeMounts:
        - name: sql-scripts
          mountPath: /db
      volumes:
      - name: sql-scripts
        configMap:
          name: {{ include "supabase.fullname" . }}-sql
```

## Service Accounts & RBAC

- One SA per component.
- Minimal Role + RoleBinding (rbac.strict=true).
- IRSA/GCP Workload Identity supported via annotations.

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "supabase.fullname" . }}-{{ .Values.component }}
  annotations:
    {{- if .Values.irsa.enabled }}
    eks.amazonaws.com/role-arn: "{{ .Values.irsa.roleArn }}"
    {{- end }}
```

## Kong Operator

- Mandatory for OSS chart.
- Each component has optional KongService + KongPlugin.
- Studio exposed externally via KongIngress with TLS.
- Other components internal-only.

### Example Studio KongService

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongService
metadata:
  name: {{ include "supabase.fullname" . }}-studio
spec:
  host: {{ .Values.studio.host }}
  port: 80
  protocol: http
---
apiVersion: configuration.konghq.com/v1
kind: KongIngress
metadata:
  name: {{ include "supabase.fullname" . }}-studio
spec:
  routes:
  - name: studio
    paths:
    - /
    protocols: ["http","https"]
```

## Observability

- ServiceMonitor per component for Prometheus scraping.
- Component-level PrometheusRules for alerts.
- Grafana dashboards optional, can be bundled in monitoring directory.

## Deployment Profiles

### Development

```bash
helm install supabase ./charts/supabase \
  --set dev.enabled=true \
  --set db.persistence.enabled=false
```

### Production

```bash
helm install supabase ./charts/supabase \
  -f values-prod.yaml \
  --set rbac.strict=true
```

## Quick Implementation Checklist

1. Implement simplified secrets management (secretKeyRef or CSI).
2. Flat directory structure for all components.
3. DB migration Job (supabase db push).
4. Per-component KongService + KongPlugin, Studio exposed externally.
5. Mandatory Kong Operator with TLS management.
6. Per-component ServiceMonitor + PrometheusRules.
7. CI: helm lint, ct, helm test.
8. Documentation and example values (dev, prod, cloud-neutral).
