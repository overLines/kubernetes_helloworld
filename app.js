const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Hauptroute - zeigt Hello World Nachricht
app.get('/', (req, res) => {
  res.json({
    message: 'Hallo Welt von Kubernetes und Rancher Desktop! 🚀',
    timestamp: new Date().toISOString(),
    hostname: require('os').hostname(),
    version: '1.0.0',
    author: 'Benjamin Busch'
  });
});

// Health Check Endpoint für Kubernetes Probes
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Zusätzlicher Info-Endpoint
app.get('/info', (req, res) => {
  res.json({
    nodeVersion: process.version,
    platform: process.platform,
    architecture: process.arch,
    memory: process.memoryUsage()
  });
});

// Server starten
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Hello World App läuft auf Port ${PORT}`);
  console.log(`📍 Hostname: ${require('os').hostname()}`);
  console.log(`⏰ Gestartet: ${new Date().toISOString()}`);
});