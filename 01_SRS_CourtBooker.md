# Software Requirements Specification (SRS)
## Sistema de Reservas de Canchas Deportivas - "Court Booker"

**Versión:** 1.0  
**Fecha:** 13 de marzo de 2026  
**Cliente:** Club Deportivo Universitario 
**Preparado por:** Grupo de Arquitectura de Software

---

## 1. INTRODUCCIÓN

### 1.1 Propósito
Este documento especifica los requisitos funcionales y no funcionales del Sistema de Reservas de Canchas Deportivas "Court Booker" para el Club Deportivo Universitario.

### 1.2 Alcance
CourtBooker permitirá a los miembros de la Universidad (Estudiantes, Egresados, Profesores y Administrativos)
reservar canchas deportivas (tenis, fútbol, baloncesto) a través de una aplicación web. El sistema gestionará 
disponibilidad, reservas, pagos y notificaciones.

### 1.3 Contexto del Negocio
**Situación actual:**
- Reservas por teléfono (9am-6pm) de lunes a viernes
- Registro manual en cuaderno
- Conflictos frecuentes de doble reserva
- No hay visibilidad de disponibilidad
- Pagos solo en efectivo en el club deportivo universitario

**Necesidad:**
- Sistema 24/7 para reservar
- Reducir conflictos de reservas
- Permitir pagos online
- Mejorar experiencia de usuarios
- Generar reportes para administración

### 1.4 Definiciones, Acrónimos y Abreviaciones
- **SRS:** Software Requirements Specification
- **SAD:** Software Architecture Document
- **ADR:** Architectural Decision Record
- **MVP:** Minimum Viable Product
- **Miembro:** Usuario registrado de la Universidad,estudiantes, egresados, profesores y administrativos
- **Admin:** Administrador del club
- **Slot:** Bloque de tiempo de 1 hora para reservar

---

## 2. DESCRIPCIÓN GENERAL DEL SISTEMA

### 2.1 Perspectiva del Producto
Sistema web standalone que se integrará con:
- Sistema Universitario existente (API SOAP legado)
- Pasarela de pagos Wompi (Colombia)
- Servicio de email Twilio SendGrid

### 2.2 Funciones del Producto
1. Gestión de usuarios y autenticación
2. Visualización de disponibilidad de canchas
3. Creación y cancelación de reservas
4. Procesamiento de pagos online
5. Notificaciones por email
6. Panel administrativo con reportes

### 2.3 Características de Usuarios

| Tipo de Usuario | Descripción                                     | Responsabilidades |
|-----------------|-------------------------------------------------|-------------------|
| **Miembro** | Estudiante, Egresado, Profesor y Administrativo | Hacer/cancelar reservas, pagar |
| **Administrador** | Personal del club deportivo universitario       | Gestionar canchas, ver reportes, cancelar reservas |
| **Invitado** | Usuario no registrado                           | Solo consultar disponibilidad |

### 2.4 Restricciones del Sistema
- **Presupuesto:** $1.000.000/mes en infraestructura
- **Equipo:** 3 desarrolladores, 6 meses para MVP
- **Tecnología:** Debe ejecutarse en cloud (AWS preferido)
- **Regulatorio:** Cumplir con Ley 1581 de protección de datos (Colombia)
- **Integraciones:** API del sistema de universitario es SOAP legacy

---

## 3. REQUISITOS FUNCIONALES

### RF-01: Autenticación de Usuarios
**Prioridad:** Alta  
**Descripción:** El sistema debe permitir a los miembros autenticarse con email y contraseña.

**Criterios de aceptación:**
- Login con email y contraseña
- Sesión expira después de 24 horas de inactividad
- Recuperación de contraseña por email
- Integración con sistema de universitario para validar estado activo

---

### RF-02: Consultar Disponibilidad
**Prioridad:** Alta  
**Descripción:** Usuarios pueden ver disponibilidad de canchas por fecha y tipo.

**Criterios de aceptación:**
- Vista calendario semanal
- Filtrar por tipo de cancha (tenis, fútbol, baloncesto)
- Ver slots disponibles en bloques de 1 hora (7am-9pm)
- Actualización en tiempo real de disponibilidad
- Accesible para usuarios no autenticados (solo lectura)

---

### RF-03: Crear Reserva
**Prioridad:** Alta  
**Descripción:** Miembros autenticados pueden reservar slots disponibles.

**Criterios de aceptación:**
- Seleccionar cancha, fecha y hora
- Confirmar disponibilidad antes de reservar
- Reserva no confirmada hasta completar pago
- Máximo 3 reservas activas por miembro
- No permitir reservar con menos de 2 horas de anticipación
- Generar ID único de reserva

---

