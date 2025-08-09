#!/bin/bash

# Deployment Script für Hello World Kubernetes App
# Autor: Benjamin Busch

echo "🚀 Starte Deployment der Hello World App..."

# 1. Docker Image bauen
echo "📦 Baue Docker Image..."
docker build -t hello-world:latest .

if [ $? -ne 0 ]; then
    echo "❌ Docker Build fehlgeschlagen!"
    exit 1
fi

echo "✅ Docker Image erfolgreich erstellt"

# 2. Kubernetes Namespace erstellen
echo "🏗️ Erstelle Kubernetes Namespace..."
kubectl apply -f k8s/namespace.yaml

# 3. Deployment anwenden
echo "🔧 Deploye Anwendung..."
kubectl apply -f k8s/deployment.yaml

# 4. Service erstellen
echo "🌐 Erstelle Service..."
kubectl apply -f k8s/service.yaml

# 5. Warte auf Deployment
echo "⏳ Warte auf Deployment..."
kubectl rollout status deployment/hello-world-deployment -n hello-world

# 6. Status anzeigen
echo "📊 Deployment Status:"
kubectl get pods -n hello-world
kubectl get services -n hello-world

echo ""
echo "🎉 Deployment erfolgreich!"
echo "📍 Zugriff über: http://localhost:30080"
echo "🏥 Health Check: http://localhost:30080/health"
echo "ℹ️  System Info: http://localhost:30080/info"
echo ""
echo "🛠️ Nützliche Befehle:"
echo "  kubectl get pods -n hello-world"
echo "  kubectl logs -f deployment/hello-world-deployment -n hello-world"
echo "  kubectl delete namespace hello-world  # Zum Löschen"