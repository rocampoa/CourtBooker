# 📚 Court Booker - Ejemplo Completo de Documentación Arquitectural

**Sistema de Reservas de Canchas Deportivas**  
**Pontificia Universidad Javeriana - Arquitectura de Software**

---

## 🎯 Propósito de este Material

Este es un **ejemplo pedagógico completo** del proceso de documentación arquitectural, 
desde requisitos iniciales hasta la visualización técnica (diagramas), pasando por el 
registro crítico de decisiones arquitecturales documentadas.

**Este repositorio ha sido diseñado con un enfoque modular, permitiendo que cada sección funcione como una plantilla técnica**.
El objetivo es que estos documentos sirvan de base estandarizada para el desarrollo de futuros proyectos, 
facilitando la adopción de buenas prácticas de ingeniería y arquitectura de software
tanto en el ámbito académico como en el ejercicio profesional

**Muestra:**
1. Cómo escribir un **SRS (Software Requirements Specification)**: Definición clara del problema, requisitos funcionales y no funcionales y alcance.
2. Cómo documentar **decisiones arquitecturales (ADRs)**: Registro histórico y justificado de las decisiones técnicas y arquitectónicas.
3. Cómo crear **vistas C4** con Structurizr : Visualización de la arquitectura mediante *Diagramas como Código (Diagram-as-Code)*
4. Cómo escribir un **SAD (Software Architecture Document)** completo: El documento maestro que consolida la visión global y el diseño arquitectónico
5. La **secuencia correcta** lógica y cronológica de estos artefactos en un proyecto real

---

## 📁 Archivos Incluidos

```
CourtBooker_Documentation/
│
├── 01_SRS_CourtBooker.md                       # Requisitos del sistema
├── 02_CourtBooker_Architecture.dsl             # Vistas C4 en Structurizr DSL
├── 03_ADR-001_Service_Based_Architecture.md    # Decisión: estilo arquitectural
├── 04_ADR-002_PostgreSQL_Database.md           # Decisión: base de datos
├── 05_ADR-003_RabbitMQ_Async_Notifications.md  # Decisión: notificaciones asíncronas
├── 06_SAD_CourtBooker.md                       # Documento de arquitectura maestro
└── README.md                                   # Este archivo
```

---

## 🔄 Flujo del Proceso de Documentación

### Secuencia Recomendada

```
1. SRS (Requisitos)
   ↓
   Cliente/PM define qué necesita el sistema
   Analistas capturan requisitos funcionales y no funcionales
   
2. Diseño Inicial
   ↓
   Arquitecto identifica drivers arquitecturales (ASRs)
   Arquitecto explora alternativas de diseño
   
3. ADRs (Decisiones)
   ↓
   Para cada decisión importante, documentar:
   - Contexto y problema
   - Alternativas consideradas
   - Decisión tomada y justificación
   - Consecuencias (positivas y negativas)
   
4. Vistas C4 (Diagramas)
   ↓
   Crear diagramas en Structurizr DSL:
   - Context (Nivel 1)
   - Container (Nivel 2)
   - Component (Nivel 3)
   - Deployment
   
5. SAD (Documento Maestro)
   ↓
   Reunir todo en un documento cohesivo:
   - Referencias a SRS y ADRs
   - Vistas arquitecturales
   - Tecnologías seleccionadas
   - Estrategia de despliegue
   - Riesgos y evolución
```

---

## 📖 Guía de Uso por Documento

### 1️⃣ SRS - Software Requirements Specification

**Archivo:** `01_SRS_CourtBooker.md`

**Quién lo escribe:** Product Manager, Business Analyst, con input de clientes  
**Cuándo:** ANTES de diseñar la arquitectura  
**Audiencia:** Todos los stakeholders

**Contenido:**
- Requisitos funcionales (RF-01, RF-02, etc.)
- Requisitos no funcionales (RNF-01, RNF-02, etc.)
- Restricciones del proyecto
- Criterios de aceptación

