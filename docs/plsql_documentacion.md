# Documentación PL/SQL - ACME School
## Responsable: Emmanuel
## Tarea: T-024

---

## 1. PACKAGES

### 1.1 pkg_inscripciones

**Propósito**: Gestionar inscripciones de estudiantes en secciones

#### Procedimiento: inscribir_estudiante

```sql
PROCEDURE inscribir_estudiante(
    p_estudiante_id IN NUMBER,
    p_seccion_id    IN NUMBER,
    p_resultado     OUT VARCHAR2
);
```

**Descripción**: Inscribe un estudiante en una sección académica

**Parámetros**:
- `p_estudiante_id`: Identificador del estudiante
- `p_seccion_id`: Identificador de la sección
- `p_resultado`: Mensaje de resultado

**Validaciones**:
- Estudiante debe estar ACTIVO
- Período de la sección debe estar ACTIVO
- Debe haber cupo disponible (> 0)
- Estudiante no puede estar inscrito previamente en la misma sección

**Transaccionalidad**:
- Si todo es válido: INSERT inscripción + UPDATE cupo_disponible + COMMIT
- Si hay error: ROLLBACK automático

**Ejemplo de uso**:
```sql
DECLARE
    v_resultado VARCHAR2(500);
BEGIN
    pkg_inscripciones.inscribir_estudiante(1, 1, v_resultado);
    DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/
```

**Errores posibles**:
- ORA-20001: Estudiante no está activo
- ORA-20002: Período no está activo
- ORA-20003: No hay cupo disponible
- ORA-20004: Estudiante ya está inscrito

---

#### Procedimiento: retirar_estudiante

```sql
PROCEDURE retirar_estudiante(
    p_inscripcion_id IN NUMBER,
    p_resultado      OUT VARCHAR2
);
```

**Descripción**: Retira un estudiante de una sección

**Parámetros**:
- `p_inscripcion_id`: Identificador de la inscripción
- `p_resultado`: Mensaje de resultado

**Transaccionalidad**:
- UPDATE inscripción estado = 'RETIRADO'
- UPDATE cupo_disponible += 1
- COMMIT si éxito, ROLLBACK si error

**Ejemplo de uso**:
```sql
DECLARE
    v_resultado VARCHAR2(500);
BEGIN
    pkg_inscripciones.retirar_estudiante(1, v_resultado);
    DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/
```

---

### 1.2 pkg_notas

**Propósito**: Registrar y gestionar notas de estudiantes

#### Procedimiento: registrar_nota

```sql
PROCEDURE registrar_nota(
    p_inscripcion_id IN NUMBER,
    p_tipo_evaluacion IN VARCHAR2,
    p_valor IN NUMBER,
    p_resultado OUT VARCHAR2
);
```

**Descripción**: Registra una nueva nota para una inscripción

**Parámetros**:
- `p_inscripcion_id`: Identificador de la inscripción
- `p_tipo_evaluacion`: Tipo (Parcial, Final, Tarea, etc.)
- `p_valor`: Valor de la nota (0-100)
- `p_resultado`: Mensaje de resultado

**Validaciones**:
- Inscripción debe existir
- Inscripción debe estar en estado INSCRITO
- Nota debe estar entre 0 y 100

**Ejemplo de uso**:
```sql
DECLARE
    v_resultado VARCHAR2(500);
BEGIN
    pkg_notas.registrar_nota(1, 'Parcial 1', 85, v_resultado);
    DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/
```

---

#### Procedimiento: actualizar_nota

```sql
PROCEDURE actualizar_nota(
    p_nota_id IN NUMBER,
    p_valor IN NUMBER,
    p_resultado OUT VARCHAR2
);
```

**Descripción**: Actualiza el valor de una nota

**Parámetros**:
- `p_nota_id`: Identificador de la nota
- `p_valor`: Nuevo valor (0-100)
- `p_resultado`: Mensaje de resultado

**Validaciones**:
- Nota debe existir
- Valor debe estar entre 0 y 100

---

#### Función: obtener_promedio

```sql
FUNCTION obtener_promedio(p_estudiante_id IN NUMBER) RETURN NUMBER;
```

**Descripción**: Obtiene el promedio de notas de un estudiante

**Parámetro**:
- `p_estudiante_id`: Identificador del estudiante

**Retorna**:
- NUMBER: Promedio calculado, NULL si no hay notas

**Ejemplo de uso**:
```sql
DECLARE
    v_promedio NUMBER;
BEGIN
    v_promedio := pkg_notas.obtener_promedio(1);
    DBMS_OUTPUT.PUT_LINE('Promedio: ' || v_promedio);
END;
/
```

---

## 2. FUNCIONES

### 2.1 fn_promedio_estudiante

```sql
FUNCTION fn_promedio_estudiante(p_estudiante_id IN NUMBER) RETURN NUMBER;
```

