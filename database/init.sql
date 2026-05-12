-- 1. Seleccionamos la base de datos
USE sistema_tickets;

-- ==============================================================================
-- 2. LIMPIEZA PREVIA (Drop en orden inverso a las dependencias)
-- ==============================================================================
DROP TABLE IF EXISTS comentarios;
DROP TABLE IF EXISTS historial_tareas;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS tareas_diarias;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS usuarios;

-- ==============================================================================
-- 3. CREACIÓN DE TABLAS PRINCIPALES (Sin dependencias)
-- ==============================================================================

-- Tabla de Usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(50) DEFAULT 'final',
    area VARCHAR(100),
    codigo_recuperacion VARCHAR(6),
    vencimiento_codigo DATETIME,
    status INT DEFAULT 1,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL UNIQUE,
    email VARCHAR(150),
    telefono VARCHAR(50),
    direccion VARCHAR(255),
    status INT DEFAULT 1,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Tickets
CREATE TABLE tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE,
    asunto VARCHAR(255) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    prioridad VARCHAR(50) NOT NULL,
    estado VARCHAR(50) DEFAULT 'Abierto',
    descripcion TEXT,
    tipo_origen VARCHAR(50) DEFAULT 'Interno',
    solicitante VARCHAR(100),
    cliente VARCHAR(150),
    tecnico_asignado VARCHAR(100),
    status INT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_finalizado TIMESTAMP NULL
);

-- Tabla de Tareas Diarias / Mantenimiento
CREATE TABLE tareas_diarias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    frecuencia VARCHAR(50) NOT NULL,
    hora_programada VARCHAR(10) NOT NULL,
    proxima_ejecucion DATETIME,
    dias_especificos JSON,
    fecha_unica DATE,
    estado VARCHAR(50) DEFAULT 'Pendiente',
    en_pausa BOOLEAN DEFAULT FALSE,
    fecha_inicio_real DATETIME,
    tiempo_acumulado_minutos FLOAT DEFAULT 0,
    hora_primer_inicio DATETIME,
    status INT DEFAULT 1,
    ultima_vez_completada DATETIME
);

-- ==============================================================================
-- 4. CREACIÓN DE TABLAS HIJAS (Con Claves Foráneas / Foreign Keys)
-- ==============================================================================

-- Tabla de Comentarios (Depende de Tickets)
CREATE TABLE comentarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL,
    autor VARCHAR(100) NOT NULL,
    mensaje TEXT NOT NULL,
    status INT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE
);

-- Tabla de Historial de Tareas (Depende de Tareas Diarias)
CREATE TABLE historial_tareas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tarea_id INT NOT NULL,
    titulo_tarea VARCHAR(255) NOT NULL,
    usuario_que_completo VARCHAR(100),
    tiempo_total_minutos FLOAT DEFAULT 0,
    fecha_inicio DATETIME,
    status INT DEFAULT 1,
    fecha_completada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tarea_id) REFERENCES tareas_diarias(id) ON DELETE CASCADE
);