**Aspectos importantes:**
- ✅ Cada requisito tiene ID único (trazabilidad)
- ✅ RNF tienen métricas específicas (no "debe ser rápido" sino "≤ 2 segundos")
- ✅ Explicación del "por qué" (contexto de negocio)
- ✅ Definición clara de alcance (qué SÍ y qué NO)

**Se usa este documento para:**
- Identificar drivers arquitecturales
- Validar que la arquitectura cumple requisitos
- Estimar tiempo y costo

---

### 2️⃣ Structurizr DSL - Vistas C4

**Archivo:** `02_CourtBooker_Architecture.dsl`

**Quién lo escribe:** Arquitecto de Software  
**Cuándo:** DESPUÉS del SRS, durante diseño  
**Audiencia:** Equipo técnico

**Cómo visualizar:**

**Opción A: Structurizr Online (RECOMENDADO)**
1. Ir a https://structurizr.com/dsl
2. Copiar y pegar el contenido del archivo `.dsl`
3. Click en "Render"
4. Ver las diferentes vistas en el menú izquierdo

**Opción B: Structurizr Lite (Local)**
```bash
# Usando Docker
docker pull structurizr/lite
docker run -it --rm -p 8080:8080 \
  -v /path/to/this/folder:/usr/local/structurizr \
  structurizr/lite

# Abrir http://localhost:8080
```

**Vistas incluidas:**
1. **SystemContext** - C4 Nivel 1 (sistema + usuarios + externos)
2. **Containers** - C4 Nivel 2 (aplicaciones/servicios internos)
3. **ComponentsBookingService** - C4 Nivel 3 (componentes de un servicio)
4. **ComponentsPaymentService** - C4 Nivel 3 (componentes de otro servicio)
5. **Deployment** - Infraestructura AWS

**Aspectos Importantes:**
- ✅ 4 niveles de abstracción (Context → Container → Component → Code)
- ✅ Relaciones claras entre elementos
- ✅ Tecnologías especificadas
- ✅ Deployment realista en AWS

**Notas:**
- Visitar la página oficial de *C4 Model* https://c4model.com/  
- Consultar el libro *"The C4 Model Visualizing Software Architecture - Simon Brown - O'Reilly"* ya saben como 
buscarlo en la biblioteca de la Universidad
- Leer la documentación del lenguaje utilizado por **Structurizr** https://docs.structurizr.com/
  (Aclaración DSL es (Domain Specific Language) no es un término específico para el lenguage para diagramas de arquitectura, cualquiera pueda crear un lenguage para resolver un problema de un dominio específico,
   en este caso Structurizr creo este lenguaje para generar diagrams de arquitectura)
---

### 3️⃣ ADRs - Architectural Decision Records

**Archivos:**
- `03_ADR-001_Service_Based_Architecture.md`
- `04_ADR-002_PostgreSQL_Database.md`
- `05_ADR-003_RabbitMQ_Async_Notifications.md`

**Quién los escribe:** Arquitecto de Software (con input del equipo)  
**Cuándo:** Cuando se toma una decisión arquitectural importante  
**Audiencia:** Equipo técnico, futuros mantenedores

**Nota:** Estos ADRs pasan a ser anexos del SAD, en este ejemplo cree 3, pero pueden ser más dependiendo del 
problema que se esté documentando y de las decisiones arquitectónicas tomadas.

**Formato estándar de ADR:**

```markdown
# ADR-XXX: Título de la Decisión

**Estado:** Propuesto | Aceptado | Rechazado | Supersedido | Deprecado
**Fecha:** YYYY-MM-DD
**Decisores:** Quiénes participaron

## Contexto y Problema
¿Qué problema estamos resolviendo?

## Drivers de Decisión
- Factores que influyen en la decisión
- Requisitos, restricciones, prioridades

## Decisión
¿Qué decidimos hacer?

## Justificación
¿Por qué esta opción y no otras?

## Alternativas Descartadas
¿Qué más consideramos? ¿Por qué no elegimos eso?

## Consecuencias
- Positivas ✅
- Negativas ⚠️ (y cómo las mitigamos)
```