**Descripción**: Calcula el promedio de todas las notas de un estudiante

**Parámetro**:
- `p_estudiante_id`: Identificador del estudiante

**Retorna**:
- Promedio redondeado a 2 decimales, NULL si no hay notas

**Lógica**:
```
SELECT AVG(nota.valor) 
WHERE inscripción.estudiante_id = p_estudiante_id
```

**Ejemplo**:
```sql
SELECT fn_promedio_estudiante(1) AS promedio FROM DUAL;
```

---

### 2.2 fn_cupo_disponible

```sql
FUNCTION fn_cupo_disponible(p_seccion_id IN NUMBER) RETURN NUMBER;
```

**Descripción**: Retorna el cupo disponible en una sección

**Parámetro**:
- `p_seccion_id`: Identificador de la sección

**Retorna**:
- Número de cupos disponibles, NULL si la sección no existe

**Ejemplo**:
```sql
SELECT fn_cupo_disponible(1) AS cupo FROM DUAL;
```

---

### 2.3 fn_estado_aprobacion

```sql
FUNCTION fn_estado_aprobacion(p_inscripcion_id IN NUMBER) RETURN VARCHAR2;
```

**Descripción**: Determina si un estudiante aprobó un curso

**Parámetro**:
- `p_inscripcion_id`: Identificador de la inscripción

**Retorna**:
- 'APROBADO': si promedio >= 61
- 'REPROBADO': si promedio < 61
- 'SIN_NOTAS': si no hay notas registradas
- 'SIN_CALIFICACION': si no hay datos
- 'ERROR': si hay error

**Ejemplo**:
```sql
SELECT fn_estado_aprobacion(1) AS estado FROM DUAL;
```

---

## 3. TRIGGERS

### 3.1 Auditoría

#### trg_auditoria_inscripcion

**Eventos**: AFTER INSERT, UPDATE, DELETE ON inscripcion

**Acción**: Registra cambios en tabla AUDITORIA_ACADEMICA

**Datos Capturados**:
- Usuario (USER)
- Timestamp (SYSTIMESTAMP)
- Tipo de operación (INSERT/UPDATE/DELETE)
- Tabla afectada (INSCRIPCION)
- PK del registro
- Valores anteriores (:OLD)
- Valores nuevos (:NEW)

#### trg_auditoria_nota

**Eventos**: AFTER INSERT, UPDATE, DELETE ON nota

**Acción**: Registra cambios en tabla AUDITORIA_ACADEMICA

---

### 3.2 Validación

#### trg_validacion_nota

**Evento**: BEFORE INSERT, UPDATE ON nota

**Validación**: Nota debe estar entre 0 y 100

**Error**: ORA-20001 si falla

#### trg_validacion_inscripcion

**Evento**: BEFORE INSERT ON inscripcion

**Validación**: Período asociado debe estar ACTIVO

**Error**: ORA-20002 si período no está activo

---

## 4. MANEJO DE EXCEPCIONES

Todas las procedures incluyen manejo de excepciones:

```sql
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        p_resultado := 'ERROR: Registro no encontrado';
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        p_resultado := 'ERROR: Duplicación de registro';
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR: ' || SQLERRM;
END;
```

---

## 5. TRANSACCIONALIDAD

- **Inscripción**: INSERT + UPDATE cupo = 1 transacción atómica
- **Nota**: INSERT nota = transacción independiente
- **Auditoría**: Se registra automáticamente por triggers

---

## 6. FLUJO TÍPICO DE USO

### Inscribir estudiante y registrar notas

```sql
DECLARE
    v_resultado VARCHAR2(500);
BEGIN
    -- Paso 1: Inscribir estudiante
    pkg_inscripciones.inscribir_estudiante(1, 5, v_resultado);
    DBMS_OUTPUT.PUT_LINE(v_resultado);
    
    -- Paso 2: Registrar notas
    pkg_notas.registrar_nota(1, 'Parcial 1', 75, v_resultado);
    DBMS_OUTPUT.PUT_LINE(v_resultado);
    
    -- Paso 3: Obtener promedio
    DBMS_OUTPUT.PUT_LINE('Promedio: ' || pkg_notas.obtener_promedio(1));
    
    -- Paso 4: Ver estado de aprobación
    DBMS_OUTPUT.PUT_LINE('Estado: ' || fn_estado_aprobacion(1));
END;
/
```

---

## 7. CONSIDERACIONES IMPORTANTES

1. **COMMIT/ROLLBACK**: Todas las procedures hacen COMMIT/ROLLBACK explícitamente
2. **Integridad Referencial**: Los triggers validan FK antes de permitir inserciones
3. **Auditoría Automática**: No requiere código adicional, los triggers se encargan
4. **Excepciones**: Todas capturadas y reportadas con mensajes claros
5. **Secuencias**: Usadas para generar IDs automáticamente

---

**Fin de Documentación - T-024**
