# Build stage
FROM node:20-alpine AS build-deps
# Instalar Flutter manualmente o usar una imagen pre-construida
# Por simplicidad y velocidad, usaremos una imagen de cirrusci para el build
FROM cirrusci/flutter:stable AS build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# Run stage
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