**Aspectos Importantes:**
- ✅ Decisiones justificadas, no arbitrarias
- ✅ Trade-offs explícitos (qué sacrificamos)
- ✅ Alternativas documentadas (demuestra pensamiento y actitud crítica del arquitecto)
- ✅ Consecuencias honestas (no solo vender la decisión)

**Decisiones documentadas:**
1. **ADR-001:** ¿Monolito, Microservicios o Service-Based? → Service-Based
2. **ADR-002:** ¿PostgreSQL, MySQL, MongoDB o DynamoDB? → PostgreSQL
3. **ADR-003:** ¿Notificaciones síncronas o asíncronas? → Asíncronas con RabbitMQ

---

### 4️⃣ SAD - Software Architecture Document

**Archivo:** `06_SAD_CourtBooker.md`

**Quién lo escribe:** Arquitecto de Software  
**Cuándo:** DESPUÉS de ADRs y vistas C4  
**Audiencia:** Todo el equipo técnico

**Es el documento MAESTRO que reúne:**
- Referencias al SRS
- Enlaces a ADRs
- Vistas C4 (con instrucciones de visualización)
- Stack tecnológico completo
- Estrategia de seguridad
- Plan de despliegue
- Riesgos y deuda técnica

**Secciones principales:**
1. Introducción y propósito
2. Descripción general de la arquitectura
3. Vistas arquitecturales (C4)
4. Decisiones arquitecturales (ADRs)
5. Tecnologías y herramientas
6. Seguridad
7. Despliegue e infraestructura
8. Calidad y atributos
9. Riesgos y deuda técnica
10. Apéndices

**Aspectos Importantes:**
- ✅ Documento completo y profesional
- ✅ Trazabilidad entre requisitos y decisiones
- ✅ Mapa de atributos de calidad a decisiones arquitecturales
- ✅ Transparencia sobre riesgos y limitaciones
- ✅ Plan de evolución futura

**Usa este documento para:**
- Onboarding de nuevos developers
- Referencia durante implementación
- Comunicación con stakeholders
- Code reviews (verificar adherencia)

---

## 🎓 Aspectos Clave

### 1. Trazabilidad End-to-End

```
RF-03 (Crear Reserva) en SRS
  ↓
DR-05 (Latencia < 3seg) identificado
  ↓
ADR-003 (RabbitMQ async) para cumplir DR-05
  ↓
Vista C4 Container muestra RabbitMQ
  ↓
SAD sección 8.1 mapea DR-05 → ADR-003
```

### 2. Justificación de Decisiones

Cada decisión arquitectural incluye:
- ✅ **Contexto:** ¿Por qué necesitamos decidir esto?
- ✅ **Alternativas:** ¿Qué más consideramos?
- ✅ **Trade-offs:** ¿Qué sacrificamos?
- ✅ **Consecuencias:** ¿Qué implicaciones tiene?

### 3. Realismo

- ✅ Presupuesto realista ($3,000/mes)
- ✅ Equipo pequeño (3 developers)
- ✅ Timeline ajustado (6 meses)
- ✅ Restricciones técnicas (sistema legacy SOAP)
- ✅ Contexto colombiano (Ley 1581, Wompi)

### 4. Profesionalismo

- ✅ Formato estándar de documentos
- ✅ Control de versiones
- ✅ Sección de aprobaciones
- ✅ Referencias cruzadas
- ✅ Glosario de términos

---

## 💡 Cómo Usar en Clase

### Para el Profesor:

**Opción 1: Mostrar el proceso completo**
1. Proyectar SRS → "Así se capturan requisitos"
2. Mostrar vistas C4 en Structurizr → "Así se visualiza la arquitectura"
3. Leer ADR-001 → "Así se documentan decisiones"
4. Revisar SAD → "Así se reúne todo"

**Opción 2: Ejercicio práctico**
1. Dar el SRS a estudiantes
2. Pedirles que diseñen arquitectura
3. Pedirles que documenten 2-3 ADRs
4. Comparar con ADRs de ejemplo
5. Discutir alternativas y trade-offs

