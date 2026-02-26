#!/bin/bash

# Plan de Despliegue Maestro - ERP Kubernetes
# Este script automatiza la construcción y el despliegue de todo el ecosistema.

set -e

echo "🚀 Iniciando despliegue de ERP en Kubernetes..."

# 1. Configurar entorno Docker de Minikube
echo "🐳 Configurando entorno Docker de Minikube..."
eval $(minikube docker-env)

# 2. Construir imágenes
echo "🏗️ Construyendo imágenes de microservicios..."

docker build -t api-gateway:latest ./api-gateway
docker build -t iam-core-p:latest ./iam-core-p/iam-core
docker build -t creditos-web:latest ./creditos-web
docker build -t parametrizaciones:latest ./parametrizaciones
docker build -t erp-portfolio-service:latest ./erp-portfolio-service
docker build -t reportes-service:latest ./reportes-service
docker build -t iam-core-front:latest ./iam-core-front/ERP-FRONT/ERP-FRONT
docker build -t conversational-hub:latest ./conversational-hub
docker build -t conversational-hub-flutter:latest ./conversational-hub-flutter

# 3. Aplicar Manifiestos K8s
echo "☸️ Aplicando manifiestos de Kubernetes..."

cd k8s

kubectl apply -f namespace.yaml
kubectl apply -f storage.yaml
kubectl apply -f configmaps.yaml
kubectl apply -f secrets.yaml
kubectl apply -f mysql.yaml
kubectl apply -f postgres.yaml
kubectl apply -f rabbitmq.yaml

echo "⏳ Esperando a que la infraestructura base esté lista..."
kubectl wait --for=condition=ready pod -l app=mysql -n erp-namespace --timeout=90s
kubectl wait --for=condition=ready pod -l app=postgres -n erp-namespace --timeout=90s
kubectl wait --for=condition=ready pod -l app=rabbitmq -n erp-namespace --timeout=90s

kubectl apply -f services-auth-credit.yaml
kubectl apply -f services-others.yaml
kubectl apply -f conversational-hub.yaml
kubectl apply -f api-gateway.yaml
kubectl apply -f frontend.yaml
kubectl apply -f frontend-chat.yaml
kubectl apply -f ingress.yaml

echo "✅ Despliegue completado con éxito."
echo "🔍 Ejecuta './verify-k8s.sh' para validar el estado del sistema."
