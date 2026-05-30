-- Dataset de prueba: 8 docentes, 12 cursos, 4 periodos, 25 estudiantes y 18 secciones.
-- Incluye casos para demos: sección con cupo 0 y períodos cerrados.
-- Ejecutar como acme_school.

-- ==================== DOCENTES (8) ====================
INSERT INTO docente (codigo, nombre, apellido, email, especialidad) VALUES ('DOC-001', 'Carlos', 'Mendoza', 'cmendoza@acme.edu', 'Matemáticas');
INSERT INTO docente (codigo, nombre, apellido, email, especialidad) VALUES ('DOC-002', 'María', 'Fernández', 'mfernandez@acme.edu', 'Programación');
INSERT INTO docente (codigo, nombre, apellido, email, especialidad) VALUES ('DOC-003', 'Roberto', 'García', 'rgarcia@acme.edu', 'Bases de Datos');
INSERT INTO docente (codigo, nombre, apellido, email, especialidad) VALUES ('DOC-004', 'Ana', 'López', 'alopez@acme.edu', 'Redes');
INSERT INTO docente (codigo, nombre, apellido, email, especialidad) VALUES ('DOC-005', 'Jorge', 'Ramírez', 'jramirez@acme.edu', 'Sistemas Operativos');
INSERT INTO docente (codigo, nombre, apellido, email, especialidad) VALUES ('DOC-006', 'Laura', 'Castillo', 'lcastillo@acme.edu', 'Inteligencia Artificial');
INSERT INTO docente (codigo, nombre, apellido, email, especialidad) VALUES ('DOC-007', 'Pedro', 'Morales', 'pmorales@acme.edu', 'Ingeniería de Software');
INSERT INTO docente (codigo, nombre, apellido, email, especialidad) VALUES ('DOC-008', 'Sandra', 'Vega', 'svega@acme.edu', 'Estadística');

-- ==================== CURSOS (12) ====================
INSERT INTO curso (codigo, nombre, creditos, descripcion) VALUES ('MAT-101', 'Cálculo I', 5, 'Fundamentos de cálculo diferencial e integral');
INSERT INTO curso (codigo, nombre, creditos, descripcion) VALUES ('MAT-201', 'Álgebra Lineal', 4, 'Vectores, matrices y transformaciones lineales');
INSERT INTO curso (codigo, nombre, creditos, descripcion) VALUES ('PRG-101', 'Programación I', 5, 'Fundamentos de programación con Java');
INSERT INTO curso (codigo, nombre, creditos, descripcion) VALUES ('PRG-201', 'Estructuras de Datos', 4, 'Listas, árboles, grafos y algoritmos');
INSERT INTO curso (codigo, nombre, creditos, descripcion) VALUES ('BD-101', 'Bases de Datos I', 4, 'Modelo relacional y SQL');
INSERT INTO curso (codigo, nombre, creditos, descripcion) VALUES ('BD-201', 'Bases de Datos II', 4, 'Transacciones, PL/SQL y optimización');
INSERT INTO curso (codigo, nombre, creditos, descripcion) VALUES ('RED-101', 'Redes de Computadoras', 4, 'Protocolos, topologías y configuración');
INSERT INTO curso (codigo, nombre, creditos, descripcion) VALUES ('SO-101', 'Sistemas Operativos', 4, 'Procesos, memoria y sistemas de archivos');
INSERT INTO curso (codigo, nombre, creditos, descripcion) VALUES ('IA-101', 'Inteligencia Artificial', 4, 'Machine learning y redes neuronales');
INSERT INTO curso (codigo, nombre, creditos, descripcion) VALUES ('IS-101', 'Ingeniería de Software I', 4, 'Metodologías ágiles y diseño de sistemas');
INSERT INTO curso (codigo, nombre, creditos, descripcion) VALUES ('EST-101', 'Estadística', 4, 'Probabilidad y estadística descriptiva');
INSERT INTO curso (codigo, nombre, creditos, descripcion) VALUES ('PRG-301', 'Desarrollo Web', 3, 'Frontend y backend con tecnologías modernas');

-- ==================== PERIODOS (4) ====================
INSERT INTO periodo (codigo, nombre, fecha_inicio, fecha_fin, estado) VALUES ('2024-1', 'Primer Semestre 2024', DATE '2024-01-15', DATE '2024-06-15', 'CERRADO');
INSERT INTO periodo (codigo, nombre, fecha_inicio, fecha_fin, estado) VALUES ('2024-2', 'Segundo Semestre 2024', DATE '2024-07-15', DATE '2024-12-15', 'CERRADO');
INSERT INTO periodo (codigo, nombre, fecha_inicio, fecha_fin, estado) VALUES ('2025-1', 'Primer Semestre 2025', DATE '2025-01-15', DATE '2025-06-15', 'ACTIVO');
INSERT INTO periodo (codigo, nombre, fecha_inicio, fecha_fin, estado) VALUES ('2025-2', 'Segundo Semestre 2025', DATE '2025-07-15', DATE '2025-12-15', 'PLANIFICADO');

