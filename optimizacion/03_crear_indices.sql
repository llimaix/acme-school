-- Índices estratégicos sobre las columnas usadas en JOIN y filtros.

SET ECHO ON;
SET FEEDBACK ON;
SET TIMING ON;

-- ============================================================
-- Objetivo:
-- Crear índices sobre columnas utilizadas en JOIN y búsquedas
-- frecuentes para mejorar el rendimiento de las consultas críticas.
-- ============================================================

-- ============================================================
-- Índice 1: INSCRIPCION(SECCION_ID)
-- Justificación:
-- La consulta crítica une INSCRIPCION con SECCION usando SECCION_ID.
-- Este índice ayuda a localizar rápidamente las inscripciones de una sección.
-- ============================================================

CREATE INDEX idx_inscripcion_seccion
ON inscripcion(seccion_id);

-- ============================================================
-- Índice 2: NOTA(INSCRIPCION_ID)
-- Justificación:
-- La consulta crítica une NOTA con INSCRIPCION usando INSCRIPCION_ID.
-- Este índice mejora la búsqueda de notas asociadas a cada inscripción.
-- ============================================================

CREATE INDEX idx_nota_inscripcion
ON nota(inscripcion_id);

-- ============================================================
-- Índice 3: SECCION(CURSO_ID, PERIODO_ID)
-- Justificación:
-- La consulta crítica une SECCION con CURSO y PERIODO.
-- El índice compuesto ayuda cuando se consultan secciones por curso y período.
-- ============================================================

CREATE INDEX idx_seccion_curso_periodo
ON seccion(curso_id, periodo_id);

-- ============================================================
-- Índice 4: INSCRIPCION(ESTUDIANTE_ID)
-- Justificación:
-- Permite optimizar futuras búsquedas de inscripciones por estudiante.
-- ============================================================

CREATE INDEX idx_inscripcion_estudiante
ON inscripcion(estudiante_id);

-- ============================================================
-- Índice 5: SECCION(DOCENTE_ID)
-- Justificación:
-- Permite optimizar futuras consultas de secciones asignadas a docentes.
-- ============================================================

CREATE INDEX idx_seccion_docente
ON seccion(docente_id);

-- ============================================================
-- Actualización de estadísticas
-- ============================================================
-- Esto ayuda al optimizador de Oracle a tomar mejores decisiones
-- al momento de generar los planes de ejecución.

BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'INSCRIPCION');
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'NOTA');
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'SECCION');
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'CURSO');
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'PERIODO');
END;
/

-- ============================================================
-- Verificación de índices creados
-- ============================================================

SELECT
    index_name,
    table_name,
    uniqueness,
    status
FROM user_indexes
WHERE index_name IN (
    'IDX_INSCRIPCION_SECCION',
    'IDX_NOTA_INSCRIPCION',
    'IDX_SECCION_CURSO_PERIODO',
    'IDX_INSCRIPCION_ESTUDIANTE',
    'IDX_SECCION_DOCENTE'
)
ORDER BY table_name, index_name;

-- ============================================================
-- Verificación de columnas indexadas
-- ============================================================

SELECT
    index_name,
    table_name,
    column_name,
    column_position
FROM user_ind_columns
WHERE index_name IN (
    'IDX_INSCRIPCION_SECCION',
    'IDX_NOTA_INSCRIPCION',
    'IDX_SECCION_CURSO_PERIODO',
    'IDX_INSCRIPCION_ESTUDIANTE',
    'IDX_SECCION_DOCENTE'
)
ORDER BY index_name, column_position;

-- ============================================================
-- Fin del script
-- ============================================================

SET TIMING OFF;