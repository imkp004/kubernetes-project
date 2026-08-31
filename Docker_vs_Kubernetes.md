# Docker vs Kubernetes

## Overview

Docker and Kubernetes are **not competitors**. They solve different problems and are commonly used together.

> **Docker packages and runs containers. Kubernetes manages containers at scale.**

A simple mental model:

```text
Docker
    ↓
Build and run containers

Kubernetes
    ↓
Manage and orchestrate containers across multiple machines
```

---

# 1. What is Docker?

**Docker** is a containerization platform used to package an application and its dependencies into a portable **container image**.

Instead of installing an application and all of its dependencies directly on a server, Docker packages everything needed to run the application.

```text
Application
    +
Dependencies
    +
Libraries
    +
Runtime
    ↓
Docker Image
    ↓
Docker Container
```

### Example

A Python application might require:

```text
Python 3.12
Flask
Requests
Application code
System dependencies
```

A Dockerfile can package these requirements:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["python", "app.py"]
```

Build the image:

```bash
docker build -t my-app .
```

Run the container:

```bash
docker run -p 8080:8080 my-app
```

Docker is therefore excellent for:

* Building container images
* Running containers
* Local development
* Application packaging
* Testing
* CI/CD
* Docker Compose

---

# 2. What is Kubernetes?

**Kubernetes** is a container orchestration platform.

It is designed to manage containerized applications across multiple machines and handle things such as:

* Scaling
* High availability
* Service discovery
* Load balancing
* Rolling deployments
* Rollbacks
* Self-healing
* Resource management
* Configuration
* Secrets

Instead of manually managing individual containers, Kubernetes manages the desired state of the application.

```text
Developer
    ↓
Kubernetes API
    ↓
Kubernetes Cluster
    ↓
Pods
    ↓
Containers
```

---

# 3. Why Do We Need Kubernetes?

Imagine running one container:

```text
Server
 └── Docker Container
```

Docker is more than enough.

But imagine a production application with:

```text
20 Servers
500 Containers
10 Applications
Multiple Environments
```

Manually managing everything becomes difficult.

For example:

```text
Server 1
 ├── Backend
 ├── Frontend
 └── Auth

Server 2
 ├── Backend
 ├── Payment
 └── Auth

Server 3
 ├── Backend
 ├── Payment
 └── Database
```

What happens if Server 2 fails?

You need to:

1. Detect the failure
2. Determine which containers were running
3. Start replacement containers
4. Place them on healthy servers
5. Restore connectivity
6. Make sure traffic reaches the replacement containers

Kubernetes automates much of this process.

---

# 4. Docker Example

Suppose we have a backend application.

```text
Dockerfile
    ↓
docker build
    ↓
Docker Image
    ↓
docker run
    ↓
Container
```

We could run:

```bash
docker run -d my-backend
```

If we need another instance:

```bash
docker run -d my-backend
```

And another:

```bash
docker run -d my-backend
```

Now we have three containers.

But Docker alone doesn't provide the same level of orchestration and automated management that Kubernetes provides.

---

# 5. Kubernetes Example

Instead of manually starting containers, we define the desired state.

For example:

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: backend

spec:
  replicas: 3

  selector:
    matchLabels:
      app: backend

  template:
    metadata:
      labels:
        app: backend

    spec:
      containers:
        - name: backend
          image: my-backend:v1
```

We are essentially telling Kubernetes:

> "I want three instances of my backend application running."

Kubernetes continuously works toward that desired state.

```text
Desired State:

3 Backend Pods
```

If one Pod crashes:

```text
Before:

Pod 1 ✅
Pod 2 ❌
Pod 3 ✅
```

Kubernetes creates another:

```text
After:

Pod 1 ✅
Pod 2 ❌
Pod 3 ✅
Pod 4 ✅
```

The desired number is restored:

```text
3 running Pods
```

---

# 6. Docker vs Kubernetes

| Feature                               | Docker           | Kubernetes |
| ------------------------------------- | ---------------- | ---------- |
| Containerization                      | ✅                | ❌          |
| Build container images                | ✅                | ❌          |
| Run containers                        | ✅                | ✅          |
| Manage individual containers          | ✅                | ✅          |
| Manage containers across many servers | Limited          | ✅          |
| Scaling                               | Manual / Compose | ✅          |
| Self-healing                          | Limited          | ✅          |
| Load balancing                        | Basic            | ✅          |
| Service discovery                     | Basic            | ✅          |
| Rolling deployments                   | Limited          | ✅          |
| Rollbacks                             | Limited          | ✅          |
| Autoscaling                           | Limited          | ✅          |
| Secrets management                    | Basic            | ✅          |
| Multi-node orchestration              | ❌                | ✅          |
| Production orchestration              | Limited          | ✅          |