**Opción 3: Análisis crítico**
- ¿Están de acuerdo con ADR-001? ¿Elegirían Monolito o Microservicios?
- ¿Qué otros drivers arquitecturales identificarían?
- ¿Qué riesgos adicionales ven?

### Para Estudiantes:

**Cómo estudiar este material:**
1. Leer SRS primero → Entender el problema
2. Intentar diseñar arquitectura por cuenta propia
3. Leer ADRs → Comparar con tu diseño
4. Ver vistas C4 → Visualizar la solución
5. Leer SAD → Ver cómo se integra todo

**Ejercicio de práctica:**
- Tomar otro caso (ej: MediConnect del parcial)
- Crear SRS simplificado
- Documentar 3 ADRs
- Crear vistas C4 básicas
- Escribir SAD resumido

---

## 📊 Comparación de Enfoques

| Aspecto | Enfoque Tradicional | Este Ejemplo (Moderno) |
|---------|---------------------|------------------------|
| **SRS** | 100+ páginas, casos de uso UML | Conciso, métricas específicas |
| **Diseño** | Solo diagramas UML | C4 Model (4 niveles de zoom) |
| **Decisiones** | No documentadas o en Word | ADRs en Markdown (versionables) |
| **Diagramas** | Visio, PowerPoint | Structurizr DSL (código) |
| **SAD** | Documento monolítico | Modular, referencias a ADRs |

**Ventajas del enfoque moderno:**
- ✅ Diagramas como código (versionables en Git)
- ✅ ADRs lightweight (fácil crear y mantener)
- ✅ Trazabilidad clara entre documentos
- ✅ Fácil actualizar cuando arquitectura evoluciona

---

## 🔧 Herramientas Utilizadas

| Herramienta | Uso | Costo |
|-------------|-----|-------|
| **Markdown** | SRS, ADRs, SAD | Gratis |
| **Structurizr DSL** | Vistas C4 | Gratis (online) / $15/mes (pro) |
| **Git** | Versionamiento | Gratis |
| **VS Code** | Edición | Gratis |

**No se necesitan herramientas caras** → Todo en texto plano, versionable.

---

## 📚 Referencias y Recursos

**Documentación C4 Model:**
- https://c4model.com/
- https://structurizr.com/

**ADRs:**
- https://adr.github.io/
- https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions

**Libros recomendados:**
- "Documenting Software Architectures" - Clements et al.
- "Software Architecture in Practice" - Bass, Clements, Kazman
- "The Process of Software Architecting" - Eeles, Cripps

---

## ✅ Checklist de Calidad

**Al entregar documentación arquitectural, verifica:**

**SRS:**
- [ ] Requisitos funcionales con IDs únicos
- [ ] Requisitos no funcionales con métricas específicas
- [ ] Restricciones documentadas
- [ ] Alcance claro (qué SÍ y qué NO)

**ADRs:**
- [ ] Contexto y problema explicados
- [ ] Al menos 2 alternativas consideradas
- [ ] Trade-offs explícitos
- [ ] Consecuencias documentadas (positivas y negativas)

**Vistas C4:**
- [ ] Nivel 1 (Context) incluido
- [ ] Nivel 2 (Container) incluido
- [ ] Al menos 1 vista Nivel 3 (Component)
- [ ] Tecnologías especificadas
- [ ] Relaciones claras

**SAD:**
- [ ] Referencias a SRS y ADRs
- [ ] Vistas arquitecturales incluidas
- [ ] Stack tecnológico documentado
- [ ] Estrategia de despliegue
- [ ] Riesgos identificados
- [ ] Plan de evolución

---

## 🎯 Próximos Pasos

1. Lee todos los documentos en orden
2. Aplica el mismo proceso a los ejercicios propuestos en el curso
3. Reflexiona sobre trade-offs
4. Usa los formatos como plantillas para tus proyectos
4. Adapta los formatos a tus proyectos reales en tu vida profesional


**Pontificia Universidad Javeriana**  
Arquitectura de Software  
Profesor: Rafael Ocampo

---

**Creado:** Marzo 2026  
**Última actualización:** 13 de marzo de 2026
