# 🚀 Kubernetes Hello World für Anfänger

Eine vollständige, anfängerfreundliche Anleitung für deine erste Kubernetes-Anwendung mit **Rancher Desktop**.

**👨‍💻 Autor:** Benjamin Busch  
**🎯 Level:** Anfänger bis Fortgeschritten  
**⏱️ Zeitaufwand:** 15-30 Minuten  

---

## 📋 Inhaltsverzeichnis

1. [Was ist Kubernetes?](#-was-ist-kubernetes)
2. [Wichtige Kubernetes Konzepte](#-wichtige-kubernetes-konzepte)
3. [Projekt-Setup](#-projekt-setup)
4. [Code-Erklärung](#-code-erklärung-zeile-für-zeile)
5. [Deployment](#-deployment)
6. [Wichtige kubectl Befehle](#-wichtige-kubectl-befehle)
7. [Troubleshooting](#-troubleshooting)
8. [Weiterführende Schritte](#-weiterführende-schritte)

---

## 🌟 Was ist Kubernetes?

**Kubernetes** (auch "K8s" genannt) ist ein **Container-Orchestrierungssystem**. Stell dir vor:

### 🏠 **Ohne Kubernetes** (traditionell):
```
🖥️ Ein Server = Eine Anwendung
❌ Server fällt aus → App ist offline
❌ Hohe Last → App wird langsam
❌ Updates → Downtime
```

### 🏙️ **Mit Kubernetes**:
```
🐳 Container = Deine App in einer "Box"
📦 Pods = Container + Ressourcen
🔄 Deployments = Verwalten von Pods
🌐 Services = Netzwerk-Routing
⚖️ Load Balancing = Traffic-Verteilung
🔄 Auto-Restart bei Crashes
📈 Auto-Scaling bei hoher Last
```

---

## 🧩 Wichtige Kubernetes Konzepte

### 🏗️ **1. Container**
```bash
# Was ist ein Container?
🐳 Container = Deine App + alle Dependencies in einer "Box"
📦 Isoliert vom Host-System
🔒 Sicher und portabel
💾 Weniger Ressourcen als VMs
```

### 📦 **2. Pod - Die kleinste Einheit**
```yaml
# Was ist ein Pod?
Pod = Ein oder mehrere Container, die zusammenarbeiten
🏠 Teilen sich IP-Adresse und Storage
🔄 Leben und sterben zusammen
📍 Laufen auf einem Node (Server)
```

**Beispiel-Pod:**
```
┌─────────────────┐
│      Pod        │
│  ┌───────────┐  │
│  │  App      │  │ <- Deine Hello World App
│  │ Container │  │ <- läuft auf Port 3000
│  └───────────┘  │
│  IP: 10.0.0.5   │ <- Pod bekommt eigene IP
└─────────────────┘
```

### 🚀 **3. Deployment - Pod-Verwaltung**
```yaml
# Was ist ein Deployment?
Deployment = Verwaltet deine Pods
📊 Bestimmt Anzahl der Replicas (Kopien)
🔄 Rollt Updates automatisch aus
🛡️ Stellt sicher, dass Pods laufen
```

**Beispiel-Deployment:**
```
Deployment: "hello-world-deployment"
├── 📦 Pod 1 (hello-world-xxx-001) → Ready
├── 📦 Pod 2 (hello-world-xxx-002) → Ready  
└── 📦 Pod 3 (hello-world-xxx-003) → Ready
```

### 🌐 **4. Service - Netzwerk-Zugriff**
```yaml
# Was ist ein Service?
Service = Netzwerk-Gateway zu deinen Pods
🎯 Feste IP-Adresse für wechselnde Pods
⚖️ Load Balancing zwischen Pods
🌍 Zugriff von außen möglich
```

**Service-Typen:**
```bash
ClusterIP    # Nur intern im Cluster (Standard)
NodePort     # Zugriff über Node-Port (30000-32767)
LoadBalancer # Externer Load Balancer (Cloud)
```

### 🏗️ **5. Namespace - Organisierung**
```yaml
# Was ist ein Namespace?
Namespace = Virtueller Cluster im Cluster
🗂️ Organisiert Ressourcen
🔐 Isolation zwischen Projekten
🏷️ Wie Ordner im Dateisystem
```

---

## 🛠️ Projekt-Setup

### **Voraussetzungen:**
- ✅ [Rancher Desktop](https://rancherdesktop.io/) installiert
- ✅ [Node.js](https://nodejs.org/) (für lokale Entwicklung)
- ✅ [Git](https://git-scm.com/) installiert

### **1. Repository klonen:**
```bash
git clone https://github.com/benjaminbusch/kubernetes_helloworld.git
cd kubernetes_helloworld
```

### **2. Dependencies installieren:**
```bash
npm install
```

### **3. Lokale Entwicklung testen:**
```bash
npm start
# Öffne: http://localhost:3000
```

### **4. In Kubernetes deployen:**
```bash
chmod +x deploy.sh
./deploy.sh
# Öffne: http://localhost:30080
```

---

## 💻 Code-Erklärung (Zeile für Zeile)

### 📄 **package.json** - Projekt-Konfiguration
```json
{
  "name": "kubernetes-hello-world",        // Projekt-Name
  "version": "1.0.0",                     // Version
  "main": "app.js",                       // Haupt-Datei
  "scripts": {
    "start": "node app.js"                // Start-Befehl
  },
  "dependencies": {
    "express": "^4.18.2"                  // Web-Framework
  }
}
```

### 🚀 **app.js** - Express Server
```javascript
const express = require('express');       // Express Framework laden
const app = express();                    // Express App erstellen
const PORT = process.env.PORT || 3000;   // Port aus Umgebung oder 3000

// 🏠 Haupt-Route
app.get('/', (req, res) => {
  res.json({
    message: 'Hallo Welt von Kubernetes! 🚀',  // Begrüßung
    timestamp: new Date().toISOString(),       // Aktuelle Zeit
    hostname: require('os').hostname(),        // Pod-Name (in Kubernetes)
    version: '1.0.0',                         // App-Version
    author: 'Benjamin Busch'                  // Autor
  });
});

// 🏥 Health-Check für Kubernetes
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',                        // Status für Kubernetes Probes
    timestamp: new Date().toISOString(),      // Aktuelle Zeit
    uptime: process.uptime()                  // Laufzeit in Sekunden
  });
});

// 🌐 Server starten (0.0.0.0 wichtig für Container!)
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server läuft auf Port ${PORT}`);
});
```

### 🐳 **Dockerfile** - Container-Definition
```dockerfile
# 1. Base Image: Node.js 18 auf Alpine Linux (klein & sicher)
FROM node:18-alpine

# 2. Arbeitsverzeichnis im Container setzen
WORKDIR /app

# 3. Package-Dateien zuerst kopieren (für Docker Layer Caching)
COPY package*.json ./

# 4. Dependencies installieren (nur Production)
RUN npm ci --only=production && npm cache clean --force

# 5. Rest der Anwendung kopieren
COPY . .

# 6. Port 3000 für andere Container/Services freigeben
EXPOSE 3000

# 7. Zu non-root User wechseln (Sicherheit!)
USER node

# 8. Start-Kommando definieren
CMD ["npm", "start"]
```

### 🏗️ **k8s/namespace.yaml** - Namespace erstellen
```yaml
apiVersion: v1              # Kubernetes API Version für Core-Objekte
kind: Namespace             # Ressourcen-Typ: Namespace
metadata:
  name: hello-world         # Name unseres Namespace
  labels:                   # Labels für Identifikation
    app: hello-world        # App-Label
    created-by: benjamin-busch  # Ersteller-Label
```

### 🚀 **k8s/deployment.yaml** - Pod-Verwaltung
```yaml
apiVersion: apps/v1         # API für Deployments
kind: Deployment            # Ressourcen-Typ: Deployment
metadata:
  name: hello-world-deployment  # Deployment-Name
  namespace: hello-world        # In unserem Namespace
  labels:
    app: hello-world           # Labels für Selektion
spec:
  replicas: 3                 # 3 Pod-Kopien für Hochverfügbarkeit
  selector:                   # Welche Pods gehören zu diesem Deployment?
    matchLabels:
      app: hello-world        # Pods mit diesem Label
  template:                   # Vorlage für neue Pods
    metadata:
      labels:
        app: hello-world      # Label für neue Pods
    spec:                     # Pod-Spezifikation
      containers:
      - name: hello-world-container    # Container-Name
        image: hello-world:latest      # Unser Docker Image
        imagePullPolicy: Never         # Lokales Image verwenden (Rancher Desktop)
        ports:
        - containerPort: 3000          # Container-Port
        env:                           # Umgebungsvariablen
        - name: PORT
          value: "3000"
        - name: NODE_ENV
          value: "production"
        resources:                     # Ressourcen-Limits
          limits:                      # Maximale Ressourcen
            cpu: 500m                  # 0.5 CPU-Kerne
            memory: 512Mi              # 512 MB RAM
          requests:                    # Mindest-Ressourcen
            cpu: 250m                  # 0.25 CPU-Kerne
            memory: 256Mi              # 256 MB RAM
        livenessProbe:                 # Ist der Container gesund?
          httpGet:
            path: /health              # Health-Check Endpoint
            port: 3000
          initialDelaySeconds: 30      # 30s warten nach Container-Start
          periodSeconds: 10            # Alle 10s prüfen
        readinessProbe:                # Ist der Container bereit für Traffic?
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 5       # 5s warten nach Container-Start
          periodSeconds: 5             # Alle 5s prüfen
```

### 🌐 **k8s/service.yaml** - Netzwerk-Zugriff
```yaml
apiVersion: v1                    # API für Core-Services
kind: Service                     # Ressourcen-Typ: Service
metadata:
  name: hello-world-service       # Service-Name
  namespace: hello-world          # In unserem Namespace
  labels:
    app: hello-world             # Service-Labels
spec:
  type: NodePort                 # Service-Typ für externen Zugriff
  selector:                      # Welche Pods soll dieser Service erreichen?
    app: hello-world            # Pods mit diesem Label
  ports:
  - name: http                   # Port-Name
    port: 80                     # Service-Port (intern)
    targetPort: 3000             # Container-Port (unser Express Server)
    nodePort: 30080              # Externer Port (30000-32767 Range)
  sessionAffinity: ClientIP      # Client-Sessions an gleichen Pod
```

---

## 🚀 Deployment

### **Automatisches Deployment:**
```bash
./deploy.sh
```

### **Manuelles Deployment:**
```bash
# 1. Docker Image bauen
docker build -t hello-world:latest .

# 2. Kubernetes Ressourcen erstellen
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml  
kubectl apply -f k8s/service.yaml

# 3. Status prüfen
kubectl get pods -n hello-world
kubectl get services -n hello-world
```

### **Was passiert beim Deployment?**

```
1️⃣ Docker baut Image aus Dockerfile
   📦 Base: node:18-alpine (~40MB)
   📦 + deine App (~88MB)
   ✅ Total: ~128MB

2️⃣ Kubernetes erstellt Namespace "hello-world"
   🏗️ Virtueller Bereich für deine Ressourcen

3️⃣ Deployment startet 3 Pods
   🚀 Pod 1: hello-world-deployment-xxx-001
   🚀 Pod 2: hello-world-deployment-xxx-002  
   🚀 Pod 3: hello-world-deployment-xxx-003

4️⃣ Service macht Pods über Port 30080 erreichbar
   🌐 Load Balancer verteilt Requests auf alle 3 Pods

5️⃣ Health Checks überwachen Pod-Gesundheit
   💓 Liveness Probe: Ist Pod noch am Leben?
   🚦 Readiness Probe: Kann Pod Traffic verarbeiten?
```

---

## 🛠️ Wichtige kubectl Befehle

### **📊 Status & Übersicht**
```bash
# Cluster-Info anzeigen
kubectl cluster-info

# Alle Nodes anzeigen
kubectl get nodes

# Alle Namespaces anzeigen
kubectl get namespaces

# Alle Ressourcen in einem Namespace
kubectl get all -n hello-world

# Detaillierte Ressourcen-Info
kubectl describe deployment hello-world-deployment -n hello-world
```

### **📦 Pods verwalten**
```bash
# Alle Pods anzeigen
kubectl get pods -n hello-world

# Pod-Details anzeigen
kubectl describe pod <POD-NAME> -n hello-world

# Pod-Logs anzeigen
kubectl logs <POD-NAME> -n hello-world

# Live-Logs verfolgen
kubectl logs -f deployment/hello-world-deployment -n hello-world

# In Pod einloggen (Debug)
kubectl exec -it <POD-NAME> -n hello-world -- /bin/sh
```

### **🔄 Deployments verwalten**
```bash
# Deployment-Status anzeigen
kubectl rollout status deployment/hello-world-deployment -n hello-world

# Deployment skalieren
kubectl scale deployment hello-world-deployment --replicas=5 -n hello-world

# Deployment aktualisieren
kubectl set image deployment/hello-world-deployment hello-world-container=hello-world:v2.0 -n hello-world

# Rollback bei Problemen
kubectl rollout undo deployment/hello-world-deployment -n hello-world
```

### **🌐 Services & Netzwerk**
```bash
# Services anzeigen
kubectl get services -n hello-world

# Service-Details
kubectl describe service hello-world-service -n hello-world

# Port-Forward für lokalen Zugriff
kubectl port-forward service/hello-world-service 8080:80 -n hello-world

# Endpoints anzeigen (Pod-IPs hinter Service)
kubectl get endpoints -n hello-world
```

### **🔍 Debugging & Troubleshooting**
```bash
# Events anzeigen (wichtig für Fehlersuche!)
kubectl get events -n hello-world --sort-by='.lastTimestamp'

# Alle Events im Cluster
kubectl get events --all-namespaces

# Ressourcen-Verbrauch anzeigen
kubectl top pods -n hello-world
kubectl top nodes

# YAML-Konfiguration einer Ressource anzeigen
kubectl get deployment hello-world-deployment -n hello-world -o yaml
```

### **🧹 Aufräumen**
```bash
# Einzelne Ressourcen löschen
kubectl delete pod <POD-NAME> -n hello-world
kubectl delete deployment hello-world-deployment -n hello-world

# Ganzen Namespace löschen (löscht ALLES!)
kubectl delete namespace hello-world

# Docker Image löschen
docker rmi hello-world:latest
```

---

## ⚡ Häufige kubectl Optionen

```bash
# Namespace für alle Befehle setzen
kubectl config set-context --current --namespace=hello-world

# Output-Formate
kubectl get pods -o wide                    # Mehr Details
kubectl get pods -o json                    # JSON-Format  
kubectl get pods -o yaml                    # YAML-Format
kubectl get pods --show-labels              # Mit Labels

# Warten auf Änderungen
kubectl get pods -w                         # Watch-Mode
kubectl wait --for=condition=ready pod/<POD-NAME>  # Warten auf Ready

# Mehrere Ressourcen
kubectl get pods,services,deployments -n hello-world
```

---

## 🚨 Troubleshooting

### **❌ Problem: Pods starten nicht**
```bash
# 1. Pod-Status prüfen
kubectl get pods -n hello-world

# 2. Pod-Events anzeigen
kubectl describe pod <POD-NAME> -n hello-world

# 3. Pod-Logs anzeigen  
kubectl logs <POD-NAME> -n hello-world

# Häufige Ursachen:
# - Image nicht gefunden (imagePullPolicy: Never für lokale Images!)
# - Ressourcen-Limits zu niedrig
# - Fehlerhafter Code in der App
```

### **❌ Problem: Service nicht erreichbar**
```bash
# 1. Service-Status prüfen
kubectl get services -n hello-world

# 2. Endpoints prüfen (zeigt Pod-IPs)
kubectl get endpoints -n hello-world

# 3. Port-Forward testen
kubectl port-forward service/hello-world-service 8080:80 -n hello-world

# Häufige Ursachen:
# - Service-Selector passt nicht zu Pod-Labels
# - Falscher targetPort im Service
# - Pods sind nicht "Ready"
```

### **❌ Problem: "ImagePullBackOff" Error**
```bash
# Ursache: Kubernetes kann Docker Image nicht finden

# Lösung für lokale Images:
imagePullPolicy: Never  # Im deployment.yaml

# Image lokal vorhanden prüfen:
docker images | grep hello-world

# Neu bauen falls nötig:
docker build -t hello-world:latest .
```

### **❌ Problem: Permission Denied**
```bash
# Ursache: User node kann nicht auf /app schreiben

# Dockerfile prüfen:
USER node  # Nach COPY Befehlen!

# Richtige Reihenfolge:
COPY package*.json ./
RUN npm install
COPY . .        # <- Vor USER node!
USER node
```

---

## 🎯 Weiterführende Schritte

### **🔒 1. Sicherheit verbessern**
```yaml
# Secrets für sensible Daten
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
data:
  api-key: <base64-encoded>

# ConfigMaps für Konfiguration
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  environment: "production"
  debug: "false"
```

### **📊 2. Monitoring hinzufügen**
```bash
# Prometheus für Metriken
# Grafana für Dashboards
# Jaeger für Tracing

# Health-Check Endpunkt erweitern
app.get('/metrics', (req, res) => {
  res.json({
    requests: totalRequests,
    memory: process.memoryUsage(),
    uptime: process.uptime()
  });
});
```

### **🌐 3. Ingress für professionelle URLs**
```yaml
# Statt NodePort → Ingress Controller
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-world-ingress
spec:
  rules:
  - host: hello-world.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: hello-world-service
            port: 
              number: 80
```

### **💾 4. Persistent Storage**
```yaml
# Für Datenbanken und persistente Daten
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-storage
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

### **🔄 5. CI/CD Pipeline**
```yaml
# GitHub Actions für automatisches Deployment
name: Deploy to Kubernetes
on:
  push:
    branches: [ main ]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Build Docker Image
      run: docker build -t hello-world:$GITHUB_SHA .
    - name: Deploy to Kubernetes  
      run: kubectl set image deployment/hello-world-deployment hello-world-container=hello-world:$GITHUB_SHA
```

---

## 📚 Nützliche Ressourcen

### **📖 Offizielle Dokumentation**
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Rancher Desktop Docs](https://docs.rancherdesktop.io/)

### **🎓 Lernressourcen**
- [Kubernetes Tutorial](https://kubernetes.io/docs/tutorials/)
- [Play with Kubernetes](https://labs.play-with-k8s.com/)
- [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)

### **🛠️ Tools**
- [k9s](https://k9scli.io/) - Terminal UI für Kubernetes
- [Lens](https://k8slens.dev/) - GUI für Kubernetes
- [Helm](https://helm.sh/) - Package Manager für Kubernetes

---

## 🤝 Mitwirken

Du hast Verbesserungsvorschläge oder Fragen? 

1. **Fork** dieses Repository
2. **Erstelle** einen Feature-Branch (`git checkout -b feature/amazing-feature`)
3. **Committe** deine Änderungen (`git commit -m 'Add amazing feature'`)
4. **Push** zum Branch (`git push origin feature/amazing-feature`)
5. **Öffne** einen Pull Request

---

## 📝 Lizenz

Dieses Projekt steht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE) für Details.

---

## 👨‍💻 Autor

**Benjamin Busch**
- GitHub: [@benjaminbusch](https://github.com/benjaminbusch)
- E-Mail: benjamin@example.com

---

## 🙏 Danksagungen

- **Rancher Desktop Team** für die excellente lokale Kubernetes-Umgebung
- **Kubernetes Community** für die umfangreiche Dokumentation
- **Node.js Community** für das robuste Express Framework

---

*🚀 Viel Spaß beim Lernen von Kubernetes! Bei Fragen einfach ein Issue erstellen.*