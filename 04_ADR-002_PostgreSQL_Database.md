# ADR-002: PostgreSQL como Base de Datos Principal

**Estado:** Aceptado  
**Fecha:** 14-03-2026  
**Decisores:** Equipo de Arquitectura  
**Relacionado con:** RNF-01, RNF-02, RNF-04, RNF-07

---

## Contexto y Problema

Necesitamos seleccionar la base de datos principal para almacenar:
- Usuarios 
- Canchas y configuración
- Reservas y disponibilidad
- Transacciones de pago
- Logs de auditoría

**Requisitos clave:**
- Transacciones ACID para reservas (evitar doble booking)
- Queries complejos para disponibilidad y reportes
- Escalabilidad a 2,000 usuarios
- Costo ≤ $1.000.000/mes
- El club ya tiene licencia de PostgreSQL

---

## Drivers de Decisión

- **DR-01:** Integridad transaccional (ACID) para reservas (Crítico)
- **DR-02:** Queries complejos para reportes (Alta prioridad)
- **DR-03:** Costo ≤ $1.000.000/mes (Hard constraint)
- **DR-04:** Expertise del equipo en SQL (Alta prioridad)
- **DR-05:** Club ya tiene licencia PostgreSQL (Restricción técnica)

---

## Decisión

Usamos **PostgreSQL 14** en AWS RDS con configuración Multi-AZ.

**Configuración:**
- Instancia: db.t3.medium (2 vCPUs, 4 GB RAM)
- Storage: 100 GB SSD (gp3)
- Multi-AZ: Activo (para alta disponibilidad)
- Backups automatizados: Retención 7 días
- Read Replica: Agregar si carga > 70%

**Esquema de datos:**
- 1 schema por servicio (auth, bookings, payments, admin)
- Indices en: user_id, court_id, booking_date
- Particionado por fecha en tabla bookings (mensual)

---

## Justificación

### Por qué PostgreSQL:

**✅ Cumple requisitos técnicos:**
1. **ACID completo:** Garantiza no doble-booking con transacciones
2. **Queries complejos:** Soporte para JOINs, window functions, CTEs para reportes
3. **JSON support:** Almacenar metadata flexible (configuración de canchas)
4. **Particionado:** Escala bien con crecimiento de reservas históricas
5. **Índices avanzados:** GIN, BRIN para performance

**✅ Cumple requisitos de negocio:**
1. **Licencia:** Club ya tiene licencia → $0 en software
2. **Expertise:** Equipo conoce PostgreSQL bien
3. **RDS Multi-AZ:** Cumple 99.95% SLA → cumple RNF-02
4. **Costo:** $250.000/mes (t3.medium Multi-AZ) → dentro de presupuesto

---

## Alternativas Descartadas

### Alternativa 1: MySQL

**Por qué descartada:**
- Club no tiene licencia → costos de aprendizaje
- Menos features avanzados que PostgreSQL
- Team prefiere PostgreSQL

**Cuándo sería mejor:**
- Si equipo tuviera expertise en MySQL
- Si necesitáramos replicación más simple

### Alternativa 2: MongoDB (NoSQL)

**Por qué descartada:**
- No garantiza ACID multi-documento sin complejidad
- Queries complejos más difíciles (reportes)
- Equipo no tiene experiencia

**Cuándo sería mejor:**
- Datos muy no estructurados
- Escalabilidad horizontal extrema (> 10K writes/seg)
- Schema cambiante

### Alternativa 3: DynamoDB (NoSQL serverless)

**Por qué descartada:**
- Queries complejos muy difíciles (no JOINs)
- Costo impredecible con crecimiento
- Curva de aprendizaje alta

**Cuándo sería mejor:**
- Escalabilidad masiva (millones de usuarios)
- Workload de lectura/escritura muy predecible
- Equipo con experiencia en NoSQL

---

## Consecuencias

### ✅ Positivas:

1. **Integridad garantizada:** ACID previene doble-booking
2. **Reportes potentes:** SQL nativo para analytics
3. **Alta disponibilidad:** Multi-AZ = 99.95% uptime
4. **Backups automáticos:** RPO de 5 minutos
5. **Monitoreo:** CloudWatch integrado

### ⚠️ Negativas (mitigadas):

1. **Costo de RDS:**
   - $250.000/mes base
   - Mitigación: Suficiente para 2,000 usuarios, escalable
   
2. **Escritura no escala infinitamente:**
   - Mitigación: Read Replica para reportes, suficiente para nuestro caso

---

## Métricas de Éxito

- [ ] Latencia de queries ≤ 100ms P95
- [ ] 0 doble-bookings en producción
- [ ] Uptime ≥ 99.5%
- [ ] Costo ≤ $300.000/mes primeros 6 meses

---

## Notas

Si en el futuro (> 5,000 usuarios):
- Considerar read replicas para reportes
- Implementar connection pooling (PgBouncer)
- Particionar por fecha más agresivamente

---

**Estado final:** ACEPTADO ✅
