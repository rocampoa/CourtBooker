# Software Requirements Specification (SRS)
## Sistema de Gestión de Parqueaderos - "ParkEasy"

**Versión:** 1.0  
**Fecha:** [Completar]  
**Grupo:** [Número de grupo]  
**Integrantes:**
- [Nombre 1] - [Código]
- [Nombre 2] - [Código]
- [Nombre 3] - [Código]
- [Nombre 4] - [Código]

---

## 1. INTRODUCCIÓN

### 1.1 Propósito
<!-- Explicar brevemente para qué sirve este documento SRS -->

### 1.2 Alcance
<!-- Describir qué hace ParkEasy y qué beneficios trae -->

### 1.3 Definiciones, Acrónimos y Abreviaciones

| Término | Definición |
|---------|------------|
| LPR | License Plate Recognition (Reconocimiento de Placas) |
| MVP | Minimum Viable Product |
| DIAN | Dirección de Impuestos y Aduanas Nacionales |
| [Agregar otros] | |

### 1.4 Referencias
- Enunciado del taller
- [Otras referencias si las hay]

---

## 2. DESCRIPCIÓN GENERAL DEL SISTEMA

### 2.1 Perspectiva del Producto
<!-- Explicar cómo ParkEasy se integra con sistemas existentes -->
<!-- Mencionar: cámaras LPR, sistema legacy VB6, pasarela de pagos -->

### 2.2 Funciones del Producto
<!-- Listar las funciones principales en bullet points -->
Ejemplo:
1. Gestión de disponibilidad en tiempo real
2. Reservas anticipadas
3. [Completar con otras funciones]

### 2.3 Características de Usuarios

| Tipo de Usuario | Descripción | Nivel de Expertise |
|-----------------|-------------|--------------------|
| **Conductor** | [Completar] | Básico - no técnico |
| **Operador** | [Completar] | Básico - educación básica |
| **Administrador** | [Completar] | Medio - usa Excel, reportes |

### 2.4 Restricciones del Sistema

**Restricciones técnicas:**
- [Listar restricciones del enunciado]
- Ejemplo: Debe integrarse con cámaras LPR existentes

**Restricciones de negocio:**
- Presupuesto: $2.000.000 USD/mes
- [Otras del enunciado]

**Restricciones regulatorias:**
- Ley 1581 (Colombia)
- [Otras]

---

## 3. REQUISITOS FUNCIONALES

**INSTRUCCIONES:** 
- Documentar mínimo 6 requisitos funcionales
- Cada uno debe tener: ID, Prioridad, Descripción, Criterios de aceptación
- IDs en formato: RF-01, RF-02, etc.

---

### RF-01: [Nombre del requisito]
**Prioridad:** Alta | Media | Baja  
**Descripción:** [Explicar qué debe hacer el sistema]

**Criterios de aceptación:**
- [Criterio 1 - debe ser medible/verificable]
- [Criterio 2]
- [Criterio 3]

---

### RF-02: [Nombre del requisito]
**Prioridad:** Alta | Media | Baja  
**Descripción:** [Explicar qué debe hacer el sistema]

**Criterios de aceptación:**
- [Criterio 1]
- [Criterio 2]
- [Criterio 3]

---

### RF-03: [Nombre del requisito]
**Prioridad:** Alta | Media | Baja  
**Descripción:** [Explicar qué debe hacer el sistema]

**Criterios de aceptación:**
- [Criterio 1]
- [Criterio 2]
- [Criterio 3]

---

### RF-04: [Nombre del requisito]
**Prioridad:** Alta | Media | Baja  
**Descripción:** [Explicar qué debe hacer el sistema]

**Criterios de aceptación:**
- [Criterio 1]
- [Criterio 2]
- [Criterio 3]

---

### RF-05: [Nombre del requisito]
**Prioridad:** Alta | Media | Baja  
**Descripción:** [Explicar qué debe hacer el sistema]

**Criterios de aceptación:**
- [Criterio 1]
- [Criterio 2]
- [Criterio 3]

---

### RF-06: [Nombre del requisito]
**Prioridad:** Alta | Media | Baja  
**Descripción:** [Explicar qué debe hacer el sistema]

**Criterios de aceptación:**
- [Criterio 1]
- [Criterio 2]
- [Criterio 3]

---

<!-- AGREGAR MÁS RF SI ES NECESARIO -->

---

## 4. REQUISITOS NO FUNCIONALES

**INSTRUCCIONES:** 
- Documentar mínimo 5 requisitos no funcionales
- CADA UNO DEBE TENER MÉTRICAS ESPECÍFICAS (no vago)
- Categorías sugeridas: Performance, Disponibilidad, Escalabilidad, Seguridad, Usabilidad, Costo
- IDs en formato: RNF-01, RNF-02, etc.

---

### RNF-01: [Categoría - ej: Performance]
**ID:** RNF-01  
**Categoría:** Performance | Availability | Scalability | Security | Usability | Cost  
**Descripción:** [Explicar el requisito]

**Métricas:**
<!-- IMPORTANTE: Debe ser medible y específico -->
<!-- MAL: "Debe ser rápido" -->
<!-- BIEN: "Tiempo de entrada/salida ≤ 5 segundos P95" -->

- Métrica 1: [Valor específico]
- Métrica 2: [Valor específico]

**Justificación:** [Por qué es importante este requisito]

---

### RNF-02: [Categoría]
**ID:** RNF-02  
**Categoría:** Performance | Availability | Scalability | Security | Usability | Cost  
**Descripción:** [Explicar el requisito]

