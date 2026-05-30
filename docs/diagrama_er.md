# Diagrama Entidad-Relación - Modelo Operacional

## Diagrama ER

```mermaid
erDiagram
    ESTUDIANTE ||--o{ INSCRIPCION : "se inscribe"
    DOCENTE ||--o{ SECCION : "imparte"
    CURSO ||--o{ SECCION : "se ofrece como"
    PERIODO ||--o{ SECCION : "contiene"
    SECCION ||--o{ INSCRIPCION : "recibe"
    INSCRIPCION ||--o{ NOTA : "genera"

    ESTUDIANTE {
        NUMBER estudiante_id PK
        VARCHAR2 codigo UK "EST-001"
        VARCHAR2 nombre
        VARCHAR2 apellido
        VARCHAR2 email UK
        DATE fecha_nacimiento
        VARCHAR2 estado "ACTIVO|INACTIVO|GRADUADO"
        TIMESTAMP fecha_registro
    }

    DOCENTE {
        NUMBER docente_id PK
        VARCHAR2 codigo UK "DOC-001"
        VARCHAR2 nombre
        VARCHAR2 apellido
        VARCHAR2 email UK
        VARCHAR2 especialidad
        VARCHAR2 estado "ACTIVO|INACTIVO"
        TIMESTAMP fecha_registro
    }

    CURSO {
        NUMBER curso_id PK
        VARCHAR2 codigo UK "BD-201"
        VARCHAR2 nombre
        NUMBER creditos "1-10"
        VARCHAR2 descripcion
        VARCHAR2 estado "ACTIVO|INACTIVO"
    }

    PERIODO {
        NUMBER periodo_id PK
        VARCHAR2 codigo UK "2025-1"
        VARCHAR2 nombre
        DATE fecha_inicio
        DATE fecha_fin
        VARCHAR2 estado "ACTIVO|CERRADO|PLANIFICADO"
    }

    SECCION {
        NUMBER seccion_id PK
        NUMBER curso_id FK
        NUMBER docente_id FK
        NUMBER periodo_id FK
        VARCHAR2 codigo_seccion "A,B,C"
        NUMBER cupo_maximo
        NUMBER cupo_disponible
        VARCHAR2 horario
        VARCHAR2 aula
        VARCHAR2 estado "ABIERTA|CERRADA|CANCELADA"
    }

    INSCRIPCION {
        NUMBER inscripcion_id PK
        NUMBER estudiante_id FK
        NUMBER seccion_id FK
        TIMESTAMP fecha_inscripcion
        VARCHAR2 estado "INSCRITO|RETIRADO|COMPLETADO"
    }

    NOTA {
        NUMBER nota_id PK
        NUMBER inscripcion_id FK
        VARCHAR2 tipo_evaluacion
        NUMBER valor "0-100"
        TIMESTAMP fecha_registro
        VARCHAR2 observacion
    }

    AUDITORIA_ACADEMICA {
        NUMBER auditoria_id PK
        VARCHAR2 usuario
        TIMESTAMP fecha_hora
        VARCHAR2 operacion "INSERT|UPDATE|DELETE"
        VARCHAR2 tabla_afectada
        NUMBER pk_registro
        VARCHAR2 valor_anterior
        VARCHAR2 valor_nuevo
    }
```

## Cardinalidades

| Relación | Cardinalidad | Descripción |
|----------|--------------|-------------|
| ESTUDIANTE → INSCRIPCION | 1:N | Un estudiante puede tener muchas inscripciones |
| DOCENTE → SECCION | 1:N | Un docente imparte varias secciones |
| CURSO → SECCION | 1:N | Un curso puede tener varias secciones (A, B, C...) |
| PERIODO → SECCION | 1:N | Un período contiene muchas secciones |
| SECCION → INSCRIPCION | 1:N | Una sección recibe muchas inscripciones (limitado por cupo_maximo) |
| INSCRIPCION → NOTA | 1:N | Una inscripción genera varias notas (parciales, final, etc.) |

## Reglas de Integridad

1. **PK**: Todas las entidades tienen PK numérica generada por secuencia
2. **FK**: Todas las relaciones tienen FK con `REFERENCES`
3. **UNIQUE**:
   - `estudiante.codigo`, `estudiante.email`
   - `docente.codigo`, `docente.email`
   - `curso.codigo`
   - `periodo.codigo`
   - `seccion(curso_id, periodo_id, codigo_seccion)` — no duplicar secciones
   - `inscripcion(estudiante_id, seccion_id)` — un estudiante no se inscribe dos veces
4. **CHECK**:
   - `estudiante.estado IN ('ACTIVO','INACTIVO','GRADUADO')`
   - `docente.estado IN ('ACTIVO','INACTIVO')`
   - `curso.creditos BETWEEN 1 AND 10`
   - `periodo.fecha_fin > fecha_inicio`
   - `seccion.cupo_disponible >= 0` y `<= cupo_maximo`
   - `inscripcion.estado IN ('INSCRITO','RETIRADO','COMPLETADO')`
   - `nota.valor BETWEEN 0 AND 100`

## Flujo Principal de Negocio

```
1. Admin crea CURSO + PERIODO
2. Admin crea SECCION (curso + docente + periodo + cupo)
3. ESTUDIANTE se INSCRIBE en SECCION
   → cupo_disponible disminuye
4. DOCENTE registra NOTA por inscripción
5. Sistema calcula promedio y estado de aprobación
6. Período se CIERRA al finalizar
   → inscripciones pasan a COMPLETADO
```
