# Plan de Trabajo - Emmanuel Rodriguez
## ACME School - Sistema de Gestión Académica

### 📊 Resumen de Tareas (13 Total)
- **Completadas**: 0
- **Pendientes**: 13
- **Bloqueantes**: 3
- **Opcional**: 2

---

## 🎯 FASE 1: PREPARACIÓN (Prioridad: CRÍTICA)

### [T-007] Diccionario de Datos ⏱️ 30 min
**Estado**: PENDIENTE | **Archivo**: `docs/diccionario_datos.md`
- ✅ Expandir tablas incompletas (ya existe template)
- ✅ Documentar TODAS las entidades (8 tablas)
- ✅ Incluir restricciones, índices, secuencias

### [T-020] Tabla de Auditoría ⏱️ 5 min
**Estado**: TABLA EXISTE | **Archivo**: `database/init-scripts/03_create_tables.sql`
- ✅ Crear SEQUENCE seq_auditoria
- ✅ Verificar estructura: auditoria_academica (id, usuario, fecha_hora, operacion, tabla_afectada, pk_registro, valor_anterior, valor_nuevo)

### [T-010] Pruebas Integridad Referencial ⏱️ 20 min
**Estado**: PENDIENTE | **Archivo**: `database/scripts_prueba_integridad.sql` (CREAR)
- ✅ Script que valida todas las Foreign Keys
- ✅ Script que intenta violar constraints
- ✅ Capturar y mostrar errores

---

## 💻 FASE 2: CORE PL/SQL (Prioridad: ALTA)

### [T-011] Package pkg_inscripciones ⏱️ 60 min
**Estado**: TEMPLATE | **Archivo**: `plsql/packages/pkg_inscripciones.sql`

**Procedimientos**:
```
1. inscribir_estudiante(p_estudiante_id, p_seccion_id, OUT p_resultado)
   - Validar: período ACTIVO, estudiante ACTIVO, cupo > 0, no duplicado
   - INSERT inscripción
   - UPDATE cupo_disponible
   - COMMIT/ROLLBACK

2. retirar_estudiante(p_inscripcion_id, OUT p_resultado)
   - UPDATE inscripción estado = 'RETIRADO'
   - UPDATE cupo_disponible
   - COMMIT/ROLLBACK
```

### [T-019] Funciones PL/SQL de Apoyo ⏱️ 30 min
**Estado**: TEMPLATES EXISTEN | **Archivos**: `plsql/functions/fn_*.sql` (3 archivos)

**Funciones**:
```
1. fn_promedio_estudiante(p_estudiante_id) RETURN NUMBER
   → AVG(nota.valor) de todas sus inscripciones

2. fn_cupo_disponible(p_seccion_id) RETURN NUMBER
   → cupo_disponible de la sección

3. fn_estado_aprobacion(p_inscripcion_id) RETURN VARCHAR2
   → 'APROBADO' si promedio >= 3.0, 'REPROBADO' si < 3.0
```

### [T-018] Package pkg_notas ⏱️ 45 min
**Estado**: TEMPLATE | **Archivo**: `plsql/packages/pkg_notas.sql`

**Procedimientos**:
```
1. registrar_nota(p_inscripcion_id, p_tipo_evaluacion, p_valor, OUT p_resultado)
   - Validar: inscripción existe, valor entre 0-100
   - INSERT nota
   - COMMIT/ROLLBACK

2. actualizar_nota(p_nota_id, p_valor, OUT p_resultado)
   - Validar: nota existe, valor entre 0-100
   - UPDATE nota
   - COMMIT/ROLLBACK

3. obtener_promedio(p_estudiante_id) RETURN NUMBER
   - Usar fn_promedio_estudiante
```

### [T-023] Manejo de Excepciones ⏱️ 20 min
**Estado**: EN PROGRESO (en todos los packages)
- ✅ EXCEPTION WHEN OTHERS THEN en cada procedure
- ✅ ROLLBACK automático en error
- ✅ Retornar SQLERRM

---

## 🔍 FASE 3: AUDITORÍA Y VALIDACIÓN (Prioridad: MEDIA)

### [T-021] Trigger de Auditoría ⏱️ 30 min
**Estado**: TEMPLATE | **Archivo**: `plsql/triggers/trg_auditoria.sql`

**Triggers**:
```
AFTER INSERT/UPDATE/DELETE ON inscripcion
AFTER INSERT/UPDATE/DELETE ON nota

Para cada operación:
- INSERT en AUDITORIA_ACADEMICA
- Capturar USER, SYSTIMESTAMP, operación
- Registrar :OLD y :NEW
```

### [T-022] Trigger de Validación ⏱️ 30 min
**Estado**: TEMPLATE | **Archivo**: `plsql/triggers/trg_validacion_negocio.sql`

**Validaciones BEFORE INSERT/UPDATE**:
```
- En NOTA: valor BETWEEN 0 AND 100
- En INSCRIPCION: período debe estar ACTIVO
- Usar RAISE_APPLICATION_ERROR(-20001, 'Error message')
```

---

## 📚 FASE 4: DOCUMENTACIÓN (Prioridad: MEDIA)

### [T-024] Documentar PL/SQL ⏱️ 45 min
**Estado**: PENDIENTE | **Archivo**: `docs/plsql_documentacion.md` (CREAR)

**Contenido**:
- Especificación de cada package
- Parámetros y retornos
- Ejemplos de uso con SELECT
- Manejo de errores
- Diagrama de flujo

### [T-044] Diagrama Flujo ETL ⏱️ 20 min
**Estado**: PENDIENTE (colaborar con Julian)
- ✅ Mostrar: OPERACIONAL → DW
- ✅ Tablas de origen → tablas dimensionales

---

## 🚀 FASE 5: OPCIONAL

### [T-048] API Node.js ⏱️ 2+ horas
- POST /inscripciones (llamar pkg_inscripciones)
- POST /notas (llamar pkg_notas)
- GET /estudiantes

### [T-049] Frontend React ⏱️ 2+ horas
- UI para inscripciones
- UI para registro de notas
- Reportes simples

---

## ✅ Checklist de Validación

Antes de marcar cada tarea como COMPLETADA:

- [ ] El archivo existe en la ubicación correcta
- [ ] El código ejecuta sin errores en Oracle
- [ ] Se probó la funcionalidad (INSERT/UPDATE/SELECT)
- [ ] Se capturó screenshot de la ejecución (guardar en `evidencias/sprint-1/`)
- [ ] Se documentó en comentarios el propósito
- [ ] Se maneja correctamente COMMIT/ROLLBACK
- [ ] Las excepciones se capturan con WHEN OTHERS

---

## 🔗 Dependencias

```
T-010 ← T-008 (Wuili debe completar DDL primero)
T-011 ← T-008 (necesita tablas)
T-018 ← T-008 (necesita tablas)
T-021 ← T-020 (tabla de auditoría)
T-022 ← T-008 (validaciones en tablas)
T-024 ← T-011, T-018, T-021, T-022 (documentar todo)
T-048 ← T-011, T-018 (API depende de packages)
T-049 ← T-048 (Frontend depende de API)
```

---

## 📞 Contactos Rápidos

- **Wuili** (Modelo/Transacciones): Para T-008 DDL
- **Julian** (Optimización/DW): Para T-044 ETL diagram
- **Luis** (Backup/Seguridad): Para Roles y permisos

