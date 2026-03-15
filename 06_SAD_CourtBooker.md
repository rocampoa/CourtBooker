# Software Architecture Document (SAD)
## Sistema de Reservas de Canchas Deportivas - "CourtBooker"

**Versión:** 1.0  
**Fecha:** 14 de marzo de 2026  
**Preparado por:** Equipo de Arquitectura  
**Aprobado por:** Gerente de Proyecto

---

## CONTROL DE VERSIONES

| Versión | Fecha      | Autor | Cambios |
|---------|------------|-------|---------|
| 0.1 | 06-03-2026 | Arquitecto | Borrador inicial |
| 1.0 | 14-03-2026 | Arquitecto | Versión aprobada para desarrollo |

---

## TABLA DE CONTENIDOS

1. [Introducción](#1-introducción)
2. [Descripción General de la Arquitectura](#2-descripción-general-de-la-arquitectura)
3. [Vistas Arquitecturales (C4)](#3-vistas-arquitecturales-c4)
4. [Decisiones Arquitecturales (ADRs)](#4-decisiones-arquitecturales-adrs)
5. [Tecnologías y Herramientas](#5-tecnologías-y-herramientas)
6. [Seguridad](#6-seguridad)
7. [Despliegue e Infraestructura](#7-despliegue-e-infraestructura)
8. [Calidad y Atributos](#8-calidad-y-atributos)
9. [Riesgos y Deuda Técnica](#9-riesgos-y-deuda-técnica)
10. [Apéndices](#10-apéndices)

---

## 1. INTRODUCCIÓN

### 1.1 Propósito del Documento

Este Software Architecture Document (SAD) describe la arquitectura del sistema Court Booker, un sistema de reservas de canchas deportivas para el Club Deportivo Universitario.

Este documento sirve como:
- **Guía de implementación** para el equipo de desarrollo
- **Referencia técnica** para arquitectos y líderes técnicos
- **Documentación de decisiones** para futuros mantenedores
- **Base de comunicación** entre stakeholders técnicos

### 1.2 Audiencia

| Rol | Uso de este documento |
|-----|----------------------|
| **Desarrolladores** | Implementar componentes según diseño |
| **Arquitectos** | Validar decisiones y evolución |
| **DevOps/SRE** | Configurar infraestructura y despliegue |
| **QA** | Diseñar estrategia de testing |
| **Product Owner** | Entender limitaciones técnicas |

### 1.3 Referencias

- **[SRS] Software Requirements Specification v1.0** - Documento de requisitos
- **[C4 DSL] Court Booker_Architecture.dsl** - Vistas C4 en Structurizr
- **[ADR-001]** Service-Based Architecture
- **[ADR-002]** PostgreSQL como base de datos
- **[ADR-003]** RabbitMQ para notificaciones asíncronas

### 1.4 Alcance

Este documento cubre la arquitectura del **MVP (Minimum Viable Product)** de Court Booker, incluyendo:
- ✅ Autenticación y gestión de usuarios
- ✅ Reserva y cancelación de canchas
- ✅ Procesamiento de pagos
- ✅ Notificaciones por email
- ✅ Panel administrativo

**Fuera de alcance del MVP:**
- ❌ Aplicación móvil nativa
- ❌ Reservas recurrentes
- ❌ Sistema de puntos/descuentos
- ❌ Multitenancy (múltiples clubes)

---

## 2. DESCRIPCIÓN GENERAL DE LA ARQUITECTURA

### 2.1 Filosofía de Diseño

La arquitectura de Court Booker sigue estos principios fundamentales:

1. **Simplicidad sobre complejidad:** Elegir soluciones simples que resuelvan el problema
2. **Time-to-market:** Priorizar entrega en 6 meses
3. **Costo-eficiencia:** Mantener infraestructura ≤ $1.000.0000/mes
4. **Modularidad:** Código organizado por dominios de negocio
5. **Resiliencia:** Fallos en subsistemas no críticos no deben bloquear funcionalidad core

### 2.2 Estilo Arquitectural Principal

**Service-Based Architecture** (ver [ADR-001])

Punto medio entre monolito y microservicios:
- **5 servicios** independientes con dominios claros
- **Base de datos compartida** (PostgreSQL)
- **Comunicación síncrona** (HTTP/REST) + asíncrona (RabbitMQ)
- **Despliegues independientes** por servicio

**Justificación:** Balance entre modularidad, time-to-market y complejidad operacional aceptable para equipo de 3 personas.

### 2.3 Drivers Arquitecturales (ASRs)

Los siguientes Architecturally Significant Requirements (ASRs) guiaron las decisiones de diseño:

| ID | Driver | Valor | Prioridad |
|----|--------|-------|-----------|
| **DR-01** | Time-to-market | ≤ 6 meses | Alta |
| **DR-02** | Tamaño de equipo | 3 desarrolladores | Hard Constraint |
| **DR-03** | Escalabilidad | 500 → 2,000 usuarios | Alta |
| **DR-04** | Presupuesto infra | ≤ $3,000 USD/mes | Hard Constraint |
| **DR-05** | Latencia de reserva | < 3 segundos P95 | Alta |
| **DR-06** | Disponibilidad | ≥ 99.5% (6am-11pm) | Alta |
| **DR-07** | Integridad de datos | 0 doble-bookings | Crítica |
| **DR-08** | Seguridad | PCI-DSS L2, Ley 1581 | Hard Constraint |

---

## 3. VISTAS ARQUITECTURALES (C4)

Este documento utiliza el **modelo C4** (Context, Containers, Components, Code) para describir la arquitectura en diferentes niveles de abstracción.

**Archivo Structurizr:** `CourtBooker_Architecture.dsl`  
**Visualización:** https://structurizr.com/dsl (cargar archivo .dsl)

### 3.1 C4 Nivel 1: Context Diagram

**Propósito:** Mostrar cómo CourtBooker se relaciona con usuarios y sistemas externos.

![C4 Context - se genera con Structurizr DSL]

**Elementos clave:**
- **Usuarios:** Miembros, Administradores, Invitados
- **Sistema:** Court Booker
- **Sistemas externos:**
  - Sistema Universitario (SOAP legacy)
  - Wompi (pagos)
  - Twilio SendGrid (emails)

**Para visualizar:** Cargar `CourtBooker_Architecture.dsl` en https://structurizr.com/dsl y ver vista "SystemContext"

### 3.2 C4 Nivel 2: Container Diagram

**Propósito:** Mostrar los contenedores (aplicaciones/servicios) que componen CourtBooker.

![C4 Container - se genera con Structurizr DSL]

**Contenedores principales:**

| Contenedor | Tecnología | Responsabilidad |
|------------|------------|-----------------|
| **Web App** | React.js + Tailwind | UI para usuarios |
| **API Gateway** | Kong/Nginx | Routing y rate limiting |
| **Auth Service** | Node.js + Express | Autenticación JWT |
| **Booking Service** | Node.js + Express | Reservas y disponibilidad |
| **Payment Service** | Node.js + Express | Pagos vía Wompi |
| **Notification Service** | Node.js + Express | Envío de emails |
| **Admin Service** | Python + FastAPI | Reportes y administración |
| **Database** | PostgreSQL 14 | Persistencia principal |
| **Cache** | Redis 7 | Sesiones y cache |
| **Message Queue** | RabbitMQ | Eventos asíncronos |

**Para visualizar:** Ver vista "Containers" en Structurizr

### 3.3 C4 Nivel 3: Component Diagrams

**Propósito:** Mostrar componentes internos de contenedores clave.

Se documentan 3 servicios principales:

#### 3.3.1 Booking Service Components

| Componente | Responsabilidad |
|------------|-----------------|
| **BookingController** | Endpoints REST (/bookings) |
| **AvailabilityManager** | Calcula disponibilidad en tiempo real |
| **ReservationRepository** | Acceso a datos de reservas |

**Flujo principal:**
```
GET /bookings/availability 
→ BookingController 
→ AvailabilityManager 
→ ReservationRepository 
→ PostgreSQL
```

#### 3.3.2 Payment Service Components

| Componente | Responsabilidad |
|------------|-----------------|
| **PaymentController** | Endpoints REST (/payments) |
| **WompiClient** | Cliente HTTP para Wompi API |
| **TransactionRepository** | Registra transacciones |

**Flujo principal:**
```
POST /payments 
→ PaymentController 
→ WompiClient → Wompi API
→ TransactionRepository → PostgreSQL
```

#### 3.3.3 Notification Service Components

| Componente | Responsabilidad |
|------------|-----------------|
| **EmailSender** | Envía emails vía SendGrid |
| **TemplateEngine** | Renderiza templates HTML |
| **EventConsumer** | Consume eventos de RabbitMQ |

**Para visualizar:** Ver vistas "ComponentsBookingService" y "ComponentsPaymentService" en Structurizr

### 3.4 C4 Nivel 4: Code (Opcional)

No se incluye en MVP. Los diagramas de clases UML se generarán automáticamente con herramientas de documentación del código.

### 3.5 Vista de Deployment

**Propósito:** Mostrar cómo los contenedores se mapean a infraestructura AWS.

![Deployment - se genera con Structurizr DSL]

**Infraestructura:**
- **CloudFront CDN** → Distribución global de Web App
- **Application Load Balancer** → Distribución de tráfico
- **ECS Fargate Cluster** → 5 servicios backend
- **RDS PostgreSQL Multi-AZ** → Base de datos
- **ElastiCache Redis** → Cache y sesiones
- **EC2 (RabbitMQ)** → Message broker

**Para visualizar:** Ver vista "Deployment" en Structurizr

---

## 4. DECISIONES ARQUITECTURALES (ADRs)

Las siguientes decisiones arquitecturales han sido documentadas:

### 4.1 ADR-001: Service-Based Architecture

**Estado:** Aceptado  
**Archivo:** `ADR-001_Service_Based_Architecture.md`

**Resumen:** Adoptamos Service-Based Architecture con 5 servicios independientes que comparten base de datos PostgreSQL.

**Alternativas consideradas:** Monolito, Microservicios  
**Trade-off aceptado:** Acoplamiento en BD a cambio de simplicidad  

**Ver documento completo:** [ADR-001]

### 4.2 ADR-002: PostgreSQL como Base de Datos

**Estado:** Aceptado  
**Archivo:** `ADR-002_PostgreSQL_Database.md`

**Resumen:** PostgreSQL 14 en RDS Multi-AZ como base de datos principal.

**Alternativas consideradas:** MySQL, MongoDB, DynamoDB  
**Trade-off aceptado:** Escalabilidad de escritura limitada a cambio de ACID y queries complejos  

**Ver documento completo:** [ADR-002]

### 4.3 ADR-003: RabbitMQ para Notificaciones

**Estado:** Aceptado  
**Archivo:** `ADR-003_RabbitMQ_Async_Notifications.md`

**Resumen:** RabbitMQ para procesamiento asíncrono de notificaciones.

**Alternativas consideradas:** Síncrono, AWS SQS, Kafka  
**Trade-off aceptado:** Complejidad operacional a cambio de resiliencia y latencia  

**Ver documento completo:** [ADR-003]

---

## 5. TECNOLOGÍAS Y HERRAMIENTAS

### 5.1 Stack Tecnológico

| Capa | Tecnología | Versión | Justificación |
|------|------------|---------|---------------|
| **Frontend** | React.js | 18.x | Ecosystem maduro, expertise del equipo |
| | Tailwind CSS | 3.x | Desarrollo rápido de UI |
| | Vite | 5.x | Build rápido |
| **Backend** | Node.js | 20 LTS | JavaScript full-stack, async I/O |
| | Express.js | 4.x | Framework minimalista y flexible |
| | TypeScript | 5.x | Type safety |
| **Admin** | Python | 3.11 | Mejor para data analytics |
| | FastAPI | 0.110 | API rápida para reportes |
| **Database** | PostgreSQL | 14.x | ACID, queries complejos |
| | TypeORM | 0.3.x | ORM type-safe |
| **Cache** | Redis | 7.x | In-memory cache rápido |
| **Message Queue** | RabbitMQ | 3.12 | Broker confiable y simple |
| **Auth** | JWT | - | Stateless authentication |
| | bcrypt | - | Password hashing |

### 5.2 Servicios Cloud (AWS)

| Servicio | Uso | Costo estimado/mes |
|----------|-----|-------------------|
| **CloudFront** | CDN para Web App | $50 |
| **ALB** | Load balancing | $25 |
| **ECS Fargate** | Hosting de servicios | $800 |
| **RDS PostgreSQL** | Base de datos Multi-AZ | $250 |
| **ElastiCache Redis** | Cache cluster | $150 |
| **EC2 (t3.small)** | RabbitMQ | $45 |
| **S3** | Backups y static assets | $10 |
| **CloudWatch** | Logs y monitoring | $50 |
| **Route 53** | DNS | $5 |
| **Secrets Manager** | Credenciales | $15 |
| **TOTAL** | | **$1,400/mes** |

**Margen vs presupuesto:** $3,000 - $1,400 = $1,600 disponible para escalar

### 5.3 Servicios Externos

| Servicio | Uso | Costo |
|----------|-----|-------|
| **Wompi** | Procesamiento de pagos | 2.9% + $700 COP por transacción |
| **Twilio SendGrid** | Envío de emails | $15/mes (40K emails) |
| **Sistema de Membresías** | Validación de miembros | Gratis (ya existe) |

### 5.4 Herramientas de Desarrollo

| Categoría | Herramienta |
|-----------|-------------|
| **Control de versiones** | Git + GitHub |
| **CI/CD** | GitHub Actions |
| **Testing** | Jest (backend), Vitest (frontend) |
| **Linting** | ESLint, Prettier |
| **Documentación API** | Swagger/OpenAPI |
| **Monitoreo** | AWS CloudWatch + Grafana |
| **Error tracking** | Sentry |

---

## 6. SEGURIDAD

### 6.1 Autenticación y Autorización

**Mecanismo:** JWT (JSON Web Tokens)

**Flujo:**
1. Usuario envía credenciales (email + password)
2. Auth Service valida contra PostgreSQL
3. Auth Service valida estado de membresía (API SOAP)
4. Si válido, genera JWT firmado con RS256
5. JWT incluye: userId, role (member/admin), exp (24h)
6. Cliente incluye JWT en header `Authorization: Bearer <token>`
7. Servicios validan JWT usando clave pública

**Roles:**
- `member`: Usuarios con membresía activa
- `admin`: Staff del club
- `guest`: No autenticado (solo lectura)

### 6.2 Protección de Datos

**Cumplimiento Ley 1581 (Colombia):**
- [x] Consentimiento explícito para recopilar datos
- [x] Política de privacidad visible
- [x] Derecho a consultar/modificar/eliminar datos
- [x] Encriptación en tránsito (TLS 1.3)
- [x] Encriptación en reposo (RDS encryption)
- [x] Logs de acceso y auditoría

**Datos sensibles:**
- Contraseñas: Hasheadas con bcrypt (cost factor 12)
- Emails: Almacenados en texto plano (necesarios para notificaciones)
- Datos de pago: NO almacenados (PCI-DSS compliance)

### 6.3 Protección de APIs

| Medida | Implementación |
|--------|----------------|
| **Rate limiting** | 100 req/min por IP (Kong) |
| **CORS** | Whitelist solo frontend del club |
| **Input validation** | Joi schemas en todos los endpoints |
| **SQL injection** | TypeORM prepared statements |
| **XSS** | React auto-escaping + Content Security Policy |
| **HTTPS** | TLS 1.3 obligatorio |
| **Secrets** | AWS Secrets Manager (no hardcodeados) |

### 6.4 Compliance PCI-DSS Level 2

**Requisitos cumplidos:**
- ✅ No almacenar datos de tarjetas (Wompi maneja todo)
- ✅ HTTPS en todas las comunicaciones
- ✅ Logs de acceso y auditoría
- ✅ Penetration testing anual
- ✅ Firewall rules (Security Groups)

---

## 7. DESPLIEGUE E INFRAESTRUCTURA

### 7.1 Ambientes

| Ambiente | Propósito | URL |
|----------|-----------|-----|
| **Development** | Desarrollo local | localhost:3000 |
| **Staging** | Testing pre-producción | staging.courtbooker.com |
| **Production** | Usuarios reales | app.courtbooker.com |

### 7.2 Estrategia de Despliegue

**Continuous Deployment:**
- Push a `main` → Deploy automático a Staging
- Tag release → Deploy manual a Production (aprobación requerida)

**Rolling Update (ECS):**
- Despliegue de nuevas versiones sin downtime
- Health checks antes de terminar versión antigua
- Rollback automático si health checks fallan

**Blue-Green para cambios de schema:**
- Base de datos: Backward-compatible migrations
- Si breaking change: Blue-Green deployment completo

### 7.3 Configuración de Infraestructura

**ECS Services:**

| Service | Instancias | CPU | RAM |
|---------|-----------|-----|-----|
| Auth Service | 2 | 0.5 vCPU | 1 GB |
| Booking Service | 3 | 1 vCPU | 2 GB |
| Payment Service | 2 | 0.5 vCPU | 1 GB |
| Notification Service | 1 | 0.25 vCPU | 512 MB |
| Admin Service | 1 | 0.5 vCPU | 1 GB |

**Auto-scaling:**
- Trigger: CPU > 70% por 5 minutos
- Scale up: +1 instancia
- Scale down: -1 instancia (si CPU < 30% por 10 min)
- Max instancias: 2x configuración base

**RDS PostgreSQL:**
- Instance: db.t3.medium (2 vCPU, 4 GB RAM)
- Storage: 100 GB gp3 (3000 IOPS)
- Multi-AZ: Activo (failover automático)
- Backups: Diarios, retención 7 días

### 7.4 Monitoreo y Alertas

**CloudWatch Alarms:**

| Métrica | Threshold | Acción |
|---------|-----------|--------|
| ECS CPU > 80% | 5 min | Email + auto-scale |
| RDS CPU > 85% | 5 min | Email a equipo |
| ALB 5xx > 10/min | 1 min | PagerDuty |
| RabbitMQ queue > 1000 | 5 min | Email |
| Disk usage > 85% | - | Email |

**Dashboards:**
- Grafana: Métricas de negocio (reservas/hora, revenue)
- CloudWatch: Métricas de infra (CPU, latencia, errores)
- RabbitMQ Management: Estado de colas

---

## 8. CALIDAD Y ATRIBUTOS

### 8.1 Mapa de Atributos a Decisiones

| Atributo | Objetivo           | Decisión arquitectural |
|----------|--------------------|------------------------|
| **Performance** | P95 < 3seg reserva | RabbitMQ async (ADR-003) |
| **Availability** | 99.5% uptime       | RDS Multi-AZ, ECS health checks |
| **Scalability** | 500 → 2K usuarios  | Service-Based (ADR-001), ECS auto-scale |
| **Maintainability** | 4h nueva feature   | Modularidad por servicios (ADR-001) |
| **Security** | PCI-DSS L2         | Wompi para pagos, JWT, TLS |
| **Cost** | ≤ $1.000.000/mes   | Service-Based vs microservicios (ADR-001) |

### 8.2 Tácticas Arquitecturales Aplicadas

**Para Performance:**
- ✅ Cache de disponibilidad en Redis (TTL 30seg)
- ✅ Connection pooling en PostgreSQL
- ✅ CDN para assets estáticos
- ✅ Índices en queries frecuentes

**Para Availability:**
- ✅ Multi-AZ deployment (RDS, ECS)
- ✅ Health checks y auto-restart
- ✅ Circuit breaker en llamadas externas
- ✅ Graceful degradation (notificaciones fallan → reserva continúa)

**Para Scalability:**
- ✅ Horizontal scaling (ECS auto-scale)
- ✅ Stateless services (JWT, no sesiones en memoria)
- ✅ Database read replica (futuro si necesario)

**Para Maintainability:**
- ✅ Separación por dominios (servicios)
- ✅ Testing automatizado (70% coverage)
- ✅ Documentación de APIs (Swagger)
- ✅ Logging estructurado (JSON)

### 8.3 Testing Strategy

| Tipo | Herramienta | Coverage objetivo |
|------|-------------|-------------------|
| **Unit tests** | Jest/Vitest | 80% de funciones |
| **Integration tests** | Supertest | Endpoints críticos |
| **E2E tests** | Playwright | 5 flujos principales |
| **Load tests** | k6 | 200 usuarios concurrentes |
| **Security tests** | OWASP ZAP | Anual |

---

## 9. RIESGOS Y DEUDA TÉCNICA

### 9.1 Riesgos Técnicos Identificados

| ID | Riesgo | Probabilidad | Impacto | Mitigación |
|----|--------|--------------|---------|------------|
| **R-01** | Sistema legacy SOAP no documentado | Media | Alto | Crear abstraction layer, tests de integración |
| **R-02** | RabbitMQ single point of failure | Baja | Medio | Monitoreo, plan de migración a cluster (Fase 2) |
| **R-03** | Wompi downtime bloquea pagos | Baja | Alto | Queue de retries, modo offline con pago posterior |
| **R-04** | DB compartida crea coupling | Alta | Medio | Schemas separados, code reviews |
| **R-05** | Team pequeño (3 devs) | Alta | Alto | Documentación excelente, code reviews obligatorios |

### 9.2 Deuda Técnica Aceptada

Siguiente deuda técnica es **conscientemente aceptada** para MVP:

| Ítem | Justificación | Plan de resolución |
|------|---------------|-------------------|
| **No DB por servicio** | Time-to-market, equipo pequeño | Evaluar en Mes 9 según carga |
| **No distributed tracing** | Costo y complejidad | Agregar si debugging se complica |
| **No circuit breakers** | Suficiente con retries por ahora | Agregar si vemos cascading failures |
| **No read replicas** | Carga baja en MVP | Agregar si RDS CPU > 70% sostenido |

### 9.3 Evolución Futura Planificada

**Fase 2 (Meses 7-12):**
- [ ] Aplicación móvil nativa (React Native)
- [ ] Reservas recurrentes
- [ ] RabbitMQ cluster (HA)
- [ ] Reportes avanzados con gráficos

**Fase 3 (Año 2):**
- [ ] Multitenancy (múltiples clubes)
- [ ] Sistema de puntos y descuentos
- [ ] Integración con calendarios personales
- [ ] Migrar a DB por servicio (si escala lo requiere)

---

## 10. APÉNDICES

### 10.1 Glosario

| Término | Definición |
|---------|------------|
| **ADR** | Architectural Decision Record |
| **ASR** | Architecturally Significant Requirement |
| **C4** | Context, Containers, Components, Code |
| **ECS** | Elastic Container Service (AWS) |
| **JWT** | JSON Web Token |
| **MVP** | Minimum Viable Product |
| **RDS** | Relational Database Service (AWS) |
| **RTO** | Recovery Time Objective |
| **RPO** | Recovery Point Objective |
| **SAD** | Software Architecture Document |
| **SRS** | Software Requirements Specification |

---

## APROBACIONES

| Rol | Nombre | Firma | Fecha      |
|-----|--------|-------|------------|
| **Arquitecto de Software** | [Nombre] | __________ | 14-03-2026 |
| **Líder Técnico** | [Nombre] | __________ | 14-03-2026 |
| **Gerente de Proyecto** | [Nombre] | __________ | 14-03-2026 |
| **Product Owner** | [Nombre] | __________ | 14-03-2026 |

---

**Fin del Documento SAD**

---

## NOTAS

Este SAD representa un **documento arquitectural completo** para un sistema real.

**Aspectos pedagógicos clave:**

1. **Trazabilidad:** SAD referencia SRS, ADRs y vistas C4
2. **Justificación:** Cada decisión tiene "por qué" documentado
3. **Trade-offs explícitos:** Se reconocen sacrificios aceptados
4. **Evolución planificada:** Roadmap de mejoras futuras
5. **Riesgos documentados:** Transparencia sobre limitaciones

**Relación entre documentos:**
```
SRS (requisitos) 
  → Diseño arquitectural 
  → ADRs (decisiones) 
  → Vistas C4 (diagramas) 
  → SAD (documento maestro)
```

**Uso en proyecto real:**
- Developers leen SAD antes de codificar
- Code reviews verifican adherencia al SAD
- SAD se actualiza cuando arquitectura evoluciona