-- ==================== ESTUDIANTES (25) ====================
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-001', 'Juan', 'Pérez', 'jperez@acme.edu', DATE '2002-03-15');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-002', 'María', 'González', 'mgonzalez@acme.edu', DATE '2001-07-22');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-003', 'Carlos', 'Rodríguez', 'crodriguez@acme.edu', DATE '2003-01-10');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-004', 'Ana', 'Martínez', 'amartinez@acme.edu', DATE '2002-11-05');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-005', 'Luis', 'Hernández', 'lhernandez@acme.edu', DATE '2001-09-18');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-006', 'Sofía', 'Díaz', 'sdiaz@acme.edu', DATE '2003-04-25');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-007', 'Diego', 'Torres', 'dtorres@acme.edu', DATE '2002-08-30');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-008', 'Valentina', 'Flores', 'vflores@acme.edu', DATE '2001-12-12');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-009', 'Andrés', 'Rivera', 'arivera@acme.edu', DATE '2003-06-08');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-010', 'Camila', 'Vargas', 'cvargas@acme.edu', DATE '2002-02-14');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-011', 'Sebastián', 'Castro', 'scastro@acme.edu', DATE '2001-05-20');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-012', 'Isabella', 'Moreno', 'imoreno@acme.edu', DATE '2003-10-03');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-013', 'Mateo', 'Jiménez', 'mjimenez@acme.edu', DATE '2002-07-17');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-014', 'Luciana', 'Ruiz', 'lruiz@acme.edu', DATE '2001-04-09');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-015', 'Daniel', 'Ortiz', 'dortiz@acme.edu', DATE '2003-08-21');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-016', 'Gabriela', 'Núñez', 'gnunez@acme.edu', DATE '2002-01-28');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-017', 'Alejandro', 'Medina', 'amedina@acme.edu', DATE '2001-11-14');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-018', 'Fernanda', 'Herrera', 'fherrera@acme.edu', DATE '2003-03-06');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-019', 'Nicolás', 'Aguilar', 'naguilar@acme.edu', DATE '2002-09-23');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-020', 'Valeria', 'Peña', 'vpena@acme.edu', DATE '2001-06-30');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-021', 'Emilio', 'Sandoval', 'esandoval@acme.edu', DATE '2003-12-01');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-022', 'Regina', 'Delgado', 'rdelgado@acme.edu', DATE '2002-05-11');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-023', 'Tomás', 'Guerrero', 'tguerrero@acme.edu', DATE '2001-08-07');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-024', 'Mariana', 'Reyes', 'mreyes@acme.edu', DATE '2003-02-19');
INSERT INTO estudiante (codigo, nombre, apellido, email, fecha_nacimiento) VALUES ('EST-025', 'Santiago', 'Cruz', 'scruz@acme.edu', DATE '2002-10-26');

COMMIT;

-- ==================== SECCIONES - PERIODO 2024-1 CERRADO (5) ====================
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula, estado)
  VALUES (1, 1, 1, 'A', 30, 22, 'Lun-Mie 07:00-08:30', 'A-101', 'CERRADA');
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula, estado)
  VALUES (3, 2, 1, 'A', 25, 17, 'Mar-Jue 09:00-10:30', 'LAB-01', 'CERRADA');
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula, estado)
  VALUES (5, 3, 1, 'A', 30, 23, 'Lun-Mie 10:00-11:30', 'A-201', 'CERRADA');
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula, estado)
  VALUES (7, 4, 1, 'A', 25, 20, 'Mar-Jue 14:00-15:30', 'LAB-02', 'CERRADA');
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula, estado)
  VALUES (11, 8, 1, 'A', 35, 28, 'Vie 08:00-11:00', 'A-301', 'CERRADA');

-- ==================== SECCIONES - PERIODO 2024-2 CERRADO (5) ====================
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula, estado)
  VALUES (2, 1, 2, 'A', 30, 21, 'Lun-Mie 07:00-08:30', 'A-101', 'CERRADA');
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula, estado)
  VALUES (4, 2, 2, 'A', 25, 16, 'Mar-Jue 09:00-10:30', 'LAB-01', 'CERRADA');
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula, estado)
  VALUES (6, 3, 2, 'A', 30, 22, 'Lun-Mie 10:00-11:30', 'A-201', 'CERRADA');
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula, estado)
  VALUES (8, 5, 2, 'A', 25, 18, 'Mar-Jue 14:00-15:30', 'A-202', 'CERRADA');
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula, estado)
  VALUES (9, 6, 2, 'A', 20, 14, 'Vie 08:00-11:00', 'LAB-03', 'CERRADA');

-- ==================== SECCIONES - PERIODO 2025-1 ACTIVO (8) ====================
-- Sección 11: Cálculo I - A (cupo normal)
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula)
  VALUES (1, 1, 3, 'A', 30, 15, 'Lun-Mie 07:00-08:30', 'A-101');
-- Sección 12: Cálculo I - B (cupo alto)
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula)
  VALUES (1, 1, 3, 'B', 30, 25, 'Mar-Jue 07:00-08:30', 'A-102');
-- Sección 13: Programación I - A
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula)
  VALUES (3, 2, 3, 'A', 25, 10, 'Mar-Jue 09:00-10:30', 'LAB-01');
-- Sección 14: BD I - A
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula)
  VALUES (5, 3, 3, 'A', 30, 18, 'Lun-Mie 10:00-11:30', 'A-201');
-- Sección 15: BD II - A (cupo bajo = 5)
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula)
  VALUES (6, 3, 3, 'A', 25, 5, 'Mar-Jue 10:00-11:30', 'A-201');
-- Sección 16: Ing. Software - A
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula)
  VALUES (10, 7, 3, 'A', 30, 20, 'Lun-Mie 14:00-15:30', 'A-301');
-- Sección 17: Desarrollo Web - A
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula)
  VALUES (12, 2, 3, 'A', 20, 8, 'Vie 08:00-11:00', 'LAB-01');
-- Sección 18: BD II - B (CUPO LLENO = 0, para demo de ROLLBACK)
INSERT INTO seccion (curso_id, docente_id, periodo_id, codigo_seccion, cupo_maximo, cupo_disponible, horario, aula)
  VALUES (6, 3, 3, 'B', 25, 0, 'Lun-Mie 16:00-17:30', 'A-202');

COMMIT;
