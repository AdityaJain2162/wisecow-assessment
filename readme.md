# Wisecow Application Deployment

## Overview

This document outlines the steps to deploy the Wisecow application on a local Kubernetes cluster using Minikube. It covers creating Kubernetes manifests for deployments, services, and ingress, setting up TLS with a self-signed certificate, and troubleshooting common issues.

## Prerequisites

1. **Docker**: Ensure Docker is installed on your local machine. Install Docker from [Docker's official website](https://www.docker.com/products/docker-desktop).
2. **Docker Hub Account**: Create an account on Docker Hub at [Docker Hub](https://hub.docker.com/).
3. **Kubernetes with Minikube**: Install Minikube and kubectl. Follow [Minikube’s installation guide](https://minikube.sigs.k8s.io/docs/start/) if necessary.
4. **GitHub Account**: Create an account on GitHub at [GitHub](https://github.com/).

### Create a Dockerfile
Create a `Dockerfile` with the following content:

```Dockerfile
FROM debian:latest

# Set the working directory in the container
WORKDIR /app

# Install required packages, including Netcat
RUN apt-get update && \
    apt-get install -y \
    fortune-mod \
    cowsay \
    netcat-openbsd \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Copy the shell script into the container
COPY wisecow.sh /app/wisecow.sh

# Convert line endings from CRLF to LF
RUN dos2unix /app/wisecow.sh

# Make the script executable
RUN chmod +x /app/wisecow.sh

# Update PATH to include /usr/games
ENV PATH="/usr/games:${PATH}"

# Example Dockerfile snippet
EXPOSE 4499

# Specify the default command to run the script
ENTRYPOINT ["/app/wisecow.sh"]
```
## Steps

### 1. Set Up Minikube

1. **Start Minikube**

   ```bash
   minikube start
   ```

2. **Enable Ingress**

   ```bash
   minikube addons enable ingress
   ```

### 2. Create TLS Certificates

1. **Generate Self-Signed Certificates**

   Use the following OpenSSL command to generate `tls.crt` and `tls.key` for local testing:

   ```powershell
   openssl req -x509 -nodes -days 365 -newkey rsa:2048 `
   -keyout tls.key -out tls.crt `
   -subj "/CN=localhost" `
   -addext "subjectAltName = DNS:localhost"
   ```

2. **Create a Kubernetes Secret for TLS**

   ```bash
   kubectl create secret tls tls-secret --cert=cert/tls.crt --key=cert/tls.key
   ```

### 3. Create Kubernetes Manifests

1. **Deployment Configuration (`deployment.yaml`)**

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: wisecow-deployment
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: wisecow
     template:
       metadata:
         labels:
           app: wisecow
       spec:
         containers:
           - name: wisecow-container
             image: adityajain2162/wisecow_image:latest
             ports:
               - containerPort: 4499
   ```

2. **Service Configuration (`service.yaml`)**

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: wisecow-service
   spec:
     selector:
       app: wisecow
     ports:
       - protocol: TCP
         port: 80
         targetPort: 4499
     type: ClusterIP
   ```

3. **Ingress Configuration (`ingress.yaml`)**

   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: wisecow-ingress
     annotations:
       nginx.ingress.kubernetes.io/secure-backends: "true"
       nginx.ingress.kubernetes.io/ssl-redirect: "true"
   spec:
     tls:
       - hosts:
           - localhost
         secretName: tls-secret
     rules:
       - host: localhost
         http:
           paths:
             - path: /
               pathType: Prefix
               backend:
                 service:
                   name: wisecow-service
                   port:
                     number: 80
   ```

### 4. Deploy the Application

1. **Apply the Manifests**

   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   kubectl apply -f ingress.yaml
   ```

### 5. Access the Application

1. **Forward the Ingress controller port to access the application with TLS:**

   ```bash
   kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8443:443
   ```
   Open https://localhost:8443 in your web browser. You may need to accept the self-signed certificate warning. 

2. **Verify Ingress**

   Ensure that the Ingress controller is set up correctly by checking the logs:

   ```bash
   kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
   ```

### 6. Troubleshooting

1. **Check Pod Status**

   ```bash
   kubectl get pods
   ```

   Ensure all pods are running and have the `READY` status.

2. **Check Service Status**

   ```bash
   kubectl get services
   ```

   Verify the `ClusterIP` service is running and accessible.

3. **Check Ingress Status**

   ```bash
   kubectl describe ingress wisecow-ingress
   ```

   Ensure the Ingress rules are correctly configured and the TLS certificate is applied.

4. **Logs and Errors**

   Review logs for any errors related to Ingress or service:

   ```bash
   kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
   ```

   Look for SSL certificate validation errors or other issues.

### 7. Remove Resources

1. **Delete the Deployment, Service, and Ingress**

   ```bash
   kubectl delete -f deployment.yaml
   kubectl delete -f service.yaml
   kubectl delete -f ingress.yaml
   ```

2. **Delete the TLS Secret**

   ```bash
   kubectl delete secret tls-secret
   ```

3. **Stop Minikube**

   ```bash
   minikube stop
   ```

---

This README provides a comprehensive guide to deploying and testing the Wisecow application locally using Minikube, Ingress, and TLS. Adjust the configurations as needed for your specific setup and environment.