# ADR-003: RabbitMQ para Procesamiento Asíncrono de Notificaciones

**Estado:** Aceptado  
**Fecha:** 14-03-2026 
**Decisores:** Equipo de Arquitectura  
**Relacionado con:** RF-06, RNF-01, RNF-05

---

## Contexto y Problema

El sistema necesita enviar notificaciones por email en varios eventos:
- Confirmación de reserva
- Recordatorio 2 horas antes
- Confirmación de cancelación
- Recibo de pago

**Problema:** El envío de emails es lento (500ms-2seg) y puede fallar. No queremos que esto bloquee las operaciones críticas de reserva y pago.

**Requisitos:**
- Reserva debe confirmarse rápido (< 3seg) independiente del email
- Emails deben enviarse eventualmente, incluso si falla el primer intento
- Si SendGrid está caído, no debe afectar las reservas
- Debe ser fácil agregar otros tipos de notificaciones (SMS futuro)

---

## Drivers de Decisión

- **DR-01:** Latencia de reserva < 3seg (RNF-01)
- **DR-02:** Resiliencia - fallo en email no bloquea reserva (RNF-02)
- **DR-03:** Retry automático de notificaciones fallidas (Alta prioridad)
- **DR-04:** Fácil agregar nuevos tipos de notificaciones (RNF-05)
- **DR-05:** Costo ≤ $200.000/mes (Constraint)

---

## Decisión

Implementamos **procesamiento asíncrono** usando **RabbitMQ** como message broker.

**Arquitectura:**
```
Booking Service → Crea reserva (200ms)
                → Publica evento "BookingCreated" a RabbitMQ (10ms)
                → Responde al usuario (total: 210ms) ✅

RabbitMQ Queue → Notification Service consume evento (async)
              → Envía email vía SendGrid (500ms-2seg)
              → ACK si exitoso, NACK+requeue si falla
```

**Configuración:**
- **Exchange:** Topic exchange "events"
- **Queues:** 
  - notifications.email (consumer: Notification Service)
  - notifications.sms (futuro)
- **Durability:** Mensajes persistentes (sobreviven restart)
- **Dead Letter Queue:** Mensajes fallidos > 3 reintentos
- **Retry policy:** Exponential backoff (1min, 5min, 15min)

---

## Justificación

### Por qué RabbitMQ:

**✅ Cumple requisitos técnicos:**
1. **Desacoplamiento:** Booking Service no conoce Notification Service
2. **Resiliencia:** Si SendGrid cae, mensajes esperan en queue
3. **Retry automático:** NACK + requeue = retry sin código custom
4. **Durabilidad:** Mensajes no se pierden si RabbitMQ reinicia
5. **Orden:** Garantiza orden FIFO por cola

**✅ Cumple requisitos de negocio:**
1. **Performance:** Publicar a RabbitMQ = 5-10ms (vs 500ms-2seg de email)
2. **Costo:** EC2 t3.small = $15.000/mes (+$30.000 backup) = $45.000/mes total
3. **Monitoring:** Management UI built-in
4. **Familiaridad:** Equipo conoce RabbitMQ

---

## Alternativas Descartadas

### Alternativa 1: Síncrono (sin queue)

```
Booking Service → Crea reserva (200ms)
                → Llama a Notification Service (500ms-2seg) ❌
                → Responde al usuario (total: 700ms-2.2seg)
```

**Por qué descartada:**
- Viola DR-01 (latencia < 3seg, pero queremos < 500ms)
- Si SendGrid cae, reservas fallan (viola DR-02)
- No hay retry automático

**Cuándo sería mejor:**
- Sistema muy simple con pocas notificaciones
- No hay requisitos de performance

### Alternativa 2: AWS SQS

**Por qué descartada:**
- Costo más alto: $1.600 por 1M requests vs $45.000/mes flat
- No garantiza orden estricto (Standard queue)
- FIFO queue limitado a 300 msg/seg (suficiente, pero menos flexible)
- Equipo prefiere RabbitMQ

**Cuándo sería mejor:**
- Sistema 100% en AWS (menos infraestructura)
- Escala muy alta (millones de mensajes/día)
- No necesitas orden garantizado

### Alternativa 3: AWS EventBridge

**Por qué descartada:**
- Overkill para caso simple
- Más complejo de configurar
- Más caro

**Cuándo sería mejor:**
- Event-driven architecture compleja
- Integraciones con muchos servicios AWS

### Alternativa 4: Kafka

**Por qué descartada:**
- Complejidad operacional muy alta
- Costo: mínimo $200.000/mes (Kafka cluster)
- Overkill para nuestro volumen (< 1,000 eventos/día)

**Cuándo sería mejor:**
- Streaming de datos en tiempo real
- Event sourcing
- Millones de eventos/día

---

## Consecuencias

### ✅ Positivas:

1. **Latencia mejorada:** Reserva responde en ~210ms (vs 700ms-2seg)
2. **Resiliencia:** Emails fallan → se reintentarán, reserva YA confirmada
3. **Visibilidad:** RabbitMQ Management UI para monitorear colas
4. **Extensible:** Fácil agregar SMS, push notifications
5. **Testing:** Fácil mockear eventos en tests

### ⚠️ Negativas (mitigadas):

1. **Complejidad operacional:**
   - Necesitamos monitorear RabbitMQ
   - Mitigación: CloudWatch alarms en queue depth

2. **Eventual consistency:**
   - Usuario ve "Reserva confirmada" pero email llega 10seg después
   - Mitigación: Mostrar mensaje "Recibirás confirmación por email"

3. **Dead Letter Queue management:**
   - Mensajes fallidos > 3 veces van a DLQ
   - Mitigación: Dashboard para revisar DLQ, alertas

---

## Detalles de Implementación

### Eventos publicados:
```javascript
// BookingCreated event
{
  "eventType": "booking.created",
  "timestamp": "2026-03-13T10:30:00Z",
  "data": {
    "bookingId": "bk_123",
    "userId": "usr_456",
    "courtId": "court_1",
    "date": "15-03-2026",
    "time": "18:00",
    "userEmail": "juan@example.com"
  }
}
```

### Infraestructura RabbitMQ:
- **EC2:** t3.small (2 vCPU, 2GB RAM)
- **Storage:** 20GB EBS
- **Backup:** Automated snapshots diarios
- **Monitoring:** CloudWatch + RabbitMQ Metrics Plugin

---

## Métricas de Éxito

- [ ] P95 latencia de publicar evento < 20ms
- [ ] Emails entregados > 99% (después de retries)
- [ ] Queue depth promedio < 100 mensajes
- [ ] 0 mensajes perdidos
- [ ] Costo RabbitMQ ≤ $50/mes

---

## Revisión Futura

Si volumen crece > 10,000 eventos/día:
- Considerar cluster de RabbitMQ (HA)
- O migrar a AWS SQS (managed)

---

**Estado final:** ACEPTADO ✅