### RF-04: Procesar Pago
**Prioridad:** Alta  
**Descripción:** Miembros deben pagar online para confirmar reserva.

**Criterios de aceptación:**
- Integración con Wompi (tarjeta crédito/débito)
- Precio: $25.000 COP por hora (Configurable)
- Reserva confirmada solo si pago exitoso
- Reversar reserva si pago falla
- Generar recibo digital

---

### RF-05: Cancelar Reserva
**Prioridad:** Media  
**Descripción:** Miembros pueden cancelar reservas con al menos 12 horas de anticipación.

**Criterios de aceptación:**
- Cancelación con mínimo 12 horas de anticipación
- Reembolso automático del 100% si cumple condición
- No reembolso si cancela con menos de 12 horas
- Liberar slot para otros usuarios
- Enviar confirmación de cancelación por email

---

### RF-06: Notificaciones
**Prioridad:** Media  
**Descripción:** Sistema envía notificaciones por email en eventos clave.

**Criterios de aceptación:**
- Email confirmación de reserva
- Email recordatorio 2 horas antes
- Email confirmación de cancelación
- Email recibo de pago

---

### RF-07: Panel Administrativo
**Prioridad:** Media  
**Descripción:** Administradores gestionan canchas y consultan reportes.

**Criterios de aceptación:**
- Dashboard con métricas: reservas hoy, ingresos del mes, tasa de ocupación
- Listar todas las reservas (filtrar por fecha, cancha, usuario)
- Cancelar cualquier reserva (con justificación)
- Exportar reportes a CSV
- Bloquear slots para mantenimiento

---

### RF-08: Gestión de Canchas
**Prioridad:** Baja  
**Descripción:** Administradores pueden agregar/editar/deshabilitar canchas.

**Criterios de aceptación:**
- Crear nueva cancha (nombre, tipo, capacidad)
- Editar información de cancha
- Deshabilitar cancha temporalmente
- Configurar horarios disponibles por cancha

---

## 4. REQUISITOS NO FUNCIONALES

### RNF-01: Rendimiento
**ID:** RNF-01  
**Categoría:** Performance  
**Descripción:** El sistema debe responder rápidamente a las solicitudes de usuarios.

**Métricas:**
- Tiempo de carga de página ≤ 2 segundos (P95)
- Consulta de disponibilidad ≤ 500ms (P95)
- Creación de reserva ≤ 3 segundos end-to-end (P95)
- Soportar 50 usuarios concurrentes en horas pico

**Justificación:** Buena experiencia de usuario, evitar abandono en proceso de reserva.

---

### RNF-02: Disponibilidad
**ID:** RNF-02  
**Categoría:** Availability  
**Descripción:** El sistema debe estar disponible cuando los usuarios lo necesiten.

**Métricas:**
- Disponibilidad ≥ 99.5% durante horas de operación (6am-11pm)
- Downtime máximo: 3.6 horas/mes
- Recovery Time Objective (RTO): 30 minutos
- Recovery Point Objective (RPO): 1 hora

**Justificación:** Usuarios reservan a cualquier hora; caídas generan frustración y pérdida de ingresos.

---

### RNF-03: Seguridad
**ID:** RNF-03  
**Categoría:** Security  
**Descripción:** Proteger datos de usuarios y transacciones.

**Métricas:**
- HTTPS obligatorio en todas las conexiones
- Contraseñas "hasheadas" con bcrypt
- Cumplir con PCI-DSS Level 2 (no almacenar datos de tarjetas)
- Cumplir con Ley 1581 (protección de datos Colombia)
- Sesiones con tokens JWT
- Rate limiting: máximo 100 requests/minuto por IP

**Justificación:** Proteger información personal y financiera; cumplir regulaciones.

---

### RNF-04: Escalabilidad
**ID:** RNF-04  
**Categoría:** Scalability  
**Descripción:** El sistema debe crecer sin rediseño.

**Métricas:**
- Escalar de 500 a 2,000 miembros sin cambios arquitecturales
- Escalar de 5 a 20 canchas
- Soportar 200 usuarios concurrentes sin degradación
- Costo de infraestructura ≤ $1.000.000/mes con 2,000 usuarios

**Justificación:** Club planea expandirse a otras sedes en 12 meses.

---

### RNF-05: Mantenibilidad
**ID:** RNF-05  
**Categoría:** Maintainability  
**Descripción:** Código fácil de entender y modificar.

**Métricas:**
- Cobertura de tests ≥ 70%
- Complejidad ciclomática ≤ 10 por función
- Tiempo para agregar nueva cancha: ≤ 4 horas
- Documentación de APIs con OpenAPI/Swagger

**Justificación:** Equipo pequeño; necesitan hacer cambios rápidamente.

