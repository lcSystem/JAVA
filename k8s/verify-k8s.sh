#!/bin/bash

# Script de Verificación de Salud - ERP Kubernetes

echo "🔍 Verificando estado de los Pods..."
kubectl get pods -n erp-namespace

echo -e "\n🌐 Probando conectividad externa..."

# Obtener IP de Minikube
MINIKUBE_IP=$(minikube ip)

echo "IP de Minikube: $MINIKUBE_IP"
echo "Asegúrate de tener en /etc/hosts: $MINIKUBE_IP api.erp.local app.erp.local chat.erp.local"

# Probar Ingress (Frontend y API)
echo -e "\n--- Prueba Frontend (app.erp.local) ---"
curl -I -H "Host: app.erp.local" http://$MINIKUBE_IP/ || echo "❌ Error al conectar con Frontend"

echo -e "\n--- Prueba API Gateway (api.erp.local) ---"
curl -I -H "Host: api.erp.local" http://$MINIKUBE_IP/actuator/health/liveness || echo "❌ Error al conectar con API Gateway"

echo -e "\n--- Prueba Chat Frontend (chat.erp.local) ---"
curl -I -H "Host: chat.erp.local" http://$MINIKUBE_IP/ || echo "❌ Error al conectar con Chat Frontend"

echo -e "\n--- Verificación de Logs (Conversational Hub) ---"
if kubectl logs -l app=conversational-hub -n erp-namespace | grep -q "Connection refused\|PostgreSQLDatabaseServer\|ERROR"; then
  echo "⚠️ Se detectaron posibles errores de conexión en los logs de Conversational Hub."
  kubectl logs -l app=conversational-hub -n erp-namespace --tail=20
else
  echo "✅ No se detectaron errores de conexión críticos en los logs."
fi

echo -e "\n--- Resumen de Endpoints ---"
kubectl get ingress -n erp-namespace