**Métricas:**
- Métrica 1: [Valor específico]
- Métrica 2: [Valor específico]

**Justificación:** [Por qué es importante]

---

### RNF-03: [Categoría]
**ID:** RNF-03  
**Categoría:** Performance | Availability | Scalability | Security | Usability | Cost  
**Descripción:** [Explicar el requisito]

**Métricas:**
- Métrica 1: [Valor específico]
- Métrica 2: [Valor específico]

**Justificación:** [Por qué es importante]

---

### RNF-04: [Categoría]
**ID:** RNF-04  
**Categoría:** Performance | Availability | Scalability | Security | Usability | Cost  
**Descripción:** [Explicar el requisito]

**Métricas:**
- Métrica 1: [Valor específico]
- Métrica 2: [Valor específico]

**Justificación:** [Por qué es importante]

---

### RNF-05: [Categoría]
**ID:** RNF-05  
**Categoría:** Performance | Availability | Scalability | Security | Usability | Cost  
**Descripción:** [Explicar el requisito]

**Métricas:**
- Métrica 1: [Valor específico]
- Métrica 2: [Valor específico]

**Justificación:** [Por qué es importante]

---

<!-- AGREGAR MÁS RNF SI ES NECESARIO -->

---

## 5. ALCANCE DEL MVP

### 5.1 Dentro de Alcance (MVP)
<!-- Listar funcionalidades QUE SÍ están en el MVP -->
<!-- Ser específicos -->

✅ Funcionalidad 1  
✅ Funcionalidad 2  
✅ Funcionalidad 3  
✅ [Completar]

### 5.2 Fuera de Alcance (MVP)
<!-- Listar funcionalidades QUE NO están en el MVP -->
<!-- Explicar por qué no (tiempo, costo, complejidad) -->

❌ Funcionalidad 1 - [Por qué no]  
❌ Funcionalidad 2 - [Por qué no]  
❌ [Completar]

---

## 6. SUPUESTOS Y DEPENDENCIAS

### 6.1 Supuestos
<!-- Listar cosas que asumen que son ciertas -->
<!-- Ejemplo: "Asumimos que el API de cámaras LPR tiene uptime ≥ 99%" -->

1. [Supuesto 1]
2. [Supuesto 2]
3. [Supuesto 3]

### 6.2 Dependencias
<!-- Listar sistemas/servicios externos de los que depende ParkEasy -->

1. **Sistema de Cámaras LPR:** [Descripción breve]
2. **Sistema de Cobro Legacy:** [Descripción breve]
3. **Pasarela de Pagos:** [Descripción breve]
4. [Otras]

---

## 7. CRITERIOS DE ACEPTACIÓN DEL SISTEMA

<!-- Listar condiciones que deben cumplirse para que el sistema sea aceptado -->

El sistema ParkEasy será aceptado cuando:

- [ ] [Criterio 1]
- [ ] [Criterio 2]
- [ ] [Criterio 3]
- [ ] [Agregar más]

---

## 8. DRIVERS ARQUITECTURALES IDENTIFICADOS

<!-- Esta sección ayudará con los ADRs -->
<!-- Listar los 5-7 requisitos que MÁS impactan la arquitectura -->

| ID | Driver | Valor/Métrica            | Prioridad |
|----|--------|--------------------------|-----------|
| **DR-01** | [Ej: Performance] | [Ej: ≤ 5 seg]            | Alta |
| **DR-02** | [Ej: Escalabilidad] | [Ej: 450→1,200 espacios] | Alta |
| **DR-03** | [Ej: Costo] | [Ej: ≤ $500.000/mes]     | Alta |
| **DR-04** | [Completar] | [Completar]              | [Completar] |
| **DR-05** | [Completar] | [Completar]              | [Completar] |

---

## APROBACIONES

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| **Líder del Grupo** | [Nombre] | __________ | ___/___/___ |
| **Integrante 2** | [Nombre] | __________ | ___/___/___ |
| **Integrante 3** | [Nombre] | __________ | ___/___/___ |
| **Integrante 4** | [Nombre] | __________ | ___/___/___ |

---

**Fin del Documento SRS**

---

## NOTAS PARA TENER EN CUENTA

### ✅ Checklist de Calidad

Antes de entregar, verificar:

- [ ] Mínimo 6 requisitos funcionales documentados
- [ ] Cada RF tiene ID, prioridad, descripción y criterios
- [ ] Mínimo 5 requisitos no funcionales documentados
- [ ] Cada RNF tiene métricas ESPECÍFICAS (no vagas)
- [ ] Alcance claramente definido (qué SÍ y qué NO)
- [ ] Supuestos documentados
- [ ] Drivers arquitecturales identificados (útil para ADRs)
- [ ] Documento profesional y bien redactado
- [ ] Sin errores ortográficos

### 💡 Tips

1. **Requisitos Funcionales:** Piensen en los flujos de usuario
2. **Requisitos No Funcionales:** Usen el enunciado, tiene métricas sugeridas
3. **Drivers:** Pregúntense "¿Este requisito impacta decisiones de arquitectura?"
4. **Alcance:** Sean realistas con 8 meses y 4 devs

### ⚠️ Errores Comunes a Evitar

❌ RNF vago: "El sistema debe ser rápido"  
✅ RNF específico: "Entrada/salida ≤ 5 segundos P95"

❌ RF sin criterios de aceptación  
✅ RF con 3-5 criterios medibles

❌ No documentar supuestos  
✅ Listar todos los supuestos en sección 6.1
