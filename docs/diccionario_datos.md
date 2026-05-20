# Diccionario de Datos - Sistema de Gestión Académica

## Responsable: Emmanuel
## Tarea: T-007

## Entidades del Modelo Operacional

### Estudiante
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| estudiante_id | NUMBER | PK | Identificador único |
| codigo | VARCHAR2(20) | UNIQUE, NOT NULL | Código de matrícula |
| nombre | VARCHAR2(100) | NOT NULL | Nombre del estudiante |
| apellido | VARCHAR2(100) | NOT NULL | Apellido del estudiante |
| email | VARCHAR2(150) | UNIQUE | Correo electrónico |
| fecha_nacimiento | DATE | | Fecha de nacimiento |
| estado | VARCHAR2(20) | CHECK | ACTIVO, INACTIVO, GRADUADO |
| fecha_registro | TIMESTAMP | DEFAULT SYSTIMESTAMP | Fecha de registro |

### Docente
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| docente_id | NUMBER | PK | Identificador único |
| codigo | VARCHAR2(20) | UNIQUE, NOT NULL | Código de empleado |
| nombre | VARCHAR2(100) | NOT NULL | Nombre del docente |
| apellido | VARCHAR2(100) | NOT NULL | Apellido del docente |
| email | VARCHAR2(150) | UNIQUE | Correo electrónico |
| especialidad | VARCHAR2(100) | | Área de especialización |
| estado | VARCHAR2(20) | CHECK | ACTIVO, INACTIVO |

### Curso
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| curso_id | NUMBER | PK | Identificador único |
| codigo | VARCHAR2(20) | UNIQUE, NOT NULL | Código del curso |
| nombre | VARCHAR2(150) | NOT NULL | Nombre del curso |
| creditos | NUMBER(2) | CHECK > 0 | Créditos académicos |
| descripcion | VARCHAR2(500) | | Descripción del curso |
| estado | VARCHAR2(20) | CHECK | ACTIVO, INACTIVO |

### Período
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| periodo_id | NUMBER | PK | Identificador único |
| codigo | VARCHAR2(20) | UNIQUE, NOT NULL | Ej: 2025-1 |
| nombre | VARCHAR2(100) | NOT NULL | Nombre del período |
| fecha_inicio | DATE | NOT NULL | Inicio del período |
| fecha_fin | DATE | NOT NULL | Fin del período |
| estado | VARCHAR2(20) | CHECK | ACTIVO, CERRADO, PLANIFICADO |

### Sección
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| seccion_id | NUMBER | PK | Identificador único |
| curso_id | NUMBER | FK → curso | Curso asignado |
| docente_id | NUMBER | FK → docente | Docente asignado |
| periodo_id | NUMBER | FK → periodo | Período académico |
| codigo_seccion | VARCHAR2(10) | NOT NULL | Ej: A, B, C |
| cupo_maximo | NUMBER(3) | CHECK > 0 | Capacidad máxima |
| cupo_disponible | NUMBER(3) | CHECK >= 0 | Cupos restantes |
| horario | VARCHAR2(100) | | Horario de clase |
| aula | VARCHAR2(50) | | Aula asignada |
| estado | VARCHAR2(20) | CHECK | ABIERTA, CERRADA, CANCELADA |

### Inscripción
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| inscripcion_id | NUMBER | PK | Identificador único |
| estudiante_id | NUMBER | FK → estudiante | Estudiante inscrito |
| seccion_id | NUMBER | FK → seccion | Sección elegida |
| fecha_inscripcion | TIMESTAMP | DEFAULT SYSTIMESTAMP | Fecha/hora de inscripción |
| estado | VARCHAR2(20) | CHECK | INSCRITO, RETIRADO, COMPLETADO |
| **UNIQUE** | | (estudiante_id, seccion_id) | No duplicar inscripción |

### Nota
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| nota_id | NUMBER | PK | Identificador único |
| inscripcion_id | NUMBER | FK → inscripcion | Inscripción asociada |
| tipo_evaluacion | VARCHAR2(50) | NOT NULL | Parcial, Final, Tarea, etc. |
| valor | NUMBER(5,2) | CHECK 0-100 | Valor de la nota |
| fecha_registro | TIMESTAMP | DEFAULT SYSTIMESTAMP | Fecha de registro |
| observacion | VARCHAR2(200) | | Comentarios |

---

## Reglas de Negocio

1. **Cupo:** Una sección no puede tener más inscritos que su cupo_maximo
2. **Nota:** Siempre entre 0 y 100
3. **Inscripción única:** Un estudiante no puede inscribirse dos veces en la misma sección
4. **Período activo:** Solo se puede inscribir en períodos con estado ACTIVO
5. **Estados de inscripción:** INSCRITO → RETIRADO o COMPLETADO (no reversible)
6. **Aprobación:** Nota promedio >= 61 para aprobar (configurable)