---

### RNF-06: Usabilidad
**ID:** RNF-06  
**Categoría:** Usability  
**Descripción:** Interfaz intuitiva y fácil de usar.

**Métricas:**
- Usuario nuevo completa primera reserva en ≤ 3 minutos
- Responsive (funciona en móvil, tablet, desktop)
- Soporte para Chrome, Firefox, Safari (últimas 2 versiones)
- Accesibilidad WCAG 2.1 Nivel A

**Justificación:** Usuarios son de todas las edades; muchos usarán desde móvil.

---

### RNF-07: Costo
**ID:** RNF-07  
**Categoría:** Cost  
**Descripción:** Mantener costos operacionales dentro del presupuesto.

**Métricas:**
- Infraestructura: ≤ $1.000.000/mes para MVP (500 usuarios)
- Costos de transacción: ≤ 3% por pago procesado
- Licencias de software: $0 (usar herramientas open source)

**Justificación:** Club tiene presupuesto limitado; proyecto debe ser rentable.

---

## 5. RESTRICCIONES

### 5.1 Restricciones Técnicas
- **Base de datos:** PostgreSQL (ya tiene licencia el club)
- **Cloud provider:** AWS (ya tiene cuenta corporativa)
- **Lenguaje backend:** Node.js o Python (expertise del equipo)
- **Integración membresías:** API SOAP legacy (no se puede cambiar)

### 5.2 Restricciones de Negocio
- **Lanzamiento:** MVP en 6 meses máximo
- **Equipo:** 3 desarrolladores full-time
- **Presupuesto:** $1.000.000/mes infraestructura + $0 licencias
- **No disrupciones:** Sistema actual debe seguir funcionando durante transición

### 5.3 Restricciones Regulatorias
- **Ley 1581 (Colombia):** Protección de datos personales
- **PCI-DSS:** No almacenar datos de tarjetas de crédito

---

## 6. SUPUESTOS Y DEPENDENCIAS

### 6.1 Supuestos
- Sistema universitario tiene API SOAP funcional y documentada
- La Universidad proveerá acceso a datos de miembros para migración inicial
- Wompi soporta reembolsos automáticos
- Internet en el club es estable (para staff)

### 6.2 Dependencias
- **Sistema Universitario:** Para validar estado de miembros
- **Wompi:** Para procesar pagos
- **Twilio SendGrid:** Para enviar emails
- **AWS:** Para hosting e infraestructura

---

## 7. CRITERIOS DE ACEPTACIÓN DEL SISTEMA

El sistema será aceptado cuando:

✅ Todos los RF de prioridad Alta estén implementados y funcionando  
✅ Se cumplan todas las métricas de RNF-01 a RNF-04  
✅ 10 usuarios beta completen 50 reservas sin errores críticos  
✅ Integración con sistema universitario funcione correctamente  
✅ Integración con Wompi procese pagos exitosamente  
✅ Documentación técnica (SAD) esté completa  
✅ Staff del club esté capacitado en uso del panel administrativo  

---

## 8. FUERA DE ALCANCE (MVP)

Lo siguiente NO está incluido en el MVP:

❌ Aplicación móvil nativa (solo web responsive)  
❌ Reservas recurrentes (semanales/mensuales)  
❌ Sistema de puntos o descuentos  
❌ Chat en vivo con soporte  
❌ Integración con calendario personal (Google Calendar, etc.)  
❌ Reportes avanzados con gráficos  
❌ Multitenancy (soporte para múltiples clubes universitarios)  

Estos podrán considerarse en fases posteriores según feedback.

---

## APROBACIONES

| Rol                                          | Nombre         | Firma | Fecha |
|----------------------------------------------|----------------|-------|-------|
| **Cliente - Gerente del Club Universitario** | ______________ | __________ | ___/___/___ |
| **Arquitecto de Software**                   | [Tu nombre]    | __________ | ___/___/___ |
| **Líder de Proyecto**                        | ______________ | __________ | ___/___/___ |

---

**Fin del Documento SRS**

---

## NOTAS

Este SRS representa un **documento real de requisitos** tal como se entregaría en un proyecto profesional.

**Aspectos clave:**
1. **Claridad:** Cada requisito tiene ID, prioridad, descripción y criterios medibles
2. **Trazabilidad:** Fácil referenciar requisitos en el SAD
3. **Métricas:** RNF tienen valores específicos, no vagos ("rápido" → "≤ 2 segundos")
4. **Alcance claro:** Define qué SÍ y qué NO está incluido
5. **Contexto:** Explica el "por qué" detrás de cada requisito

**Siguiente paso:** Usar este SRS como entrada para diseñar la arquitectura (SAD).
