# supabase

The open source Firebase alternative.

![Version: 0.1.3](https://img.shields.io/badge/Version-0.1.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

## Prerequisites

### Kong Operator (Required)

Before installing this chart, you must install the Kong Operator which provides the necessary CRDs:

```bash
# Install Kong Operator
kubectl apply -f https://github.com/Kong/kubernetes-ingress-controller/releases/latest/download/all-in-one-dbless.yaml

# Verify Kong Operator is running
kubectl get pods -n kong-system
```

### Helm Dependencies

This chart has dependencies that need to be downloaded:

```bash
# Update chart dependencies
helm dependency update charts/supabase
```

## Installation

### Quick Start

```bash
# Add the repository (if published)
helm repo add supabase-helm https://your-repo-url

# Install with default values
helm install my-supabase supabase-helm/supabase

# Or install from local chart
helm install my-supabase ./charts/supabase
```

### Custom Installation

```bash
# Install with custom values
helm install my-supabase ./charts/supabase -f my-values.yaml

# Install in specific namespace
helm install my-supabase ./charts/supabase --namespace supabase --create-namespace
```

## Configuration

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | grafana | 12.1.8 |
| https://charts.bitnami.com/bitnami | minio | 17.0.21 |
| https://charts.bitnami.com/bitnami | postgresql | 16.7.27 |
| https://charts.bitnami.com/bitnami | postgresql-ha | 16.3.2 |
| https://charts.bitnami.com/bitnami | prometheus | 2.1.23 |
| https://charts.bitnami.com/bitnami | redis | 22.0.7 |
| https://charts.jetstack.io | cert-manager | 1.11.0 |
| https://charts.konghq.com | kong | 2.13.1 |
| https://helm.vector.dev | vector | 0.22.0 |
| https://kubernetes.github.io/ingress-nginx | ingress-nginx | 4.5.2 |

<!-- pragma: allowlist secret -->
## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| alertmanager.additionalAlertRelabelConfigs | list | `[]` |  |
| alertmanager.additionalAlertmanagerConfigs | list | `[]` |  |
| alertmanager.customConfig.enabled | bool | `false` |  |
| alertmanager.customConfig.global | object | `{}` |  |
| alertmanager.customConfig.inhibitRules | list | `[]` |  |
| alertmanager.customConfig.receivers | list | `[]` |  |
| alertmanager.customConfig.route | object | `{}` |  |
| alertmanager.webhookConfigs | list | `[]` |  |
| analytics.affinity | object | `{}` |  |
| analytics.autoscaling.enabled | bool | `false` |  |
| analytics.autoscaling.maxReplicas | int | `10` |  |
| analytics.autoscaling.minReplicas | int | `2` |  |
| analytics.autoscaling.targetCPUUtilizationPercentage | int | `70` |  |
| analytics.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| analytics.bigQuery.enabled | bool | `false` |  |
| analytics.bigQuery.gcloudJson | string | `""` |  |
| analytics.bigQuery.projectId | string | `"google-project-id"` |  |
| analytics.bigQuery.projectNumber | string | `"google-project-number"` |  |
| analytics.enabled | bool | `false` |  |
| analytics.environment.DB_DRIVER | string | `"postgresql"` |  |
| analytics.environment.DB_HOST | string | `"supabase-stack-postgresql"` |  |
| analytics.environment.DB_PORT | int | `5432` |  |
| analytics.environment.DB_SCHEMA | string | `"_analytics"` |  |
| analytics.environment.DB_USERNAME | string | `"supabase_admin"` |  |
| analytics.environment.FEATURE_FLAG_OVERRIDE | string | `"multibackend=true"` |  |
| analytics.environment.LOGFLARE_NODE_HOST | string | `"127.0.0.1"` |  |
| analytics.environment.LOGFLARE_SINGLE_TENANT | string | `"true"` |  |
| analytics.environment.LOGFLARE_SUPABASE_MODE | string | `"true"` |  |
| analytics.fullnameOverride | string | `""` |  |
| analytics.image.pullPolicy | string | `"IfNotPresent"` |  |
| analytics.image.repository | string | `"supabase/logflare"` |  |
| analytics.image.tag | string | `"latest"` |  |
| analytics.imagePullSecrets | list | `[]` |  |
| analytics.livenessProbe | object | `{}` |  |
| analytics.nameOverride | string | `""` |  |
| analytics.nodeSelector | object | `{}` |  |
| analytics.podAnnotations | object | `{}` |  |
| analytics.podDisruptionBudget.enabled | bool | `false` |  |
| analytics.podDisruptionBudget.minAvailable | int | `1` |  |
| analytics.podSecurityContext | object | `{}` |  |
| analytics.readinessProbe | object | `{}` |  |
| analytics.replicaCount | int | `1` |  |
| analytics.resources.limits.cpu | string | `"500m"` |  |
| analytics.resources.limits.memory | string | `"512Mi"` |  |
| analytics.resources.requests.cpu | string | `"100m"` |  |
| analytics.resources.requests.memory | string | `"128Mi"` |  |
| analytics.securityContext | object | `{}` |  |
| analytics.service.port | int | `4000` |  |
| analytics.service.type | string | `"ClusterIP"` |  |
| analytics.serviceAccount.annotations | object | `{}` |  |
| analytics.serviceAccount.create | bool | `true` |  |
| analytics.serviceAccount.name | string | `""` |  |
| analytics.serviceMonitor.enabled | bool | `false` |  |
| analytics.serviceMonitor.interval | string | `"30s"` |  |
| analytics.serviceMonitor.path | string | `"/metrics"` |  |
| analytics.serviceMonitor.port | string | `"http"` |  |
| analytics.tolerations | list | `[]` |  |
| auth.affinity | object | `{}` |  |
| auth.autoscaling.enabled | bool | `false` |  |
| auth.autoscaling.maxReplicas | int | `10` |  |
| auth.autoscaling.minReplicas | int | `2` |  |
| auth.autoscaling.targetCPUUtilizationPercentage | int | `70` |  |
| auth.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| auth.enabled | bool | `true` |  |
| auth.envFrom | list | `[]` |  |
| auth.environment.API_EXTERNAL_URL | string | `"http://example.com"` |  |
| auth.environment.DB_DRIVER | string | `"postgres"` |  |
| auth.environment.DB_HOST | string | `"supabase-stack-postgresql"` |  |
| auth.environment.DB_PORT | int | `5432` |  |
| auth.environment.DB_SSL | string | `"false"` |  |
| auth.environment.DB_USER | string | `"supabase_auth_admin"` |  |
| auth.environment.GOTRUE_API_HOST | string | `"0.0.0.0"` |  |
| auth.environment.GOTRUE_API_PORT | string | `"9999"` |  |
| auth.environment.GOTRUE_DISABLE_SIGNUP | string | `"false"` |  |
| auth.environment.GOTRUE_EXTERNAL_EMAIL_ENABLED | string | `"true"` |  |
| auth.environment.GOTRUE_EXTERNAL_PHONE_ENABLED | string | `"false"` |  |
| auth.environment.GOTRUE_JWT_ADMIN_ROLES | string | `"service_role"` |  |
| auth.environment.GOTRUE_JWT_AUD | string | `"authenticated"` |  |
| auth.environment.GOTRUE_JWT_DEFAULT_GROUP_NAME | string | `"authenticated"` |  |
| auth.environment.GOTRUE_JWT_EXP | string | `"3600"` |  |
| auth.environment.GOTRUE_MAILER_AUTOCONFIRM | string | `"true"` |  |
| auth.environment.GOTRUE_MAILER_URLPATHS_CONFIRMATION | string | `"/auth/v1/verify"` |  |
| auth.environment.GOTRUE_MAILER_URLPATHS_EMAIL_CHANGE | string | `"/auth/v1/verify"` |  |
| auth.environment.GOTRUE_MAILER_URLPATHS_INVITE | string | `"/auth/v1/verify"` |  |
| auth.environment.GOTRUE_MAILER_URLPATHS_RECOVERY | string | `"/auth/v1/verify"` |  |
| auth.environment.GOTRUE_SITE_URL | string | `"http://example.com"` |  |
| auth.environment.GOTRUE_SMS_AUTOCONFIRM | string | `"false"` |  |
| auth.environment.GOTRUE_URI_ALLOW_LIST | string | `"*"` |  |
| auth.fullnameOverride | string | `""` |  |
| auth.image.pullPolicy | string | `"IfNotPresent"` |  |
| auth.image.repository | string | `"supabase/gotrue"` |  |
| auth.image.tag | string | `"v2.155.6"` |  |
| auth.imagePullSecrets | list | `[]` |  |
| auth.ingress.annotations | object | `{}` |  |
| auth.ingress.className | string | `""` |  |
| auth.ingress.enabled | bool | `false` |  |
| auth.ingress.hosts[0].host | string | `"auth.supabase.local"` |  |
| auth.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| auth.ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| auth.ingress.tls | list | `[]` |  |
| auth.livenessProbe | object | `{}` |  |
| auth.nameOverride | string | `""` |  |
| auth.nodeSelector | object | `{}` |  |
| auth.podAnnotations | object | `{}` |  |
| auth.podDisruptionBudget.enabled | bool | `false` |  |
| auth.podDisruptionBudget.minAvailable | int | `1` |  |
| auth.podMonitor.annotations | object | `{}` |  |
| auth.podMonitor.enabled | bool | `false` |  |
| auth.podMonitor.endpoints[0].interval | string | `"30s"` |  |
| auth.podMonitor.endpoints[0].path | string | `"/metrics"` |  |
| auth.podMonitor.endpoints[0].port | string | `"metrics"` |  |
| auth.podMonitor.labels | object | `{}` |  |
| auth.podSecurityContext | object | `{}` |  |
| auth.readinessProbe | object | `{}` |  |
| auth.replicaCount | int | `1` |  |
| auth.resources.limits.cpu | string | `"500m"` |  |
| auth.resources.limits.memory | string | `"1Gi"` |  |
| auth.resources.requests.cpu | string | `"100m"` |  |
| auth.resources.requests.memory | string | `"256Mi"` |  |
| auth.securityContext | object | `{}` |  |
| auth.service.port | int | `9999` |  |
| auth.service.type | string | `"ClusterIP"` |  |
| auth.serviceAccount.annotations | object | `{}` |  |
| auth.serviceAccount.create | bool | `true` |  |
| auth.serviceAccount.name | string | `""` |  |
| auth.serviceMonitor.annotations | object | `{}` |  |
| auth.serviceMonitor.enabled | bool | `false` |  |
| auth.serviceMonitor.endpoints[0].interval | string | `"30s"` |  |
| auth.serviceMonitor.endpoints[0].path | string | `"/metrics"` |  |
| auth.serviceMonitor.endpoints[0].port | string | `"metrics"` |  |
| auth.serviceMonitor.labels | object | `{}` |  |
| auth.tolerations | list | `[]` |  |
| csi.enabled | bool | `false` |  |
| csi.secrets | list | `[]` |  |
| csi.storageClass.allowVolumeExpansion | bool | `true` |  |
| csi.storageClass.allowedTopologies | list | `[]` |  |
| csi.storageClass.enabled | bool | `false` |  |
| csi.storageClass.parameters | object | `{}` |  |
| csi.storageClass.provisioner | string | `""` |  |
| csi.storageClass.reclaimPolicy | string | `"Delete"` |  |
| csi.storageClass.volumeBindingMode | string | `"WaitForFirstConsumer"` |  |
| csi.volumeSnapshotClass.deletionPolicy | string | `"Delete"` |  |
| csi.volumeSnapshotClass.driver | string | `""` |  |
| csi.volumeSnapshotClass.enabled | bool | `false` |  |
| csi.volumeSnapshotClass.parameters | object | `{}` |  |
| db.affinity | object | `{}` |  |
| db.autoscaling.enabled | bool | `false` |  |
| db.autoscaling.maxReplicas | int | `100` |  |
| db.autoscaling.minReplicas | int | `1` |  |
| db.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| db.config | object | `{}` |  |
| db.enabled | bool | `false` |  |
| db.environment.JWT_EXP | int | `3600` |  |
| db.environment.PGPORT | string | `"5432"` |  |
| db.environment.POSTGRES_HOST | string | `"/var/run/postgresql"` |  |
| db.environment.POSTGRES_PORT | string | `"5432"` |  |
| db.fullnameOverride | string | `""` |  |
| db.image.pullPolicy | string | `"IfNotPresent"` |  |
| db.image.repository | string | `"supabase/postgres"` |  |
| db.image.tag | string | `"latest"` |  |
| db.imagePullSecrets | list | `[]` |  |
| db.livenessProbe | object | `{}` |  |
| db.nameOverride | string | `""` |  |
| db.nodeSelector | object | `{}` |  |
| db.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| db.persistence.annotations | object | `{}` |  |
| db.persistence.class | string | `""` |  |
| db.persistence.enabled | bool | `true` |  |
| db.persistence.size | string | `"8Gi"` |  |
| db.persistence.storageClassName | string | `""` |  |
| db.podAnnotations | object | `{}` |  |
| db.podSecurityContext | object | `{}` |  |
| db.readinessProbe | object | `{}` |  |
| db.replicaCount | int | `1` |  |
| db.resources | object | `{}` |  |
| db.securityContext | object | `{}` |  |
| db.service.port | int | `5432` |  |
| db.service.type | string | `"ClusterIP"` |  |
| db.serviceAccount.annotations | object | `{}` |  |
| db.serviceAccount.create | bool | `true` |  |
| db.serviceAccount.name | string | `""` |  |
| db.tolerations | list | `[]` |  |
| externalSecrets.clusterSecretStore.enabled | bool | `false` |  |
| externalSecrets.clusterSecretStore.provider | object | `{}` |  |
| externalSecrets.enabled | bool | `false` |  |
| externalSecrets.secretStore.enabled | bool | `false` |  |
| externalSecrets.secretStore.provider | object | `{}` |  |
| externalSecrets.secrets | list | `[]` |  |
| functions.affinity | object | `{}` |  |
| functions.autoscaling.enabled | bool | `false` |  |
| functions.autoscaling.maxReplicas | int | `10` |  |
| functions.autoscaling.minReplicas | int | `2` |  |
| functions.autoscaling.targetCPUUtilizationPercentage | int | `70` |  |
| functions.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| functions.enabled | bool | `true` |  |
| functions.environment.DB_DRIVER | string | `"postgresql"` |  |
| functions.environment.DB_HOST | string | `"supabase-stack-postgresql"` |  |
| functions.environment.DB_PORT | int | `5432` |  |
| functions.environment.DB_SSL | string | `"disable"` |  |
| functions.environment.DB_USERNAME | string | `"supabase_functions_admin"` |  |
| functions.fullnameOverride | string | `""` |  |
| functions.image.pullPolicy | string | `"IfNotPresent"` |  |
| functions.image.repository | string | `"supabase/edge-runtime"` |  |
| functions.image.tag | string | `"v1.32.0"` |  |
| functions.imagePullSecrets | list | `[]` |  |
| functions.livenessProbe | object | `{}` |  |
| functions.nameOverride | string | `""` |  |
| functions.nodeSelector | object | `{}` |  |
| functions.podAnnotations | object | `{}` |  |
| functions.podDisruptionBudget.enabled | bool | `false` |  |
| functions.podDisruptionBudget.minAvailable | int | `1` |  |
| functions.podSecurityContext | object | `{}` |  |
| functions.readinessProbe | object | `{}` |  |
| functions.replicaCount | int | `1` |  |
| functions.resources.limits.cpu | string | `"500m"` |  |
| functions.resources.limits.memory | string | `"512Mi"` |  |
| functions.resources.requests.cpu | string | `"100m"` |  |
| functions.resources.requests.memory | string | `"128Mi"` |  |
| functions.securityContext | object | `{}` |  |
| functions.service.port | int | `9000` |  |
| functions.service.type | string | `"ClusterIP"` |  |
| functions.serviceAccount.annotations | object | `{}` |  |
| functions.serviceAccount.create | bool | `true` |  |
| functions.serviceAccount.name | string | `""` |  |
| functions.serviceMonitor.enabled | bool | `false` |  |
| functions.serviceMonitor.interval | string | `"30s"` |  |
| functions.serviceMonitor.path | string | `"/metrics"` |  |
| functions.serviceMonitor.port | string | `"http"` |  |
| functions.tolerations | list | `[]` |  |
| global.autoscaling.enabled | bool | `false` |  |
| global.autoscaling.maxReplicas | int | `3` |  |
| global.autoscaling.minReplicas | int | `1` |  |
| global.autoscaling.targetCPUUtilizationPercentage | int | `70` |  |
| global.podDisruptionBudget.enabled | bool | `false` |  |
| global.podDisruptionBudget.minAvailable | int | `1` |  |
| global.resources.limits.cpu | string | `"10m"` |  |
| global.resources.limits.memory | string | `"256Mi"` |  |
| global.resources.requests.cpu | string | `"10m"` |  |
| global.resources.requests.memory | string | `"128Mi"` |  |
| imgproxy.affinity | object | `{}` |  |
| imgproxy.autoscaling.enabled | bool | `false` |  |
| imgproxy.autoscaling.maxReplicas | int | `100` |  |
| imgproxy.autoscaling.minReplicas | int | `1` |  |
| imgproxy.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| imgproxy.enabled | bool | `true` |  |
| imgproxy.environment.IMGPROXY_BIND | string | `":5001"` |  |
| imgproxy.environment.IMGPROXY_ENABLE_WEBP_DETECTION | string | `"true"` |  |
| imgproxy.environment.IMGPROXY_LOCAL_FILESYSTEM_ROOT | string | `"/"` |  |
| imgproxy.environment.IMGPROXY_USE_ETAG | string | `"true"` |  |
| imgproxy.fullnameOverride | string | `""` |  |
| imgproxy.image.pullPolicy | string | `"IfNotPresent"` |  |
| imgproxy.image.repository | string | `"darthsim/imgproxy"` |  |
| imgproxy.image.tag | string | `"latest"` |  |
| imgproxy.imagePullSecrets | list | `[]` |  |
| imgproxy.livenessProbe | object | `{}` |  |
| imgproxy.nameOverride | string | `""` |  |
| imgproxy.nodeSelector | object | `{}` |  |
| imgproxy.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| imgproxy.persistence.annotations | object | `{}` |  |
| imgproxy.persistence.class | string | `""` |  |
| imgproxy.persistence.enabled | bool | `true` |  |
| imgproxy.persistence.size | string | `"10Gi"` |  |
| imgproxy.persistence.storageClassName | string | `""` |  |
| imgproxy.podAnnotations | object | `{}` |  |
| imgproxy.podSecurityContext | object | `{}` |  |
| imgproxy.readinessProbe | object | `{}` |  |
| imgproxy.replicaCount | int | `1` |  |
| imgproxy.resources | object | `{}` |  |
| imgproxy.securityContext | object | `{}` |  |
| imgproxy.service.port | int | `5001` |  |
| imgproxy.service.type | string | `"ClusterIP"` |  |
| imgproxy.serviceAccount.annotations | object | `{}` |  |
| imgproxy.serviceAccount.create | bool | `true` |  |
| imgproxy.serviceAccount.name | string | `""` |  |
| imgproxy.tolerations | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"supabase.local"` |  |
| ingress.hosts[0].paths[0].backend.service.name | string | `"supabase-kong"` |  |
| ingress.hosts[0].paths[0].backend.service.port.number | int | `8000` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls | list | `[]` |  |
| kong.admin.enabled | bool | `true` |  |
| kong.admin.http.containerPort | int | `8001` |  |
| kong.admin.http.enabled | bool | `true` |  |
| kong.admin.http.servicePort | int | `8001` |  |
| kong.admin.type | string | `"ClusterIP"` |  |
| kong.autoscaling.enabled | bool | `false` |  |
| kong.autoscaling.maxReplicas | int | `10` |  |
| kong.autoscaling.minReplicas | int | `2` |  |
| kong.autoscaling.targetCPUUtilizationPercentage | int | `70` |  |
| kong.dblessConfig.configMap | string | `"supabase-stack-kong-config"` |  |
| kong.enabled | bool | `true` |  |
| kong.environment.KONG_DECLARATIVE_CONFIG | string | `"/usr/local/kong/kong.yml"` |  |
| kong.environment.KONG_LOG_LEVEL | string | `"info"` |  |
| kong.environment.KONG_PLUGINS | string | `"bundled"` |  |
| kong.image.repository | string | `"kong"` |  |
| kong.image.tag | string | `"3.0"` |  |
| kong.proxy.enabled | bool | `true` |  |
| kong.proxy.http.containerPort | int | `8000` |  |
| kong.proxy.http.enabled | bool | `true` |  |
| kong.proxy.http.servicePort | int | `8000` |  |
| kong.proxy.tls.enabled | bool | `false` |  |
| kong.proxy.type | string | `"ClusterIP"` |  |
| kong.resources.limits.cpu | string | `"500m"` |  |
| kong.resources.limits.memory | string | `"512Mi"` |  |
| kong.resources.requests.cpu | string | `"100m"` |  |
| kong.resources.requests.memory | string | `"128Mi"` |  |
| kongOperator.adminApi.serviceName | string | `"kong-admin"` |  |
| kongOperator.adminApi.servicePort | int | `8001` |  |
| kongOperator.config.autoConfig | bool | `true` |  |
| kongOperator.config.cors.credentials | bool | `true` |  |
| kongOperator.config.cors.headers | string | `"Accept,Authorization,Cache-Control,Content-Type,DNT,If-Modified-Since,Keep-Alive,Origin,User-Agent,X-Requested-With,apikey,x-client-info"` |  |
| kongOperator.config.cors.methods | string | `"GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS"` |  |
| kongOperator.config.cors.origins | string | `"*"` |  |
| kongOperator.config.plugins[0] | string | `"request-transformer"` |  |
| kongOperator.config.plugins[1] | string | `"cors"` |  |
| kongOperator.config.plugins[2] | string | `"key-auth"` |  |
| kongOperator.config.plugins[3] | string | `"acl"` |  |
| kongOperator.config.plugins[4] | string | `"basic-auth"` |  |
| kongOperator.config.plugins[5] | string | `"rate-limiting"` |  |
| kongOperator.config.rateLimiting.requests | int | `1000` |  |
| kongOperator.config.rateLimiting.window | int | `60` |  |
| kongOperator.enabled | bool | `false` |  |
| kongOperator.serviceName | string | `"supabase-stack-kong-proxy"` |  |
| kongOperator.serviceNamespace | string | `"supabase"` |  |
| kongOperator.servicePort | int | `80` |  |
| legacySecret.analytics.apiKey | string | `"your-logflare-api-key-placeholder-change-in-production"` |  |
| legacySecret.analytics.csi.enabled | bool | `false` |  |
| legacySecret.analytics.csi.keys.apiKey | string | `"api-key"` |  |
| legacySecret.analytics.csi.secretPath | string | `"supabase/analytics"` |  |
| legacySecret.analytics.external.enabled | bool | `false` |  |
| legacySecret.analytics.external.remoteRefs.apiKey | string | `"supabase/analytics/api-key"` |  |
| legacySecret.analytics.external.secretStore | string | `""` |  |
| legacySecret.analytics.secretRef | string | `""` |  |
| legacySecret.analytics.secretRefKey.apiKey | string | `"apiKey"` |  |
| legacySecret.dashboard.csi.enabled | bool | `false` |  |
| legacySecret.dashboard.csi.keys.password | string | `"password"` |  |
| legacySecret.dashboard.csi.keys.username | string | `"username"` |  |
| legacySecret.dashboard.csi.secretPath | string | `"supabase/dashboard"` |  |
| legacySecret.dashboard.external.enabled | bool | `false` |  |
| legacySecret.dashboard.external.remoteRefs.password | string | `"supabase/dashboard/password"` |  |
| legacySecret.dashboard.external.remoteRefs.username | string | `"supabase/dashboard/username"` |  |
| legacySecret.dashboard.external.secretStore | string | `""` |  |
| legacySecret.dashboard.password | string | `""` |  |
| legacySecret.dashboard.secretRef | string | `""` |  |
| legacySecret.dashboard.secretRefKey.password | string | `"password"` |  |
| legacySecret.dashboard.secretRefKey.username | string | `"username"` |  |
| legacySecret.dashboard.username | string | `""` |  |
| legacySecret.db.csi.enabled | bool | `false` |  |
| legacySecret.db.csi.keys.database | string | `"database"` |  |
| legacySecret.db.csi.keys.password | string | `"password"` |  |
| legacySecret.db.csi.keys.username | string | `"username"` |  |
| legacySecret.db.csi.secretPath | string | `"supabase/database"` |  |
| legacySecret.db.database | string | `"postgres"` |  |
| legacySecret.db.external.enabled | bool | `false` |  |
| legacySecret.db.external.remoteRefs.database | string | `"supabase/db/database"` |  |
| legacySecret.db.external.remoteRefs.password | string | `"supabase/db/password"` |  |
| legacySecret.db.external.remoteRefs.username | string | `"supabase/db/username"` |  |
| legacySecret.db.external.secretStore | string | `""` |  |
| legacySecret.db.password | string | `"supabase"` |  |
| legacySecret.db.secretRef | string | `""` |  |
| legacySecret.db.secretRefKey.database | string | `"database"` |  |
| legacySecret.db.secretRefKey.password | string | `"password"` |  |
| legacySecret.db.secretRefKey.username | string | `"username"` |  |
| legacySecret.db.username | string | `"postgres"` |  |
<!-- pragma: allowlist secret -->
| legacySecret.jwt.anonKey | string | `"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"` |  |
| legacySecret.jwt.csi.enabled | bool | `false` |  |
| legacySecret.jwt.csi.keys.anonKey | string | `"anon-key"` |  |
| legacySecret.jwt.csi.keys.secret | string | `"jwt-secret"` |  |
| legacySecret.jwt.csi.keys.serviceKey | string | `"service-key"` |  |
| legacySecret.jwt.csi.secretPath | string | `"supabase/jwt"` |  |
| legacySecret.jwt.external.enabled | bool | `false` |  |
| legacySecret.jwt.external.remoteRefs.anonKey | string | `"supabase/jwt/anon-key"` |  |
| legacySecret.jwt.external.remoteRefs.secret | string | `"supabase/jwt/secret"` |  |
| legacySecret.jwt.external.remoteRefs.serviceKey | string | `"supabase/jwt/service-key"` |  |
| legacySecret.jwt.external.secretStore | string | `""` |  |
<!-- pragma: allowlist secret -->
| legacySecret.jwt.secret | string | `"abcdefghijklmnopqrstuvwxyz123456789"` |  |
| legacySecret.jwt.secretRef | string | `""` |  |
| legacySecret.jwt.secretRefKey.anonKey | string | `"anonKey"` |  |
<!-- pragma: allowlist secret -->
| legacySecret.jwt.secretRefKey.secret | string | `"secret"` |  |
| legacySecret.jwt.secretRefKey.serviceKey | string | `"serviceKey"` |  |
<!-- pragma: allowlist secret -->
| legacySecret.jwt.serviceKey | string | `"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU"` |  |
| legacySecret.s3.accessKey | string | `""` |  |
| legacySecret.s3.csi.enabled | bool | `false` |  |
| legacySecret.s3.csi.keys.accessKey | string | `"access-key"` |  |
| legacySecret.s3.csi.keys.keyId | string | `"key-id"` |  |
| legacySecret.s3.csi.secretPath | string | `"supabase/s3"` |  |
| legacySecret.s3.external.enabled | bool | `false` |  |
| legacySecret.s3.external.remoteRefs.accessKey | string | `"supabase/s3/access-key"` |  |
| legacySecret.s3.external.remoteRefs.keyId | string | `"supabase/s3/key-id"` |  |
| legacySecret.s3.external.secretStore | string | `""` |  |
| legacySecret.s3.keyId | string | `""` |  |
| legacySecret.s3.secretRef | string | `""` |  |
| legacySecret.s3.secretRefKey.accessKey | string | `"accessKey"` |  |
| legacySecret.s3.secretRefKey.keyId | string | `"keyId"` |  |
| legacySecret.smtp.csi.enabled | bool | `false` |  |
| legacySecret.smtp.csi.keys.password | string | `"password"` |  |
| legacySecret.smtp.csi.keys.username | string | `"username"` |  |
| legacySecret.smtp.csi.secretPath | string | `"supabase/smtp"` |  |
| legacySecret.smtp.external.enabled | bool | `false` |  |
| legacySecret.smtp.external.remoteRefs.password | string | `"supabase/smtp/password"` |  |
| legacySecret.smtp.external.remoteRefs.username | string | `"supabase/smtp/username"` |  |
| legacySecret.smtp.external.secretStore | string | `""` |  |
| legacySecret.smtp.password | string | `"smtp-password"` |  |
| legacySecret.smtp.secretRef | string | `""` |  |
| legacySecret.smtp.secretRefKey.password | string | `"password"` |  |
| legacySecret.smtp.secretRefKey.username | string | `"username"` |  |
| legacySecret.smtp.username | string | `"noreply@supabase.local"` |  |
| legacySecret.strategy | string | `""` |  |
| meta.affinity | object | `{}` |  |
| meta.autoscaling.enabled | bool | `false` |  |
| meta.autoscaling.maxReplicas | int | `10` |  |
| meta.autoscaling.minReplicas | int | `2` |  |
| meta.autoscaling.targetCPUUtilizationPercentage | int | `70` |  |
| meta.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| meta.enabled | bool | `true` |  |
| meta.environment.DB_DRIVER | string | `"postgres"` |  |
| meta.environment.DB_HOST | string | `"supabase-stack-postgresql"` |  |
| meta.environment.DB_PORT | int | `5432` |  |
| meta.environment.DB_SSL | string | `"disable"` |  |
| meta.environment.DB_USER | string | `"supabase_admin"` |  |
| meta.environment.PG_META_PORT | string | `"8080"` |  |
| meta.fullnameOverride | string | `""` |  |
| meta.image.pullPolicy | string | `"IfNotPresent"` |  |
| meta.image.repository | string | `"supabase/postgres-meta"` |  |
| meta.image.tag | string | `"v0.86.1"` |  |
| meta.imagePullSecrets | list | `[]` |  |
| meta.livenessProbe | object | `{}` |  |
| meta.nameOverride | string | `""` |  |
| meta.nodeSelector | object | `{}` |  |
| meta.podAnnotations | object | `{}` |  |
| meta.podDisruptionBudget.enabled | bool | `false` |  |
| meta.podDisruptionBudget.minAvailable | int | `1` |  |
| meta.podSecurityContext | object | `{}` |  |
| meta.readinessProbe | object | `{}` |  |
| meta.replicaCount | int | `1` |  |
| meta.resources.limits.cpu | string | `"1000m"` |  |
| meta.resources.limits.memory | string | `"1Gi"` |  |
| meta.resources.requests.cpu | string | `"500m"` |  |
| meta.resources.requests.memory | string | `"512Mi"` |  |
| meta.securityContext | object | `{}` |  |
| meta.service.port | int | `8080` |  |
| meta.service.type | string | `"ClusterIP"` |  |
| meta.serviceAccount.annotations | object | `{}` |  |
| meta.serviceAccount.create | bool | `true` |  |
| meta.serviceAccount.name | string | `""` |  |
| meta.serviceMonitor.enabled | bool | `false` |  |
| meta.serviceMonitor.interval | string | `"30s"` |  |
| meta.serviceMonitor.path | string | `"/metrics"` |  |
| meta.serviceMonitor.port | string | `"http"` |  |
| meta.serviceMonitor.scrapeTimeout | string | `"10s"` |  |
| meta.tolerations | list | `[]` |  |
| minio.auth.rootPassword | string | `"minio123"` |  |
| minio.auth.rootUser | string | `"minio"` |  |
| minio.defaultBuckets | string | `"supabase-storage"` |  |
| minio.enabled | bool | `false` |  |
| minio.metrics.enabled | bool | `true` |  |
| minio.metrics.serviceMonitor.enabled | bool | `false` |  |
| minio.networkPolicy.allowExternal | bool | `true` |  |
| minio.networkPolicy.enabled | bool | `false` |  |
| minio.persistence.enabled | bool | `true` |  |
| minio.persistence.size | string | `"10Gi"` |  |
| minio.podDisruptionBudget.create | bool | `true` |  |
| minio.podDisruptionBudget.minAvailable | int | `1` |  |
| minio.resources.limits.cpu | string | `"10m"` |  |
| minio.resources.limits.memory | string | `"512Mi"` |  |
| minio.resources.requests.cpu | string | `"10m"` |  |
| minio.resources.requests.memory | string | `"256Mi"` |  |
| minio.service.ports.api | int | `9000` |  |
| minio.service.ports.console | int | `9001` |  |
| minio.service.type | string | `"ClusterIP"` |  |
| networkPolicy.cilium.egress | list | `[]` |  |
| networkPolicy.cilium.enabled | bool | `false` |  |
| networkPolicy.cilium.ingress | list | `[]` |  |
| networkPolicy.egress.namespaceSelector | object | `{}` |  |
| networkPolicy.egress.podSelector | object | `{}` |  |
| networkPolicy.egress.ports | list | `[]` |  |
| networkPolicy.enabled | bool | `false` |  |
| networkPolicy.ingress.namespaceSelector | object | `{}` |  |
| networkPolicy.ingress.podSelector | object | `{}` |  |
| networkPolicy.ingress.ports | list | `[]` |  |
| podDisruptionBudget.enabled | bool | `false` |  |
| podDisruptionBudget.minAvailable | int | `1` |  |
| podMonitor.annotations | object | `{}` |  |
| podMonitor.create | bool | `true` |  |
| podMonitor.enabled | bool | `false` |  |
| podMonitor.endpoints[0].interval | string | `"30s"` |  |
| podMonitor.endpoints[0].path | string | `"/metrics"` |  |
| podMonitor.endpoints[0].port | string | `"metrics"` |  |
| podMonitor.jobLabel | string | `""` |  |
| podMonitor.labels | object | `{}` |  |
| podMonitor.podTargetLabels | list | `[]` |  |
| podMonitor.selector | object | `{}` |  |
| postgresql.auth.database | string | `"postgres"` |  |
| postgresql.auth.enablePostgresUser | bool | `true` |  |
| postgresql.auth.password | string | `"supabase"` |  |
| postgresql.auth.postgresPassword | string | `"supabase"` |  |
| postgresql.auth.username | string | `"supabase"` |  |
| postgresql.enabled | bool | `true` |  |
| postgresql.metrics.enabled | bool | `true` |  |
| postgresql.metrics.serviceMonitor.enabled | bool | `false` |  |
<!-- markdownlint-disable MD013 -->
| postgresql.primary.initdb.scripts."init.sql" | string | `"-- Create Supabase specific users and schemas\nCREATE USER supabase_auth_admin WITH PASSWORD 'supabase';\nCREATE USER supabase_functions_admin WITH PASSWORD 'supabase';\nCREATE USER supabase_admin WITH PASSWORD 'supabase';\nCREATE SCHEMA IF NOT EXISTS _analytics;\nGRANT ALL ON SCHEMA _analytics TO supabase_admin;\n"` | |
<!-- markdownlint-enable MD013 -->
| postgresql.primary.persistence.enabled | bool | `true` |  |
| postgresql.primary.persistence.size | string | `"8Gi"` |  |
| postgresql.primary.resources.limits.cpu | string | `"50m"` |  |
| postgresql.primary.resources.limits.memory | string | `"256Mi"` |  |
| postgresql.primary.resources.requests.cpu | string | `"10m"` |  |
| postgresql.primary.resources.requests.memory | string | `"128Mi"` |  |
| prometheus.additionalAlertRelabelConfigs | list | `[]` |  |
| prometheus.additionalScrapeConfigs | list | `[]` |  |
| prometheus.additionalScrapeConfigsExternal.basicAuth | object | `{}` |  |
| prometheus.additionalScrapeConfigsExternal.enabled | bool | `false` |  |
| prometheus.additionalScrapeConfigsExternal.metricsPath | string | `"/metrics"` |  |
| prometheus.additionalScrapeConfigsExternal.scheme | string | `"http"` |  |
| prometheus.additionalScrapeConfigsExternal.scrapeInterval | string | `"30s"` |  |
| prometheus.additionalScrapeConfigsExternal.targets | list | `[]` |  |
| prometheus.additionalScrapeConfigsExternal.tlsConfig | object | `{}` |  |
| prometheus.globalRelabelConfigs | list | `[]` |  |
| prometheusRule.additionalPrometheusRules | object | `{}` |  |
| prometheusRule.additionalRuleGroups | list | `[]` |  |
| prometheusRule.additionalRules | list | `[]` |  |
| prometheusRule.annotations | object | `{}` |  |
| prometheusRule.customRules | object | `{}` |  |
| prometheusRule.enabled | bool | `false` |  |
| prometheusRule.labels | object | `{}` |  |
| rbac.additionalRules | list | `[]` |  |
| rbac.annotations | object | `{}` |  |
| rbac.create | bool | `true` |  |
| realtime.affinity | object | `{}` |  |
| realtime.autoscaling.enabled | bool | `false` |  |
| realtime.autoscaling.maxReplicas | int | `5` |  |
| realtime.autoscaling.minReplicas | int | `2` |  |
| realtime.autoscaling.targetCPUUtilizationPercentage | int | `70` |  |
| realtime.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| realtime.enabled | bool | `true` |  |
| realtime.environment.APP_NAME | string | `"realtime"` |  |
| realtime.environment.DB_AFTER_CONNECT_QUERY | string | `"SET search_path TO _realtime"` |  |
| realtime.environment.DB_ENC_KEY | string | `"supabaserealtime"` |  |
| realtime.environment.DB_HOST | string | `"supabase-stack-postgresql"` |  |
| realtime.environment.DB_PORT | int | `5432` |  |
| realtime.environment.DB_SSL | string | `"false"` |  |
| realtime.environment.DB_USER | string | `"supabase_admin"` |  |
| realtime.environment.DNS_NODES | string | `"''"` |  |
| realtime.environment.ENABLE_TAILSCALE | string | `"false"` |  |
| realtime.environment.ERL_AFLAGS | string | `"-proto_dist inet_tcp"` |  |
| realtime.environment.FLY_ALLOC_ID | string | `"fly123"` |  |
| realtime.environment.FLY_APP_NAME | string | `"realtime"` |  |
| realtime.environment.PORT | string | `"4000"` |  |
<!-- pragma: allowlist secret -->
| realtime.environment.SECRET_KEY_BASE | string | `"UpNVntn3cDxHJpq99YMc1T1AQgQpc8kfYTuRgBiYa15BLrx8etQoXz3gZv1/u2oq"` |  |
| realtime.fullnameOverride | string | `""` |  |
| realtime.image.pullPolicy | string | `"IfNotPresent"` |  |
| realtime.image.repository | string | `"supabase/realtime"` |  |
| realtime.image.tag | string | `"latest"` |  |
| realtime.imagePullSecrets | list | `[]` |  |
| realtime.livenessProbe | object | `{}` |  |
| realtime.nameOverride | string | `""` |  |
| realtime.nodeSelector | object | `{}` |  |
| realtime.podAnnotations | object | `{}` |  |
| realtime.podDisruptionBudget.enabled | bool | `false` |  |
| realtime.podDisruptionBudget.minAvailable | int | `1` |  |
| realtime.podSecurityContext | object | `{}` |  |
| realtime.readinessProbe | object | `{}` |  |
| realtime.resources.limits.cpu | string | `"300m"` |  |
| realtime.resources.limits.memory | string | `"512Mi"` |  |
| realtime.resources.requests.cpu | string | `"100m"` |  |
| realtime.resources.requests.memory | string | `"256Mi"` |  |
| realtime.securityContext | object | `{}` |  |
| realtime.service.port | int | `4000` |  |
| realtime.service.type | string | `"ClusterIP"` |  |
| realtime.serviceAccount.annotations | object | `{}` |  |
| realtime.serviceAccount.create | bool | `true` |  |
| realtime.serviceAccount.name | string | `""` |  |
| realtime.serviceMonitor.enabled | bool | `false` |  |
| realtime.serviceMonitor.interval | string | `"30s"` |  |
| realtime.serviceMonitor.path | string | `"/metrics"` |  |
| realtime.serviceMonitor.port | string | `"http"` |  |
| realtime.serviceMonitor.scrapeTimeout | string | `"10s"` |  |
| realtime.tolerations | list | `[]` |  |
| rest.affinity | object | `{}` |  |
| rest.autoscaling.enabled | bool | `false` |  |
| rest.autoscaling.maxReplicas | int | `10` |  |
| rest.autoscaling.minReplicas | int | `2` |  |
| rest.autoscaling.targetCPUUtilizationPercentage | int | `70` |  |
| rest.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| rest.enabled | bool | `true` |  |
| rest.environment.DB_DRIVER | string | `"postgres"` |  |
| rest.environment.DB_HOST | string | `"supabase-stack-postgresql"` |  |
| rest.environment.DB_PORT | int | `5432` |  |
| rest.environment.DB_SSL | string | `"false"` |  |
| rest.environment.DB_USER | string | `"authenticator"` |  |
| rest.environment.PGRST_APP_SETTINGS_JWT_EXP | int | `3600` |  |
| rest.environment.PGRST_DB_ANON_ROLE | string | `"anon"` |  |
| rest.environment.PGRST_DB_SCHEMAS | string | `"public,storage,graphql_public"` |  |
| rest.environment.PGRST_DB_USE_LEGACY_GUCS | bool | `false` |  |
| rest.fullnameOverride | string | `""` |  |
| rest.image.pullPolicy | string | `"IfNotPresent"` |  |
| rest.image.repository | string | `"postgrest/postgrest"` |  |
| rest.image.tag | string | `"latest"` |  |
| rest.imagePullSecrets | list | `[]` |  |
| rest.livenessProbe | object | `{}` |  |
| rest.nameOverride | string | `""` |  |
| rest.nodeSelector | object | `{}` |  |
| rest.podAnnotations | object | `{}` |  |
| rest.podDisruptionBudget.enabled | bool | `false` |  |
| rest.podDisruptionBudget.minAvailable | int | `1` |  |
| rest.podSecurityContext | object | `{}` |  |
| rest.readinessProbe | object | `{}` |  |
| rest.resources.limits.cpu | string | `"500m"` |  |
| rest.resources.limits.memory | string | `"1Gi"` |  |
| rest.resources.requests.cpu | string | `"100m"` |  |
| rest.resources.requests.memory | string | `"256Mi"` |  |
| rest.securityContext | object | `{}` |  |
| rest.service.port | int | `3000` |  |
| rest.service.type | string | `"ClusterIP"` |  |
| rest.serviceAccount.annotations | object | `{}` |  |
| rest.serviceAccount.create | bool | `true` |  |
| rest.serviceAccount.name | string | `""` |  |
| rest.serviceMonitor.enabled | bool | `false` |  |
| rest.serviceMonitor.interval | string | `"30s"` |  |
| rest.serviceMonitor.path | string | `"/metrics"` |  |
| rest.serviceMonitor.port | string | `"http"` |  |
| rest.serviceMonitor.scrapeTimeout | string | `"10s"` |  |
| rest.tolerations | list | `[]` |  |
| secret.additional | object | `{}` |  |
| secret.annotations | object | `{}` |  |
| secret.create | bool | `true` |  |
| secret.data | object | `{}` |  |
| secret.stringData | object | `{}` |  |
| secret.type | string | `"Opaque"` |  |
| secrets.global.csi.aws.region | string | `"us-west-2"` |  |
| secrets.global.csi.aws.roleArn | string | `""` |  |
| secrets.global.csi.aws.secretsManagerEndpoint | string | `""` |  |
| secrets.global.csi.azure.keyvaultName | string | `""` |  |
| secrets.global.csi.azure.tenantId | string | `""` |  |
| secrets.global.csi.enabled | bool | `false` |  |
| secrets.global.csi.gcp.projectId | string | `""` |  |
| secrets.global.csi.provider | string | `"vault"` |  |
| secrets.global.csi.vault.address | string | `"https://vault.example.com"` |  |
| secrets.global.csi.vault.authPath | string | `"auth/kubernetes"` |  |
| secrets.global.csi.vault.role | string | `"supabase"` |  |
| secrets.global.csi.vault.secretPath | string | `"secret/data/supabase"` |  |
| secrets.global.external.clusterSecretStore.enabled | bool | `false` |  |
| secrets.global.external.clusterSecretStore.provider | object | `{}` |  |
| secrets.global.external.enabled | bool | `false` |  |
| secrets.global.external.refreshInterval | string | `"1h"` |  |
| secrets.global.external.secretStore.kind | string | `"SecretStore"` |  |
| secrets.global.external.secretStore.name | string | `""` |  |
| secrets.global.external.secretStore.provider | object | `{}` |  |
| secrets.global.kubernetes.create | bool | `true` |  |
| secrets.global.kubernetes.existingSecrets | object | `{}` |  |
| secrets.global.strategy | string | `"kubernetes"` |  |
| secrets.microservices | string | `nil` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.imagePullSecrets | list | `[]` |  |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.annotations | object | `{}` |  |
| serviceMonitor.create | bool | `true` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.endpoints[0].interval | string | `"30s"` |  |
| serviceMonitor.endpoints[0].path | string | `"/metrics"` |  |
| serviceMonitor.endpoints[0].port | string | `"metrics"` |  |
| serviceMonitor.jobLabel | string | `""` |  |
| serviceMonitor.labels | object | `{}` |  |
| serviceMonitor.podTargetLabels | list | `[]` |  |
| serviceMonitor.selector | object | `{}` |  |
| serviceMonitor.targetLabels | list | `[]` |  |
| storage.affinity | object | `{}` |  |
| storage.autoscaling.enabled | bool | `false` |  |
| storage.autoscaling.maxReplicas | int | `10` |  |
| storage.autoscaling.minReplicas | int | `2` |  |
| storage.autoscaling.targetCPUUtilizationPercentage | int | `70` |  |
| storage.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| storage.enabled | bool | `true` |  |
| storage.environment.DB_DRIVER | string | `"postgres"` |  |
| storage.environment.DB_HOST | string | `"supabase-stack-postgresql"` |  |
| storage.environment.DB_PORT | int | `5432` |  |
| storage.environment.DB_SSL | string | `"disable"` |  |
| storage.environment.DB_USER | string | `"supabase_storage_admin"` |  |
| storage.environment.FILE_SIZE_LIMIT | string | `"52428800"` |  |
| storage.environment.FILE_STORAGE_BACKEND_PATH | string | `"/var/lib/storage"` |  |
| storage.environment.GLOBAL_S3_BUCKET | string | `"stub"` |  |
| storage.environment.PGOPTIONS | string | `"-c search_path=storage,public"` |  |
| storage.environment.REGION | string | `"stub"` |  |
| storage.environment.STORAGE_BACKEND | string | `"file"` |  |
| storage.environment.TENANT_ID | string | `"stub"` |  |
| storage.fullnameOverride | string | `""` |  |
| storage.image.pullPolicy | string | `"IfNotPresent"` |  |
| storage.image.repository | string | `"supabase/storage-api"` |  |
| storage.image.tag | string | `"latest"` |  |
| storage.imagePullSecrets | list | `[]` |  |
| storage.livenessProbe | object | `{}` |  |
| storage.nameOverride | string | `""` |  |
| storage.nodeSelector | object | `{}` |  |
| storage.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| storage.persistence.annotations | object | `{}` |  |
| storage.persistence.class | string | `""` |  |
| storage.persistence.enabled | bool | `true` |  |
| storage.persistence.size | string | `"10Gi"` |  |
| storage.persistence.storageClassName | string | `""` |  |
| storage.podAnnotations | object | `{}` |  |
| storage.podDisruptionBudget.enabled | bool | `false` |  |
| storage.podDisruptionBudget.minAvailable | int | `1` |  |
| storage.podSecurityContext | object | `{}` |  |
| storage.readinessProbe | object | `{}` |  |
| storage.replicaCount | int | `1` |  |
| storage.resources.limits.cpu | string | `"1000m"` |  |
| storage.resources.limits.memory | string | `"1Gi"` |  |
| storage.resources.requests.cpu | string | `"500m"` |  |
| storage.resources.requests.memory | string | `"512Mi"` |  |
| storage.securityContext | object | `{}` |  |
| storage.service.port | int | `5000` |  |
| storage.service.type | string | `"ClusterIP"` |  |
| storage.serviceAccount.annotations | object | `{}` |  |
| storage.serviceAccount.create | bool | `true` |  |
| storage.serviceAccount.name | string | `""` |  |
| storage.serviceMonitor.enabled | bool | `false` |  |
| storage.serviceMonitor.interval | string | `"30s"` |  |
| storage.serviceMonitor.path | string | `"/metrics"` |  |
| storage.serviceMonitor.port | string | `"http"` |  |
| storage.serviceMonitor.scrapeTimeout | string | `"10s"` |  |
| storage.tolerations | list | `[]` |  |
| studio.affinity | object | `{}` |  |
| studio.autoscaling.enabled | bool | `false` |  |
| studio.autoscaling.maxReplicas | int | `10` |  |
| studio.autoscaling.minReplicas | int | `2` |  |
| studio.autoscaling.targetCPUUtilizationPercentage | int | `70` |  |
| studio.enabled | bool | `true` |  |
| studio.environment.NEXT_ANALYTICS_BACKEND_PROVIDER | string | `"postgres"` |  |
| studio.environment.NEXT_PUBLIC_ENABLE_LOGS | string | `"true"` |  |
| studio.environment.STUDIO_DEFAULT_ORGANIZATION | string | `"Default Organization"` |  |
| studio.environment.STUDIO_DEFAULT_PROJECT | string | `"Default Project"` |  |
| studio.environment.STUDIO_PORT | string | `"3000"` |  |
| studio.environment.SUPABASE_PUBLIC_URL | string | `"http://supabase-stack-kong-proxy"` |  |
| studio.fullnameOverride | string | `""` |  |
| studio.image.pullPolicy | string | `"IfNotPresent"` |  |
| studio.image.repository | string | `"supabase/studio"` |  |
| studio.image.tag | string | `"latest"` |  |
| studio.imagePullSecrets | list | `[]` |  |
| studio.livenessProbe | object | `{}` |  |
| studio.nameOverride | string | `""` |  |
| studio.nodeSelector | object | `{}` |  |
| studio.podAnnotations | object | `{}` |  |
| studio.podDisruptionBudget.enabled | bool | `false` |  |
| studio.podDisruptionBudget.minAvailable | int | `1` |  |
| studio.podSecurityContext | object | `{}` |  |
| studio.readinessProbe | object | `{}` |  |
| studio.replicaCount | int | `1` |  |
| studio.resources.limits.cpu | string | `"10m"` |  |
| studio.resources.limits.memory | string | `"256Mi"` |  |
| studio.resources.requests.cpu | string | `"10m"` |  |
| studio.resources.requests.memory | string | `"128Mi"` |  |
| studio.securityContext | object | `{}` |  |
| studio.service.port | int | `3000` |  |
| studio.service.type | string | `"ClusterIP"` |  |
| studio.serviceAccount.annotations | object | `{}` |  |
| studio.serviceAccount.create | bool | `true` |  |
| studio.serviceAccount.name | string | `""` |  |
| studio.serviceMonitor.enabled | bool | `false` |  |
| studio.serviceMonitor.interval | string | `"30s"` |  |
| studio.serviceMonitor.labels | object | `{}` |  |
| studio.serviceMonitor.path | string | `"/metrics"` |  |
| studio.serviceMonitor.scrapeTimeout | string | `"10s"` |  |
| studio.tolerations | list | `[]` |  |
| vector.customConfig.api.address | string | `"127.0.0.1:8686"` |  |
| vector.customConfig.api.enabled | bool | `true` |  |
| vector.customConfig.api.playground | bool | `false` |  |
| vector.customConfig.data_dir | string | `"/vector-data-dir"` |  |
| vector.customConfig.sinks.console.encoding.codec | string | `"json"` |  |
| vector.customConfig.sinks.console.inputs[0] | string | `"parse_logs"` |  |
| vector.customConfig.sinks.console.type | string | `"console"` |  |
| vector.customConfig.sources.supabase_logs.namespace_labels[0] | string | `"supabase"` |  |
| vector.customConfig.sources.supabase_logs.type | string | `"kubernetes_logs"` |  |
| vector.customConfig.transforms.parse_logs.inputs[0] | string | `"supabase_logs"` |  |
| vector.customConfig.transforms.parse_logs.source | string | `". = parse_json!(.message)\n"` |  |
| vector.customConfig.transforms.parse_logs.type | string | `"remap"` |  |
| vector.enabled | bool | `true` |  |
| vector.persistence.enabled | bool | `true` |  |
| vector.persistence.size | string | `"10Gi"` |  |
| vector.persistence.storageClassName | string | `""` |  |
| vector.podDisruptionBudget.enabled | bool | `false` |  |
| vector.podDisruptionBudget.minAvailable | int | `1` |  |
| vector.rbac.enabled | bool | `true` |  |
| vector.resources.limits.cpu | string | `"10m"` |  |
| vector.resources.limits.memory | string | `"256Mi"` |  |
| vector.resources.requests.cpu | string | `"10m"` |  |
| vector.resources.requests.memory | string | `"128Mi"` |  |
| vector.role | string | `"Agent"` |  |
| vector.service.enabled | bool | `true` |  |
| vector.service.ports[0].name | string | `"api"` |  |
| vector.service.ports[0].port | int | `8686` |  |
| vector.service.ports[0].protocol | string | `"TCP"` |  |
| vector.service.type | string | `"ClusterIP"` |  |
| vector.serviceMonitor.enabled | bool | `false` |  |

## Examples

See the [examples](./examples/) directory for various configuration scenarios:

- **Kong Operator Integration**: Complete setup with Kong Gateway
- **External Secrets**: Using external secret management
- **Production Configuration**: Production-ready settings

## Upgrading

```bash
# Upgrade to latest version
helm upgrade my-supabase ./charts/supabase

# Upgrade with new values
helm upgrade my-supabase ./charts/supabase -f my-values.yaml
```

## Uninstalling

```bash
# Uninstall the release
helm uninstall my-supabase

# Clean up PVCs (if needed)
kubectl delete pvc -l app.kubernetes.io/instance=my-supabase
```

## Troubleshooting

### Common Issues

1. **Kong CRDs not found**: Ensure Kong Operator is installed first
2. **Secrets not found**: Check secret configuration in values.yaml
3. **Pods not starting**: Check resource limits and node capacity

### Getting Help

- Check the [documentation](./docs/)
- Review [examples](./examples/)
- Open an issue on GitHub
