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

### Auditoría Académica
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| auditoria_id | NUMBER | PK | Identificador único |
| usuario | VARCHAR2(50) | DEFAULT USER | Usuario que ejecutó la acción |
| fecha_hora | TIMESTAMP | DEFAULT SYSTIMESTAMP | Fecha y hora exacta |
| operacion | VARCHAR2(10) | CHECK IN (INSERT, UPDATE, DELETE) | Tipo de operación |
| tabla_afectada | VARCHAR2(50) | NOT NULL | Tabla modificada |
| pk_registro | NUMBER | | PK del registro afectado |
| valor_anterior | VARCHAR2(4000) | | Valor previo (para UPDATE/DELETE) |
| valor_nuevo | VARCHAR2(4000) | | Valor nuevo (para INSERT/UPDATE) |

---

## Secuencias

| Secuencia | Inicio | Incremento | Propósito |
|-----------|--------|-----------|----------|
| seq_estudiante | 1 | 1 | PK para tabla estudiante |
| seq_docente | 1 | 1 | PK para tabla docente |
| seq_curso | 1 | 1 | PK para tabla curso |
| seq_periodo | 1 | 1 | PK para tabla periodo |
| seq_seccion | 1 | 1 | PK para tabla seccion |
| seq_inscripcion | 1 | 1 | PK para tabla inscripcion |
| seq_nota | 1 | 1 | PK para tabla nota |
| seq_auditoria | 1 | 1 | PK para tabla auditoria_academica |

---

## Índices

| Índice | Tabla | Columna(s) | Tipo | Propósito |
|--------|-------|-----------|------|----------|
| pk_estudiante | estudiante | estudiante_id | PRIMARY KEY | Clave primaria |
| uk_estudiante_codigo | estudiante | codigo | UNIQUE | Código de matrícula único |
| uk_estudiante_email | estudiante | email | UNIQUE | Email único |
| pk_docente | docente | docente_id | PRIMARY KEY | Clave primaria |
| uk_docente_codigo | docente | codigo | UNIQUE | Código de empleado único |
| uk_docente_email | docente | email | UNIQUE | Email único |
| pk_curso | curso | curso_id | PRIMARY KEY | Clave primaria |
| uk_curso_codigo | curso | codigo | UNIQUE | Código de curso único |
| pk_periodo | periodo | periodo_id | PRIMARY KEY | Clave primaria |
| uk_periodo_codigo | periodo | codigo | UNIQUE | Código de período único |
| pk_seccion | seccion | seccion_id | PRIMARY KEY | Clave primaria |
| uk_seccion | seccion | (curso_id, periodo_id, codigo_seccion) | UNIQUE | Sección única por período |
| fk_seccion_curso | seccion | curso_id | FOREIGN KEY | Referencia a curso |
| fk_seccion_docente | seccion | docente_id | FOREIGN KEY | Referencia a docente |
| fk_seccion_periodo | seccion | periodo_id | FOREIGN KEY | Referencia a periodo |
| pk_inscripcion | inscripcion | inscripcion_id | PRIMARY KEY | Clave primaria |
| uk_inscripcion | inscripcion | (estudiante_id, seccion_id) | UNIQUE | Un estudiante por sección |
| fk_inscripcion_estudiante | inscripcion | estudiante_id | FOREIGN KEY | Referencia a estudiante |
| fk_inscripcion_seccion | inscripcion | seccion_id | FOREIGN KEY | Referencia a seccion |
| pk_nota | nota | nota_id | PRIMARY KEY | Clave primaria |
| fk_nota_inscripcion | nota | inscripcion_id | FOREIGN KEY | Referencia a inscripcion |
| pk_auditoria | auditoria_academica | auditoria_id | PRIMARY KEY | Clave primaria |

---

## Reglas de Negocio

1. **Cupo:** Una sección no puede tener más inscritos que su cupo_maximo
2. **Nota:** Siempre entre 0 y 100 (validar con TRIGGER)
3. **Inscripción única:** Un estudiante no puede inscribirse dos veces en la misma sección (UNIQUE constraint)
4. **Período activo:** Solo se puede inscribir en períodos con estado ACTIVO (validar en procedure)
5. **Estados de inscripción:** INSCRITO → RETIRADO o COMPLETADO (no reversible)
6. **Aprobación:** Promedio >= 61 para aprobar (función: fn_estado_aprobacion)
7. **Auditoría:** Registrar todos los cambios en INSCRIPCION y NOTA automáticamente (TRIGGER)
8. **Integridad referencial:** Todas las FKs con ON DELETE RESTRICT (no permitir eliminar con dependientes)

---

## Relaciones y Dependencias

```
PERIODO
├─→ SECCION (1 período → N secciones)
    ├─→ CURSO (N secciones → 1 curso)
    ├─→ DOCENTE (N secciones → 1 docente)
    └─→ INSCRIPCION (1 sección → N inscripciones)
        ├─→ ESTUDIANTE (N inscripciones → 1 estudiante)
        └─→ NOTA (1 inscripción → N notas)
            └─→ AUDITORIA_ACADEMICA (cambios auditados)
```

---

## Convenciones de Nombres

| Elemento | Formato | Ejemplo |
|----------|---------|---------|
| Tabla | Singular, minúsculas | estudiante, curso, inscripcion |
| Columna PK | {tabla}_id | estudiante_id, curso_id |
| Columna FK | {tabla_ref}_id | estudiante_id, curso_id |
| Secuencia | seq_{tabla} | seq_estudiante, seq_curso |
| Índice PK | pk_{tabla} | pk_estudiante |
| Índice UK | uk_{tabla}_{columna} | uk_estudiante_codigo |
| Índice FK | fk_{tabla}_{tabla_ref} | fk_inscripcion_estudiante |
| Trigger | trg_{accion}_{tabla} | trg_auditoria_inscripcion |
| Package | pkg_{modulo} | pkg_inscripciones, pkg_notas |
| Función | fn_{verbo}_{sustantivo} | fn_promedio_estudiante |
| Procedure | pr_{verbo}_{sustantivo} | pr_inscribir_estudiante |
