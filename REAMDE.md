# ParkItNow - Sistema de localización de parqueaderos

**ParkItNow** es una aplicación móvil desarrollada con Flutter que permite a conductores encontrar parqueaderos disponibles en Cartagena, Colombia. Además, los dueños de parqueaderos pueden registrar sus espacios y gestionar disponibilidad.

## 📦 Estructura del proyecto

parqueaderos_project
├──parqueaderos_api_backend/ / # API REST construida en Node.js + Express + MongoDB
└── parqueaderos_app/# Aplicación Flutter (Android) La app puede correr en IOS pero no se han configurado las dependencias para ello ni requerido los permisos en la carpeta /ios


## 🚀 Tecnologías

- **Flutter** + Dart
- **OpenStreetMap** (flutter_map)
- **Google Geolocator API**
- **Node.js + Express.js**
- **MongoDB Atlas**
- **Firebase Cloud Messaging (futuro)**

## 📦 Instalación y ejecución

### 🔹 Backend

1. Ir a la carpeta del backend:
    ```bash
    cd parqueaderos_api_backend
    ```

2. Copiar y renombrar el archivo `.env.example` a `.env`:
    ```bash
    cp .env.example .env
    ```

3. Instalar dependencias:
    ```bash
    npm install
    ```

4. Iniciar el servidor:
    ```bash
    npm start
    ```

---

### 🔹 Frontend (Flutter)

1. Ir a la carpeta del frontend:
    ```bash
    cd parqueaderos_app
    ```

2. Instalar dependencias:
    ```bash
    flutter pub get
    ```

3. Ejecutar la app:
    ```bash
    flutter run
    ```



👥 Tipos de usuario
Conductor: puede buscar parqueaderos y reservar

Dueño: puede registrar y administrar parqueaderos

Administrador: supervisa y gestiona el sistema

📄 Licencia
MIT - Proyecto académico