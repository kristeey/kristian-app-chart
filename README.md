# Kristian App Helm Chart

[![Release Charts](https://github.com/kristeey/kristian-app-chart/actions/workflows/release.yaml/badge.svg)](https://github.com/kristeey/kristian-app-chart/actions/workflows/release.yaml)
[![Lint and Test Charts](https://github.com/kristeey/kristian-app-chart/actions/workflows/lint-test.yaml/badge.svg)](https://github.com/kristeey/kristian-app-chart/actions/workflows/test.yaml)
[![Unit Tests](https://github.com/kristeey/kristian-app-chart/actions/workflows/unittest.yaml/badge.svg)](https://github.com/kristeey/kristian-app-chart/actions/workflows/unittest.yaml)

Everything you need to run an application smoothly in Kubernetes.

## TLDR;

```bash
helm repo add kristian-app https://kristeey.github.io/kristian-app-chart
helm repo update
helm install my-app kristian-app/kristian-app
```

## Introduction

This Helm chart provides a production-ready template for deploying applications to Kubernetes. It includes:

- 🚀 **Deployment** with configurable replicas, probes, and security contexts
- 🔄 **Horizontal Pod Autoscaler** for automatic scaling
- 🌐 **Ingress** with support for public/private classes and DNS management
- 🔐 **Service Account** with workload identity support
- 💾 **Pod Disruption Budget** for high availability
- 📊 **Service** for internal communication
- ⚙️ **Environment variables** from values and Azure Key Vault
- 🏷️ **Custom labels and annotations** for deployment and pods

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+

## Installing the Chart

### Add the Helm repository

```bash
helm repo add kristian-app https://kristeey.github.io/kristian-app-chart
helm repo update
```

### Install the chart

```bash
helm install my-app kristian-app/kristian-app \
  --set image.repo=my-registry/my-app \
  --set image.tag=1.0.0 \
  --set team=my-team \
  --set product=my-product
```

### Install with custom values

```bash
helm install my-app kristian-app/kristian-app -f my-values.yaml
```

## Uninstalling the Chart

```bash
helm uninstall my-app
```

## Configuration

### Basic Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nameOverride` | Override the chart name | `""` |
| `fullNameOverride` | Override the full name | `""` |
| `environment` | Environment (dev/stage/prod) | `dev` |
| `team` | Team name | `"kristian-app-team"` |
| `product` | Product name | `"kristian-app-product"` |
| `domain` | Application domain | `"kristian-app.com"` |

### Image Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repo` | Image repository | `"gcr.io/google-samples/hello-app"` |
| `image.tag` | Image tag | `"1.0"` |
| `image.port` | Container port | `8080` |

### Resource Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `resources.memory` | Memory request | `256Mi` |
| `resources.cpu` | CPU request | `100m` |
| `resources.memLimitOverride` | Memory limit override | Same as `resources.memory` |

### Autoscaling

| Parameter | Description | Default |
|-----------|-------------|---------|
| `autoscaling.enabled` | Enable HPA | `true` |
| `autoscaling.minReplicas` | Minimum replicas | `2` |
| `autoscaling.maxReplicas` | Maximum replicas | `10` |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU % | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory % | Not set |

### Ingress

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `true` |
| `ingress.public` | Use public ingress class | `false` |
| `ingress.enableDnsRecord` | Create DNS record | `true` |
| `ingress.ingressClassOverride` | Override ingress class | `""` |
| `ingress.paths` | Ingress paths configuration | See `values.yaml` |

### Probes

| Parameter | Description | Default |
|-----------|-------------|---------|
| `containers.startupProbe.enabled` | Enable startup probe | `true` |
| `containers.readinessProbe.enabled` | Enable readiness probe | `false` |
| `containers.livenessProbe.enabled` | Enable liveness probe | `true` |

### Service Account

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.name` | Service account name | Defaults to chart name |

### Pod Disruption Budget

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podDisruptionBudget.enabled` | Enable PDB | `true` |
| `podDisruptionBudget.minAvailable` | Minimum available pods | `1` |

### Environment Variables

#### Static Environment Variables

```yaml
envVars:
  variables:
    - name: MY_ENVIRONMENT
      value: production
    - name: MY_NODE_NAME
      valueFrom:
        fieldRef:
          field: spec.nodeName
```

#### Azure Key Vault Secrets (NOT WORKING ATM, COMMING SOON)

```yaml
envVars:
  secrets:
    - envVarName: MY_SECRET
      keyVaultName: my-vault
      keyVaultSecret: my-secret-name
      type: secret
```

### Custom Labels and Annotations

```yaml
additionalLabels:
  deployment:
    custom-label: "value"
  pod:
    azure.workload.identity/use: "true"

additionalAnnotations:
  deployment:
    custom-annotation: "value"
  pod:
    prometheus.io/scrape: "true"
```

## Examples

### Basic Web Application

```yaml
image:
  repo: nginx
  tag: "1.25"
  port: 80

resources:
  memory: 128Mi
  cpu: 50m

autoscaling:
  minReplicas: 2
  maxReplicas: 5

ingress:
  enabled: true
  public: true
  paths:
    - path: /
      pathType: Prefix
      port: 80
```

### Application with Azure Key Vault Integration (COMMING SOON)

```yaml
image:
  repo: myregistry.azurecr.io/my-app
  tag: "v1.2.3"
  port: 8080

serviceAccount:
  create: true
  name: my-app-sa

additionalLabels:
  pod:
    azure.workload.identity/use: "true"

envVars:
  variables:
    - name: ENVIRONMENT
      value: production
  secrets:
    - envVarName: DATABASE_PASSWORD
      keyVaultName: my-key-vault
      keyVaultSecret: db-password
      type: secret
```

### High Availability Setup

```yaml
autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 20
  targetCPUUtilizationPercentage: 70

podDisruptionBudget:
  enabled: true
  minAvailable: 2

resources:
  memory: 512Mi
  cpu: 200m
```

## Development

### Testing Locally

Install dependencies:
```bash
# Install Helm
brew install helm

# Install chart-testing
brew install chart-testing

# Install helm-unittest plugin
helm plugin install https://github.com/helm-unittest/helm-unittest
```

### Linting

```bash
ct lint --config ct.yaml
```

### Unit Tests

```bash
helm unittest charts/kristian-app
```

### Installation Test

```bash
# Create kind cluster
kind create cluster

# Install the chart
helm install test-release charts/kristian-app -f charts/kristian-app/ci/ci-values.yaml

# Run chart-testing install
ct install --config ct.yaml
```

## CI/CD

This repository uses GitHub Actions for:

- **Unit Tests**: Validates template rendering with different values
- **Lint & Integration Tests**: Lints and installs the chart in a Kind cluster
- **Release**: Automatically packages and publishes new chart versions

### Release Process

1. Update the `version` in `charts/kristian-app/Chart.yaml`
2. Create a PR with your changes
3. Merge to `main`
4. GitHub Actions will automatically create a release and update the Helm repository
