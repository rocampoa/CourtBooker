# ADR-001: Adoptar Service-Based Architecture

**Estado:** Aceptado  
**Fecha:** 13-03-2026  
**Decisores:** Equipo de Arquitectura, Líder Técnico  
**Relacionado con:** RF-01 a RF-08, RNF-01, RNF-04, RNF-05

---

## Contexto y Problema

Necesitamos decidir el estilo arquitectural para Court Booker. El sistema debe:
- Ser entregado en 6 meses por 3 desarrolladores
- Escalar de 500 a 2,000 usuarios sin rediseño
- Mantenerse dentro del presupuesto de $1.000.0000/mes infraestructura
- Permitir despliegues independientes de diferentes funcionalidades
- Ser fácil de mantener por un equipo pequeño

**Alternativas consideradas:**
1. Monolito tradicional
2. Microservicios
3. Service-Based Architecture (estilo híbrido)

---

## Drivers de Decisión

- **DR-01:** Time-to-market de 6 meses (Alta prioridad)
- **DR-02:** Equipo pequeño de 3 desarrolladores (Alta prioridad)
- **DR-03:** Escalabilidad a 2,000 usuarios (Alta prioridad)
- **DR-04:** Presupuesto limitado $1.000.000/mes (Hard constraint)
- **DR-05:** Mantenibilidad con equipo pequeño (Alta prioridad)
- **DR-06:** Disponibilidad ≥ 99.5% (RNF-02)

---

## Decisión

Adoptamos **Service-Based Architecture** con 5 servicios independientes:
1. Auth Service (autenticación)
2. Booking Service (reservas)
3. Payment Service (pagos)
4. Notification Service (notificaciones)
5. Admin Service (administración)

Cada servicio:
- Tiene su propio dominio de negocio claro
- Se despliega independientemente
- Comparte la misma base de datos (PostgreSQL)
- Se comunica síncronamente vía HTTP/REST
- Publica eventos a RabbitMQ para comunicación asíncrona

---

## Justificación

### Por qué Service-Based (y no Monolito):

**✅ Ventajas sobre Monolito:**
- **Escalabilidad selectiva:** Podemos escalar solo Booking Service (alta carga) sin escalar todo
- **Despliegues independientes:** Fix en Payment Service no requiere redesplegar todo
- **Aislamiento de fallos:** Problema en Notification Service no tumba reservas
- **Equipos paralelos:** 3 devs pueden trabajar en servicios diferentes sin conflictos

**✅ Mantiene beneficios del Monolito:**
- **Base de datos compartida:** Simplifica transacciones y consultas cross-domain
- **No overhead de red distribuido:** Queries directas a DB, no llamadas entre servicios para datos
- **Testing más simple:** No necesitamos mocks complejos de otros servicios

### Por qué Service-Based (y no Microservicios):

**✅ Ventajas sobre Microservicios:**
- **Menos complejidad operacional:** No necesitamos service mesh, distributed tracing complejo
- **Menos overhead de infraestructura:** No necesitamos DB por servicio = menor costo
- **Más rápido de desarrollar:** No necesitamos implementar sagas o event sourcing
- **Equipo pequeño:** 3 devs pueden manejar 5 servicios, no 15 microservicios

**⚖️ Trade-off aceptado:**
- **Acoplamiento en BD:** Cambiar schema requiere coordinación (aceptable con equipo pequeño)
- **No escalabilidad extrema:** Suficiente para 2,000 usuarios, no para millones

---

## Consecuencias

### ✅ Positivas:

1. **Time-to-market:** 6 meses es alcanzable (vs 9-12 meses con microservicios)
2. **Costo:** $800.000/mes estimado (dentro de presupuesto)
3. **Escalabilidad:** Podemos escalar servicios individualmente con ECS
4. **Mantenibilidad:** Código organizado en dominios claros
5. **Testing:** Más fácil que microservicios, mejor que monolito
6. **Resiliencia:** Fallo en Notifications no afecta Bookings

### ⚠️ Negativas (mitigadas):

1. **DB compartida:**
   - Riesgo: Schema coupling
   - Mitigación: Usar schemas de PostgreSQL por servicio, review de cambios
   
2. **No data sovereignty (Soberanía de Datos):**
   - Riesgo: Servicio puede acceder datos de otro
   - Mitigación: Repository pattern, code reviews, linting rules

3. **Complejidad operacional media:**
   - Riesgo: Más complejo que monolito
   - Mitigación: Usar ECS Fargate (gestionado), CloudWatch para logs centralizados

---

## Alternativas Descartadas

### Alternativa 1: Monolito

**Por qué fue descartada:**
- No escala selectivamente (DR-03)
- Despliegues riesgosos (todo o nada)
- Dificulta trabajo en paralelo del equipo

**Cuándo sería mejor:**
- Equipo de 1-2 personas
- MVP super rápido (< 3 meses)
- No hay requisitos de escalabilidad

### Alternativa 2: Microservicios

**Por qué fue descartada:**
- Overhead excesivo para equipo de 3 (DR-02)
- Tiempo de desarrollo > 6 meses (DR-01)
- Costo de infraestructura > $1.000.000/mes (DR-04)
- Complejidad operacional muy alta (DR-05)

**Cuándo sería mejor:**
- Equipos > 10 desarrolladores
- Escalabilidad extrema (> 10K usuarios concurrentes)
- Dominios muy desacoplados
- Presupuesto > $3.000.000/mes

---

## Notas

Esta decisión se revisará en el Mes 9 cuando se evalúe expansión a otras sedes o universidades.

Si el sistema crece a > 5,000 usuarios o > 30 canchas, consideraremos:
- Migrar a DB por servicio (microservicios)
- Implementar CQRS para reporting
- Agregar API Gateway más robusto (Kong → AWS API Gateway)

---

## Validación

- [x] Cumple con DR-01 (6 meses): 5 servicios = 1.2 meses/servicio, alcanzable
- [x] Cumple con DR-02 (3 devs): 1-2 servicios por developer
- [x] Cumple con DR-03 (2K usuarios): ECS auto-scaling soporta esta carga
- [x] Cumple con DR-04 ($1.000.000/mes): Estimado $800.000/mes
- [x] Cumple con DR-05 (mantenible): Código modular, buen testing
- [x] Cumple con DR-06 (99.5%): Multi-AZ RDS + ECS con health checks

---

**Estado final:** ACEPTADO ✅

**Firmas:**
- Arquitecto: [Firma] _____________________- 14-03-2026
- Líder Técnico: [Firma] __________________- 14-03-2026
