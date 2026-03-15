workspace "CourtBooker - Sistema de Reservas de Canchas" "Arquitectura del sistema de reservas de canchas deportivas" {

    model {
        # Personas (Usuarios externos)
        member = person "Miembro la Universidad" "Persona asociada a la Universidad como Profesor, Estudiante, Egresado o Administrativo"
        admin = person "Administrador" "Personal que gestiona el sistema"
        guest = person "Invitado" "Usuario no registrado que consulta disponibilidad"
        
        # Sistemas externos
        universitySystem = softwareSystem "Sistema Universitario" "Sistema legacy SOAP que contiene la información del personal administrativo, docente, egresados y estudiantes de la Universidad" "External System"
        wompi = softwareSystem "Wompi" "Pasarela de pagos colombiana para procesar transacciones" "External System"
        sendgrid = softwareSystem "Twilio SendGrid" "Servicio de envío de emails transaccionales" "External System"
        
        # Sistema principal
        courtBooker = softwareSystem "CourtBooker" "Permite a los miembros de la Universidad reservar canchas deportivas online" {
            
            # CONTAINERS (Nivel 2 C4)
            webApp = container "Aplicación Web" "Interfaz de usuario responsive para navegadores" "React.js + Tailwind CSS" "Web Browser" {
                # Components dentro de Web App (Nivel 3 C4)
                loginComponent = component "Login Component" "Gestiona autenticación de usuarios" "React Component"
                availabilityComponent = component "Availability Component" "Muestra calendario de disponibilidad" "React Component"
                bookingComponent = component "Booking Component" "Permite crear/cancelar reservas" "React Component"
                adminComponent = component "Admin Dashboard" "Panel administrativo con reportes" "React Component"
            }
            
            apiGateway = container "API Gateway" "Punto de entrada único para todas las peticiones" "Kong / Nginx" "Infrastructure"
            
            authService = container "Auth Service" "Gestiona autenticación y sesiones" "Node.js + Express" "Service" {
                authController = component "Auth Controller" "Endpoints de login/logout" "Express Controller"
                jwtManager = component "JWT Manager" "Genera y valida tokens" "JWT Library"
                sessionStore = component "Session Store" "Almacena sesiones activas" "Redis Client"
            }
            
            bookingService = container "Booking Service" "Gestiona reservas y disponibilidad" "Node.js + Express" "Service" {
                bookingController = component "Booking Controller" "Endpoints de reservas" "Express Controller"
                availabilityManager = component "Availability Manager" "Calcula disponibilidad en tiempo real" "Business Logic"
                reservationRepository = component "Reservation Repository" "Acceso a datos de reservas" "TypeORM"
            }
            
            paymentService = container "Payment Service" "Procesa pagos y reembolsos" "Node.js + Express" "Service" {
                paymentController = component "Payment Controller" "Endpoints de pagos" "Express Controller"
                wompiClient = component "Wompi Client" "Cliente HTTP para Wompi API" "HTTP Client"
                transactionRepository = component "Transaction Repository" "Registra transacciones" "TypeORM"
            }
            
            notificationService = container "Notification Service" "Envía notificaciones por email" "Node.js + Express" "Service" {
                emailSender = component "Email Sender" "Envía emails transaccionales" "SendGrid Client"
                templateEngine = component "Template Engine" "Genera HTML de emails" "Handlebars"
            }
            
            adminService = container "Admin Service" "Funcionalidades administrativas y reportes" "Python + FastAPI" "Service" {
                adminController = component "Admin Controller" "Endpoints administrativos" "FastAPI Controller"
                reportGenerator = component "Report Generator" "Genera reportes y métricas" "Pandas"
            }
            
            database = container "Base de Datos Principal" "Almacena información de usuarios, reservas, canchas" "PostgreSQL 14" "Database"
            
            cache = container "Cache" "Cache de sesiones y disponibilidad" "Redis 7" "Cache"
            
            messageQueue = container "Message Queue" "Cola para procesamiento asíncrono" "RabbitMQ" "Message Queue"
        }
        
        # RELACIONES - NIVEL 1 (CONTEXT)
        member -> courtBooker "Reserva canchas, gestiona reservas" "HTTPS"
        admin -> courtBooker "Administra sistema, genera reportes" "HTTPS"
        guest -> courtBooker "Consulta disponibilidad" "HTTPS"
        
        courtBooker -> universitySystem "Valida estado de pertenencia a la Universidad" "SOAP/XML"
        courtBooker -> wompi "Procesa pagos y reembolsos" "REST/JSON"
        courtBooker -> sendgrid "Envía notificaciones por email" "REST/JSON"
        
        # RELACIONES - NIVEL 2 (CONTAINER)
        member -> webApp "Usa" "HTTPS"
        admin -> webApp "Usa" "HTTPS"
        guest -> webApp "Usa" "HTTPS"
        
        webApp -> apiGateway "Hace peticiones API" "HTTPS/JSON"
        
        apiGateway -> authService "Autentica usuarios" "HTTP/JSON"
        apiGateway -> bookingService "Gestiona reservas" "HTTP/JSON"
        apiGateway -> paymentService "Procesa pagos" "HTTP/JSON"
        apiGateway -> adminService "Funciones admin" "HTTP/JSON"
        
        authService -> database "Lee/Escribe usuarios" "TCP/PostgreSQL"
        authService -> cache "Almacena sesiones" "TCP/Redis"
        authService -> universitySystem "Valida que se miembro de la Universidad" "SOAP/XML"
        
        bookingService -> database "Lee/Escribe reservas" "TCP/PostgreSQL"
        bookingService -> cache "Cache de disponibilidad" "TCP/Redis"
        bookingService -> messageQueue "Publica eventos" "AMQP"
        
        paymentService -> database "Registra transacciones" "TCP/PostgreSQL"
        paymentService -> wompi "Procesa pagos" "HTTPS/JSON"
        paymentService -> messageQueue "Publica eventos de pago" "AMQP"
        
        notificationService -> messageQueue "Consume eventos" "AMQP"
        notificationService -> sendgrid "Envía emails" "HTTPS/JSON"
        
        adminService -> database "Consulta datos" "TCP/PostgreSQL"
        
        # RELACIONES - NIVEL 3 (COMPONENT - WEB APP)
        loginComponent -> authController "POST /auth/login" "HTTPS/JSON"
        availabilityComponent -> bookingController "GET /bookings/availability" "HTTPS/JSON"
        bookingComponent -> bookingController "POST /bookings, DELETE /bookings/:id" "HTTPS/JSON"
        bookingComponent -> paymentController "POST /payments" "HTTPS/JSON"
        adminComponent -> adminController "GET /admin/reports" "HTTPS/JSON"
        
        # RELACIONES - NIVEL 3 (COMPONENT - AUTH SERVICE)
        authController -> jwtManager "Genera token" "Method Call"
        authController -> sessionStore "Guarda sesión" "Method Call"
        jwtManager -> sessionStore "Valida token" "Method Call"
        sessionStore -> cache "Lee/Escribe" "Redis Protocol"
        
        # RELACIONES - NIVEL 3 (COMPONENT - BOOKING SERVICE)
        bookingController -> availabilityManager "Calcula disponibilidad" "Method Call"
        bookingController -> reservationRepository "CRUD reservas" "Method Call"
        availabilityManager -> reservationRepository "Consulta reservas" "Method Call"
        reservationRepository -> database "SQL Queries" "PostgreSQL Protocol"
        
        # RELACIONES - NIVEL 3 (COMPONENT - PAYMENT SERVICE)
        paymentController -> wompiClient "Procesa pago" "Method Call"
        paymentController -> transactionRepository "Registra transacción" "Method Call"
        wompiClient -> wompi "POST /transactions" "HTTPS/JSON"
        transactionRepository -> database "SQL Queries" "PostgreSQL Protocol"
        
        # RELACIONES - NIVEL 3 (COMPONENT - NOTIFICATION SERVICE)
        emailSender -> templateEngine "Renderiza template" "Method Call"
        emailSender -> sendgrid "POST /mail/send" "HTTPS/JSON"
        
        # RELACIONES - NIVEL 3 (COMPONENT - ADMIN SERVICE)
        adminController -> reportGenerator "Genera reporte" "Method Call"
        reportGenerator -> database "Consulta datos" "PostgreSQL Protocol"
        
        # DEPLOYMENT (Opcional - para mostrar infraestructura)
        deploymentEnvironment "AWS" {
            deploymentNode "CloudFront CDN" "" "AWS CloudFront" {
                containerInstance webApp
            }
            
            deploymentNode "Application Load Balancer" "" "AWS ALB" {
                infrastructureNode alb "ALB" "" "Load Balancer"
            }
            
            deploymentNode "ECS Cluster - Backend Services" "" "AWS ECS Fargate" {
                deploymentNode "Auth Service Tasks" "" "ECS Task (2 instances)" {
                    containerInstance authService
                }
                
                deploymentNode "Booking Service Tasks" "" "ECS Task (3 instances)" {
                    containerInstance bookingService
                }
                
                deploymentNode "Payment Service Tasks" "" "ECS Task (2 instances)" {
                    containerInstance paymentService
                }
                
                deploymentNode "Notification Service Tasks" "" "ECS Task (1 instance)" {
                    containerInstance notificationService
                }
                
                deploymentNode "Admin Service Tasks" "" "ECS Task (1 instance)" {
                    containerInstance adminService
                }
            }
            
            deploymentNode "RDS PostgreSQL" "" "AWS RDS" {
                deploymentNode "Primary DB" "" "PostgreSQL 14 Multi-AZ" {
                    containerInstance database
                }
            }
            
            deploymentNode "ElastiCache Redis" "" "AWS ElastiCache" {
                deploymentNode "Redis Cluster" "" "Redis 7 Cluster Mode" {
                    containerInstance cache
                }
            }
            
            deploymentNode "RabbitMQ on EC2" "" "EC2 t3.medium" {
                containerInstance messageQueue
            }
        }
    }

    views {
        # VISTA 1: C4 CONTEXT (Nivel 1)
        systemContext courtBooker "SystemContext" "Diagrama de contexto del sistema Court Booker" {
            include *
            autoLayout lr
        }
        
        # VISTA 2: C4 CONTAINER (Nivel 2)
        container courtBooker "Containers" "Diagrama de contenedores del sistema Court Booker" {
            include *
            autoLayout lr
        }
        
        # VISTA 3: C4 COMPONENT - Web App (Nivel 3)
        component webApp "ComponentsWebApp" "Componentes de la aplicación web" {
            include *
            autoLayout lr
        }
        
        # VISTA 4: C4 COMPONENT - Booking Service (Nivel 3)
        component bookingService "ComponentsBookingService" "Componentes del servicio de reservas" {
            include *
            autoLayout lr
        }
        
        # VISTA 5: C4 COMPONENT - Payment Service (Nivel 3)
        component paymentService "ComponentsPaymentService" "Componentes del servicio de pagos" {
            include *
            autoLayout lr
        }
        
        # VISTA 6: DEPLOYMENT (Infraestructura AWS)
        deployment courtBooker "AWS" "Deployment" "Despliegue en AWS" {
            include *
            autoLayout lr
        }
        
        # ESTILOS Y TEMAS
        styles {
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            
            element "External System" {
                background #999999
                color #ffffff
            }
            
            element "Service" {
                background #1168bd
                color #ffffff
            }
            
            element "Web Browser" {
                shape WebBrowser
                background #438dd5
                color #ffffff
            }
            
            element "Database" {
                shape Cylinder
                background #438dd5
                color #ffffff
            }
            
            element "Cache" {
                shape Cylinder
                background #ff6b6b
                color #ffffff
            }
            
            element "Message Queue" {
                shape Pipe
                background #f4a261
                color #000000
            }
            
            element "Infrastructure" {
                background #a9a9a9
                color #ffffff
            }
        }
        
        theme default
    }
}
