# Microservices Project - User & Product Service

This project demonstrates a complete microservices implementation with containerization, Kubernetes deployment, CI/CD pipeline, and monitoring using Azure cloud services.

## 🏗️ Project Overview

This microservices project consists of a Flask-based Python application that provides REST APIs for user and product management. The application is fully containerized, deployed on Azure Kubernetes Service (AKS), and includes comprehensive CI/CD pipelines and monitoring.

## 📋 Task Implementation

### 1. Application Architecture
- **Framework**: Flask (Python 3.11)
- **Structure**: Modular microservices architecture with separate routes and services
- **Endpoints**: 
  - `/users` - Get all users
  - `/users/<id>` - Get user by ID
  - `/products` - Get all products
  - `/products/<id>` - Get product by ID

### 2. 🐳 Dockerization
The application is containerized using a multi-stage Dockerfile for optimized production builds:

**Key Features:**
- Multi-stage build for smaller image size
- Non-root user for security
- Gunicorn WSGI server for production
- Optimized layer caching

**Build Command:**
```bash
docker build -t user-product-svc .
```

**Dockerfile Highlights:**
- Uses Python 3.11-slim base image
- Implements security best practices with non-root user
- Multi-stage build reduces final image size
- Production-ready with Gunicorn

### 3. ☁️ Kubernetes Cluster Provisioning (Azure)
Infrastructure is managed using Terraform with Azure as the cloud provider:

**Infrastructure Components:**
- **Azure Kubernetes Service (AKS)** cluster
- **Azure Container Registry (ACR)** for Docker images
- **Resource Group** management
- **Networking** configuration with LoadBalancer

**Terraform Configuration:**
- Located in `terraform/` directory
- Provisions AKS cluster with Standard_D2s_v4 nodes
- Configures ACR integration with AKS
- Implements proper RBAC and networking

**Deployment Commands:**
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 4. 🚀 Kubernetes Deployment
The application is deployed using Kubernetes YAML manifests:

**Deployment Configuration (`k8s/deployment.yaml`):**
- Single replica deployment
- Resource limits and requests defined
- Image pulled from Azure Container Registry
- Health checks configured

**Service Configuration (`k8s/service.yaml`):**
- LoadBalancer service type for external access
- Port mapping: 80 (external) → 5000 (container)

**Deploy Commands:**
```bash
kubectl apply -f k8s/
```

### 5. 🌐 External Service Exposure
The service is exposed to the internet using Kubernetes LoadBalancer:

**Configuration:**
- Service type: `LoadBalancer`
- External port: 80
- Internal port: 5000
- Azure Load Balancer automatically provisioned

**Access:**
- External IP provided by Azure Load Balancer
- Service accessible via HTTP on port 80

### 6. 🔄 CI/CD Pipeline Implementation
Comprehensive CI/CD pipeline implemented using Azure DevOps with self-hosted agents and managed identity:

**Pipeline Architecture:**
- **Self-hosted Agent Pool**: `pwc-task` - Custom agent pool for enhanced security and control
- **Managed Identity Integration**: Secure authentication without storing credentials
- **Reusable Templates**: Modular pipeline templates in `.pipeline/templates/`

**Pipeline Structure:**
1. **CI Pipeline** (`azure-pipelines-ci.yaml`):
   - Triggers on main branch changes
   - Builds Docker image using self-hosted agent
   - Pushes to Azure Container Registry via managed identity
   - Uses reusable build and push templates

2. **CD Pipeline** (`azure-pipeline-cd.yaml`):
   - Triggers after successful CI
   - Deploys to Kubernetes cluster using self-hosted agent
   - Updates image tags automatically
   - Environment-specific deployments with managed identity

3. **Infrastructure Pipeline** (`azure-pipeline-infra.yaml`):
   - Terraform validation and planning
   - Infrastructure provisioning via managed identity
   - State management with Azure Storage
   - Self-hosted agent execution

**Pipeline Features:**
- **Self-hosted agents** for enhanced security and performance
- **Managed identity authentication** - no credential management required
- **Automated builds** on code changes
- **Container image versioning** with ACR integration
- **Infrastructure as Code** validation and deployment
- **Secure service connections** for ACR and AKS access

### 7. 🔐 Managed Identity Implementation
The project implements Azure Managed Identity for secure authentication across all Azure services:

**Managed Identity Features:**
- **System-assigned Managed Identity** for AKS cluster
- **ACR Integration** with managed identity for secure image pulls
- **Pipeline Authentication** using managed identity instead of service principals
- **Self-hosted Agent Pool** configured with managed identity permissions

**Security Benefits:**
- No credential storage or management required
- Automatic credential rotation
- Enhanced security for CI/CD pipelines
- Secure access to Azure Container Registry

## 🚀 Quick Start

### Prerequisites
- Azure CLI installed and configured
- Docker installed
- kubectl configured for AKS cluster
- Terraform installed
- Self-hosted Azure DevOps agent configured with managed identity

### Local Development
```bash
# Clone repository
git clone <repository-url>
cd Microservices

# Install dependencies
pip install -r requirements.txt

# Run locally
python run.py
```

### Production Deployment
```bash
# 1. Provision infrastructure with managed identity
cd terraform
terraform init
terraform plan
terraform apply

# 2. Build and push Docker image to ACR
docker build -t acrtaskpwc.azurecr.io/user-product-svc:latest .
docker push acrtaskpwc.azurecr.io/user-product-svc:latest

# 3. Deploy to Kubernetes
kubectl apply -f k8s/

# 4. Check deployment status
kubectl get services
kubectl get pods
```

