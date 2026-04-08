# Dockerfile multi-stage para Ticketera

# ETAPA 1: Construcción del Frontend
FROM node:20-alpine AS build-frontend
WORKDIR /app/front-tickets
COPY front-tickets/package*.json ./
RUN npm install
COPY front-tickets/ ./
RUN npm run build

# ETAPA 2: Preparación del Backend y Final
FROM node:20-alpine
WORKDIR /app

# Copiar el backend
COPY back-tickets/package*.json ./back-tickets/
WORKDIR /app/back-tickets
RUN npm install --production

COPY back-tickets/ ./

# Copiar el build del frontend a la carpeta public del backend
COPY --from=build-frontend /app/front-tickets/dist ./public

# Copiar activos específicos para correos electrónicos (el build dist no siempre mantiene nombres originales)
COPY --from=build-frontend /app/front-tickets/src/assets/logo.png ./assets/
COPY --from=build-frontend /app/front-tickets/src/assets/favicon.png ./assets/

# Copiar el script de inicialización para que el código pueda usarlo
COPY database/ ./database/

# Configurar variables de entorno por defecto
ENV PORT=${PORT}
ENV NODE_ENV=production

EXPOSE ${PORT}

CMD ["node", "index.js"]
