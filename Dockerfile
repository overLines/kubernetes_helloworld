# Verwende Node.js 18 Alpine Linux (klein und sicher)
FROM node:18-alpine

# Setze das Arbeitsverzeichnis im Container
WORKDIR /app

# Kopiere package.json und package-lock.json (falls vorhanden)
COPY package*.json ./

# Installiere nur Production Dependencies
RUN npm ci --only=production && npm cache clean --force

# Kopiere den Rest der Anwendung
COPY . .

# Exponiere Port 3000
EXPOSE 3000

# Wechsle zu non-root User für Sicherheit
USER node

# Startkommando
CMD ["npm", "start"]