---

# 7. Docker and Kubernetes Work Together

A common production workflow looks like this:

```text
Developer
    ↓
Application Code
    ↓
Dockerfile
    ↓
Docker Build
    ↓
Docker Image
    ↓
Container Registry
    ↓
Kubernetes
    ↓
Pods
    ↓
Containers
```

For example, in AWS:

```text
Developer
    ↓
GitHub
    ↓
GitHub Actions
    ↓
Docker Build
    ↓
Amazon ECR
    ↓
Amazon EKS
    ↓
Kubernetes Deployment
    ↓
Pods
    ↓
Application
```

Here:

* **Docker** packages the application.
* **ECR** stores the Docker image.
* **Kubernetes/EKS** deploys and manages the application.

---

# 8. Docker Compose vs Kubernetes

Docker also provides **Docker Compose**, which is useful for running multiple containers, especially during local development.

For example:

```yaml
services:

  frontend:
    image: frontend:v1

  backend:
    image: backend:v1

  database:
    image: postgres
```

You can start everything with:

```bash
docker compose up -d
```

This is useful for:

```text
Local Development
        ↓
Frontend
Backend
Database
Redis
```

Kubernetes is designed for much larger and more complex orchestration environments.

```text
Docker Compose
    ↓
Great for local development / smaller environments

Kubernetes
    ↓
Production orchestration / large-scale environments
```

---

# 9. Important Distinction

One common misconception is:

> "Kubernetes is an alternative to Docker."

Not exactly.

The better way to think about it is:

```text
Docker
=
Containerization
```

```text
Kubernetes
=
Container Orchestration
```

They can work together:

```text
Docker Image
     ↓
Container Registry
     ↓
Kubernetes
     ↓
Pods
     ↓
Containers
```

Also, modern Kubernetes clusters do **not require Docker Engine as the container runtime**. Kubernetes uses the **CRI (Container Runtime Interface)**, and runtimes such as `containerd` and CRI-O can run containers. Docker remains extremely important for building and working with container images.

---

# 10. Real-World DevOps Example

Imagine a company has an e-commerce application.

```text
                    Internet
                       ↓
                  Load Balancer
                       ↓
                 Kubernetes Service
                       ↓
          ┌────────────┼────────────┐
          ↓            ↓            ↓
       Backend       Backend      Backend
         Pod           Pod          Pod
          ↓            ↓            ↓
       Container     Container    Container
```

Docker is responsible for packaging the application:

```text
Source Code
    ↓
Dockerfile
    ↓
Docker Image
```

Kubernetes is responsible for managing the running application:

```text
Docker Image
    ↓
Deployment
    ↓
Pods
    ↓
Services
    ↓
Load Balancing
    ↓
Users
```

If traffic increases:

```text
3 Pods
   ↓
High traffic
   ↓
HPA
   ↓
10 Pods
```

If a Pod crashes:

```text
Pod crashes
    ↓
Kubernetes detects it
    ↓
Replacement Pod
    ↓
Application continues running
```

If a node fails:

```text
Node fails
    ↓
Pods become unavailable
    ↓
Kubernetes reschedules workloads
    ↓
Healthy nodes run replacement Pods
```

---

# 11. The Simple Mental Model

Remember these three levels:

```text
Docker
↓
"How do I package and run my application?"
```

```text
Kubernetes
↓
"How do I manage many containers reliably?"
```

```text
DevOps / Cloud Platform
↓
"How do I automate the entire system?"
```

A typical enterprise setup can therefore look like:

```text
                 GitHub
                    ↓
             GitHub Actions
                    ↓
              Docker Build
                    ↓
                  ECR
                    ↓
             Kubernetes / EKS
                    ↓
          ┌─────────┼─────────┐
          ↓         ↓         ↓
        Pod       Pod       Pod
          ↓         ↓         ↓
       Container Container Container
                    ↓
              Application
```

## Key Takeaway

> **Docker is primarily about packaging and running containers. Kubernetes is about orchestrating and operating containerized applications at scale.**

For a DevOps engineer, you should learn **both**:

```text
Docker
  ↓
Images
  ↓
Containers
  ↓
Networking
  ↓
Volumes
  ↓
Docker Compose
  ↓
CI/CD

        +

Kubernetes
  ↓
Pods
  ↓
Deployments
  ↓
Services
  ↓
Ingress
  ↓
ConfigMaps / Secrets
  ↓
Storage
  ↓
Networking
  ↓
RBAC
  ↓
Scaling
  ↓
Troubleshooting
  ↓
Production / EKS
```
