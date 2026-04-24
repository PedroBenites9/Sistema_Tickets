-- 1. Seleccionamos la base de datos (y la creamos por si es un Docker nuevo)
CREATE DATABASE IF NOT EXISTS sistema_tickets;
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
-- 👇 NUEVAS TABLAS MAESTRAS 👇
DROP TABLE IF EXISTS areas;
DROP TABLE IF EXISTS categorias_rutinas;
DROP TABLE IF EXISTS frecuencias_permitidas;

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

-- 👇 NUEVAS TABLAS MAESTRAS 👇

CREATE TABLE areas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    activa TINYINT(1) DEFAULT 1
);

CREATE TABLE categorias_rutinas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE frecuencias_permitidas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre_mostrar VARCHAR(100) NOT NULL
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

-- ==============================================================================
-- 5. INSERCIÓN DE DATOS INICIALES (Para que el sistema no arranque vacío)
-- ==============================================================================

INSERT IGNORE INTO areas (codigo, nombre) VALUES 
('Tesoreria', 'Tesorería'),
('Sindico', 'Síndico'),
('Operaciones', 'Operaciones'),
('Comercial', 'Comercial'),
('Logistica', 'Logística'),
('RRHH', 'RRHH'),
('Incorporaciones', 'Incorporaciones'),
('Habilitaciones', 'Habilitaciones'),
('Tecnologia', 'Tecnología (IT)'),
('Presidencia', 'Presidencia'),
('CoordinadorGral', 'Coordinador Gral.');

INSERT IGNORE INTO categorias_rutinas (nombre) VALUES 
('Limpieza / General'), ('CCTV y Servidores'), ('Redes'), ('Reportes');

INSERT IGNORE INTO frecuencias_permitidas (codigo, nombre_mostrar) VALUES 
('Diaria', 'Todos los días'),
('Semanal', 'Una vez por semana'),
('Mensual', 'Una vez al mes'),
('Dias Especificos', 'Días Específicos'),
('Fecha Unica', 'Fecha Única'); 