## 📁 Project Structure
```
Microservices/
├── app/                          # Application code
│   ├── routes/                   # API routes
│   │   ├── product_routes.py     # Product endpoints
│   │   └── user_routes.py        # User endpoints
│   ├── services/                 # Business logic
│   │   ├── product_service.py    # Product service
│   │   └── user_service.py       # User service
│   ├── main.py                   # Application entry point
│   └── __init__.py               # App factory
├── k8s/                          # Kubernetes manifests
│   ├── deployment.yaml           # Deployment configuration
│   └── service.yaml              # Service configuration
├── terraform/                    # Infrastructure as Code
│   ├── main.tf                   # Main Terraform configuration
│   ├── variables.tf              # Variable definitions
│   └── output.tf                 # Output definitions
├── .pipeline/                    # Azure DevOps templates
├── azure-pipelines-ci.yaml       # CI pipeline
├── azure-pipeline-cd.yaml        # CD pipeline
├── azure-pipeline-infra.yaml     # Infrastructure pipeline
├── Dockerfile                    # Container configuration
├── requirements.txt              # Python dependencies
└── README.md                     # This file
```

## 🔧 Configuration

### Environment Variables
- `FLASK_ENV`: Flask environment (development/production)

### Azure Configuration
- Resource Group: `pwc-task`
- Container Registry: `acrtaskpwc`
- Kubernetes Cluster: Auto-generated name
- Storage Account: `terraformstate1759533356`
- Self-hosted Agent Pool: `pwc-task`
- Managed Identity: Configured for secure authentication

## 📈 Infrastructure Monitoring

The infrastructure is monitored through Azure native services:
- **AKS Cluster Health** via Azure Portal
- **Container Registry** access logs
- **Load Balancer** metrics and health probes
- **Resource Group** resource monitoring

## 🛠️ Troubleshooting

### Common Issues
1. **Image pull errors**: Ensure ACR managed identity permissions are configured
2. **Service not accessible**: Check LoadBalancer external IP
3. **Pod startup failures**: Verify resource limits and image tags
4. **Pipeline failures**: Check service connections and managed identity permissions
5. **Self-hosted agent issues**: Verify agent connectivity and managed identity assignment

### Useful Commands
```bash
# Check pod logs
kubectl logs -f deployment/flask-app

# Describe service
kubectl describe service flask-app

# Get external IP
kubectl get service flask-app

# Check pod status
kubectl get pods -l app=flask-app
```

## 🔒 Security Considerations

- **Non-root user** in Docker container
- **Resource limits** in Kubernetes deployment
- **System-assigned managed identity** for AKS cluster
- **ACR integration** with managed identity for secure image pulls
- **Self-hosted agents** for enhanced security control
- **Managed identity authentication** eliminates credential storage
- **RBAC configuration** for AKS cluster access

## 📝 API Documentation

### User Endpoints
- `GET /users` - Retrieve all users
- `GET /users/{id}` - Retrieve user by ID

### Product Endpoints
- `GET /products` - Retrieve all products
- `GET /products/{id}` - Retrieve product by ID

## 🚀 Future Enhancements & Recommendations

### 📊 Custom Monitoring & Alerting
**Planned Implementation:**
- **Azure Application Insights** integration for application performance monitoring
- **Custom metrics** for business logic monitoring (user registrations, product views)
- **Real-time alerting** for critical application events
- **Dashboard creation** for operational visibility
- **Log aggregation** using Azure Log Analytics

### 🧰 Azure Monitoring & Application Insights (Reference Commands)
These commands are provided for future enhancement reference (not implemented in this repo).

```bash
# Create or reference a Log Analytics workspace
az monitor log-analytics workspace create \
  --resource-group pwc-task \
  --workspace-name pwc-logs \
  --location eastus

# Create Application Insights (workspace-based)
az monitor app-insights component create \
  --app app-insights-pwc-task \
  --location eastus \
  --resource-group pwc-task \
  --workspace $(az monitor log-analytics workspace show \
                 --resource-group pwc-task \
                 --workspace-name pwc-logs \
                 --query id -o tsv)

# Get the Application Insights connection string
az monitor app-insights component show \
  --app app-insights-pwc-task \
  --resource-group pwc-task \
  --query connectionString -o tsv

# Enable AKS monitoring (Container Insights)
az aks enable-addons \
  --resource-group pwc-task \
  --name <your-aks-name> \
  --addons monitoring \
  --workspace-resource-id $(az monitor log-analytics workspace show \
                              --resource-group pwc-task \
                              --workspace-name pwc-logs \
                              --query id -o tsv)

# Verify addon status
az aks show -g pwc-task -n <your-aks-name> \
  --query addonProfiles.omsagent.enabled
```

Notes:
- Store the connection string securely in Azure Key Vault when implemented.

### 🔒 Security Enhancements
**Security Scanning Integration:**
- **Trivy vulnerability scanning** in CI/CD pipeline
- **Container image security** analysis
- **Dependency vulnerability** checks
- **Infrastructure security** scanning

## 📄 License

This project is part of a PWC task demonstration and is for educational purposes.

---

**Note**: This implementation demonstrates a complete microservices architecture with modern DevOps practices, cloud-native deployment, and secure authentication using Azure Managed Identity.
