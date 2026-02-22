// ─── i18n Translation System ────────────────────────────────────────
export type Locale = 'en' | 'es';

export type TranslationKeys = typeof translations['en'];

export const translations = {
    en: {
        // ─── Language Selector ───────────────────────────────────────
        langSelector: {
            title: 'Welcome to my Portfolio',
            subtitle: 'Please select your preferred language',
            en: 'English',
            es: 'Español',
        },

        // ─── Window Titles ──────────────────────────────────────────
        windowTitles: {
            about: 'About Me',
            projects: 'Projects',
            architecture: 'Architecture',
            resume: 'Resume',
            contact: 'Contact',
            terminal: 'Terminal',
            assistant: 'DevAssistant AI',
            recruiter: 'Executive Summary',
        },

        // ─── Start Menu ─────────────────────────────────────────────
        startMenu: {
            header: 'Luigis — Portfolio',
            subtitle: 'Java Backend Developer',
            executiveSummary: '📊 Executive Summary Mode',
            footer: '⚡ Powered by Next.js & TypeScript',
        },

        // ─── About Window ───────────────────────────────────────────
        about: {
            sectionTitle: 'About Me',
            name: 'Luigis — Java Backend Developer',
            bio: 'Java Backend Developer with 3+ years of experience building high-availability, high-performance enterprise applications. Specialized in Spring Boot, REST API and SOAP service development, with experience in financial systems and mission-critical platforms.\n\nI have participated in building, maintaining, and optimizing robust solutions, integrating databases like PostgreSQL and Oracle. I focus on designing scalable architectures, clean and maintainable code, applying best practices and quality standards oriented to results.\n\nI work collaboratively in multidisciplinary teams, promoting continuous improvement, effective communication, and delivering value to the business.',
            badge1: '🏢 Enterprise Systems',
            badge2: '🔒 Security',
            badge3: '💻 Remote / On-site',
            skillsTitle: 'Technical Skills',
            careerTitle: 'Career Highlights',
            career: [
                { year: 'Jan 2026–Present', role: 'Java Backend Developer — Own Projects', desc: 'Enterprise projects and custom software development. Financial ERP for higher education, microservices with Spring Boot, OAuth2/JWT, RBAC, and credit management systems.' },
                { year: '2020–Aug 2025', role: 'Java Developer — Caseware Ingeniería S.A.S.', desc: 'Development of enterprise solutions using Java, Spring Boot, ZK Framework, and Oracle. Participation in the design, implementation, and maintenance of systems oriented to improving internal processes.' },
                { year: '2018–2020', role: 'PHP Developer — Sistemas AsapAseco', desc: 'Development of applications in PHP, Bootstrap, and the CodeIgniter framework. Responsible for server administration and application performance optimization.' },
            ],
        },

        // ─── Projects Window ────────────────────────────────────────
        projects: {
            sidebar: 'Projects',
            techStack: 'Tech Stack',
            keyFeatures: 'Key Features',
            businessImpact: '📊 Business Impact',
            items: [
                {
                    title: 'Credit Management System',
                    description: 'Comprehensive financial platform managing the complete credit lifecycle from application to portfolio tracking.',
                    highlights: [
                        'OAuth2 Authorization Server with custom JWT claims',
                        'RBAC with granular per-menu permissions',
                        'Complete credit lifecycle (apply → evaluate → approve → disburse → pay)',
                        'Dockerized microservices with API Gateway',
                        'Secure financial validations at every step',
                    ],
                    impact: 'Processes financial operations with full audit trail and zero-trust security',
                },
                {
                    title: 'IAM RBAC Redesign',
                    description: 'Enterprise identity and access management system with hierarchical role-based access control.',
                    highlights: [
                        'Hierarchical roles with CRUD permissions per module',
                        'Menu-based authorization controlling UI visibility',
                        'JWT custom claims carrying full permission set',
                        'Dynamic React frontend with permission-based rendering',
                        'Audit logging for all access events',
                    ],
                    impact: 'Securing 50+ endpoints with granular RBAC and zero-trust architecture',
                },
                {
                    title: 'ERP Parameterization Microservice',
                    description: 'Centralized configuration management backbone for the entire ERP ecosystem.',
                    highlights: [
                        'Flyway versioned database migrations',
                        'RabbitMQ event-driven communication',
                        'Multi-tenant architecture support',
                        'Clean Architecture with domain/infrastructure separation',
                        'Central configuration backbone for ERP',
                    ],
                    impact: 'Reduced system configuration time by 60%',
                },
                {
                    title: 'Financial ERP for Higher Education (Caseware)',
                    description: 'Enterprise solution focused on improving internal processes and financial management for educational institutions.',
                    highlights: [
                        'Built with Java, Spring Boot, and ZK Framework',
                        'Oracle and PostgreSQL database integration',
                        'Design and implementation of process optimization systems',
                        'Deployment of mission-critical institutional platforms',
                        'Application of clean code and quality standards',
                    ],
                    impact: 'Optimized internal workflows and financial auditing for higher education entities',
                },
                {
                    title: 'Custom Software Solutions',
                    description: 'Development of specialized enterprise applications tailored to specific business high-availability needs.',
                    highlights: [
                        'Agile development of bespoke enterprise software',
                        'Technologies: PHP, Bootstrap, CodeIgniter, Spring Boot',
                        'High-performance REST and SOAP services',
                        'Integration with various database engines (Oracle, PostgreSQL)',
                        'Focus on design of scalable and maintainable solutions',
                    ],
                    impact: 'Delivered tailored solutions for diverse business challenges focusing on value and results',
                },
            ],
        },

        // ─── Architecture Window ────────────────────────────────────
        architecture: {
            tabs: {
                overview: '🏗️ System Overview',
                jwt: '🔐 JWT Flow',
                authorization: '🛡️ Authorization',
            },
            overviewTitle: 'Microservices Architecture',
            overviewLegend: 'Each service follows Hexagonal Architecture (Ports & Adapters) with independent databases (Database-per-Service pattern)',
            labels: {
                client: 'Client (SPA)',
                apiGateway: 'API Gateway',
                authServer: 'Auth Server',
                iamService: 'IAM Service',
                creditsService: 'Credits Service',
                paramsService: 'Params Service',
                reportsService: 'Reports Service',
            },
            jwtTitle: 'JWT Authentication Flow',
            jwtSteps: [
                { label: 'Client Authentication', description: 'User submits credentials (username/password) to the OAuth2 Authorization Server.' },
                { label: 'Credential Validation', description: 'Authorization Server validates credentials against the IAM database using BCrypt password hashing.' },
                { label: 'JWT Generation', description: 'Server generates JWT with custom claims: user ID, roles (ADMIN, USER), permissions (CRUD per module), and organizational context.' },
                { label: 'Token Delivery', description: 'JWT access token + refresh token returned to client. Access token has short TTL, refresh token has longer TTL.' },
                { label: 'API Request', description: 'Client includes JWT in Authorization header (Bearer token) for every API request through the API Gateway.' },
                { label: 'Token Validation', description: 'Resource Server validates JWT signature, expiration, and extracts claims for authorization decisions.' },
                { label: 'Authorization Check', description: '@PreAuthorize annotations check extracted roles/permissions against endpoint requirements. Zero-trust: every request is verified.' },
            ],
            authTitle: 'Authorization Decision Flow',
            authNodes: {
                incoming: '📥 Incoming API Request',
                validJwt: 'Valid JWT?',
                tokenExpired: 'Token Expired?',
                hasRole: 'Has Required Role?',
                hasPerm: 'Has CRUD Permission?',
                continue: 'Continue',
                unauthorized: '401 Unauthorized',
                refreshFlow: 'Refresh Flow',
                forbidden: '403 Forbidden',
                grantAccess: 'Grant Access',
                execute: '✅ Execute Business Logic + Audit Log',
            },
            zeroTrustTitle: 'Zero-Trust Model:',
            zeroTrustDesc: 'Every single API request goes through this decision chain. No action is implicitly trusted. RBAC permissions are evaluated per-resource with CRUD granularity. All decisions are audit-logged for compliance.',
        },

        // ─── Resume Window ──────────────────────────────────────────
        resume: {
            title: 'Professional Resume',
            name: 'Luigis',
            role: 'Java Backend Developer',
            summary: '3+ years building high-availability enterprise applications with Spring Boot, REST APIs, SOAP services, and financial systems. Focused on scalable architectures, clean code, and quality standards. Experience with PostgreSQL, Oracle, Docker, and mission-critical platforms.',
            competenciesTitle: 'Core Competencies',
            experienceTitle: 'Professional Experience',
            experiences: [
                {
                    period: 'Jan 2026 — Present',
                    title: 'Java Backend Developer — Own Projects',
                    items: [
                        'Enterprise projects and custom software development',
                        'Financial ERP for higher education with Spring Boot and microservices',
                        'OAuth2 Authorization Server with custom JWT claims',
                        'RBAC system securing 50+ endpoints with granular permissions',
                    ],
                },
                {
                    period: '2020 — Aug 2025',
                    title: 'Java Developer — Caseware Ingeniería S.A.S.',
                    items: [
                        'Development of enterprise solutions using Java, Spring Boot, ZK Framework, and Oracle',
                        'Design, implementation, and maintenance of systems for internal process improvement',
                        'Database integrations with Oracle and PostgreSQL',
                        'Application of best practices and quality standards',
                    ],
                },
                {
                    period: '2018 — 2020',
                    title: 'PHP Developer — Sistemas AsapAseco',
                    items: [
                        'Development of applications in PHP with Bootstrap and CodeIgniter framework',
                        'Server administration and application performance optimization',
                        'Frontend development and backend integration',
                    ],
                },
            ],
            downloadBtn: '📥 Download Resume (PDF)',
        },

        // ─── Contact Window ─────────────────────────────────────────
        contact: {
            title: 'Get in Touch',
            methods: [
                { icon: '📧', label: 'Email', value: 'Available on request' },
                { icon: '💼', label: 'LinkedIn', value: 'Connect with me' },
                { icon: '🐙', label: 'GitHub', value: 'View my repos' },
                { icon: '🌍', label: 'Location', value: 'Remote / On-site' },
            ],
            formTitle: 'Send a Message',
            namePlaceholder: 'Your Name',
            emailPlaceholder: 'Your Email',
            messagePlaceholder: 'Your Message',
            sendBtn: '📤 Send Message',
            sentBtn: '✅ Message Sent!',
        },

        // ─── Terminal Window ────────────────────────────────────────
        terminal: {
            welcome: 'Welcome to Portfolio Terminal v1.0',
            helpHint: 'Type "help" for available commands.\n',
            notFound: (cmd: string) => `Command not found: ${cmd}. Type "help" for available commands.`,
            commands: {
                help: `Available commands:
  help        - Show this help message
  about       - About the developer
  skills      - List technical skills
  projects    - List projects
  experience  - Show experience summary
  architecture - Architecture overview
  security    - Security approach
  clear       - Clear terminal
  neofetch    - System information`,
                about: `Luigis — Java Backend Developer
3+ years of enterprise software development
Specializing in Spring Boot, REST/SOAP APIs, Microservices, Hexagonal Architecture`,
                skills: `[Backend]      Java · Spring Boot · Spring Security · JPA/Hibernate · MyBatis · Node.js
[Architecture] Hexagonal · Microservices · REST/SOAP · Docker · Kubernetes
[Database]     PostgreSQL · MySQL · Oracle · PL/SQL · Flyway
[Frontend]     React · Next.js · ZK Framework
[DevOps]       Docker · Kubernetes · Git · Linux · CI/CD
[Security]     OAuth2 · JWT · RBAC · Spring Security`,
                projects: `1. Credit Management System  — Full financial lifecycle platform
2. IAM RBAC Redesign         — Enterprise access management
3. ERP Parameterization      — Centralized configuration service`,
                experience: `Jan 2026-Present  Java Backend Developer — Own Projects
2020-Aug 2025     Java Developer — Caseware Ingeniería S.A.S.
2018-2020     PHP Developer — Sistemas AsapAseco`,
                architecture: `┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  API Gateway │────▶│  Auth Server  │────▶│  Resource    │
│  (Routing)   │     │  (OAuth2/JWT) │     │  Servers     │
└─────────────┘     └──────────────┘     └─────────────┘
       │                                         │
       ▼                                         ▼
┌─────────────┐                          ┌─────────────┐
│  RabbitMQ   │◀─────────────────────────│  PostgreSQL  │
│  (Events)   │                          │  (Data)      │
└─────────────┘                          └─────────────┘`,
                security: `OAuth2 Authorization Server + JWT:
• Token issuance with custom claims (roles, permissions, org context)
• Resource Server JWT validation
• Scope-based access control
• RBAC with per-endpoint @PreAuthorize checks
• Zero-trust: every action verified against permission matrix`,
                neofetch: `       ╱╲         luigis@portfolio
       ╱  ╲        ─────────────
      ╱    ╲       OS: Interactive Desktop Simulation
     ╱  ▲   ╲      Stack: Java / Spring Boot
    ╱  ╱ ╲   ╲    Arch: Hexagonal / Microservices
   ╱  ╱   ╲   ╲   Security: OAuth2 / JWT / RBAC
  ╱  ╱     ╲   ╲  DB: PostgreSQL / MySQL / Oracle
 ╱──╱───────╲──╲  DevOps: Docker / K8s / Git
                   Shell: portfolio-shell v1.0`,
            },
        },

        // ─── Assistant Window ───────────────────────────────────────
        assistant: {
            greeting: '👋 Hello! I\'m the DevAssistant AI, a domain-restricted professional assistant.\n\nI can answer questions about:\n• 🏢 Experience & Background\n• 📂 Projects & Portfolio\n• 🏗️ Architecture & Design Patterns\n• 🔒 Security & IAM\n• 🔧 Technology Stack\n• 📊 Business Impact\n\nAsk me anything in these domains!',
            suggestedQuestions: [
                'What is your experience?',
                'Tell me about your projects',
                'How do you approach security?',
                'What is your tech stack?',
                'Describe your architecture patterns',
                'What business impact have you had?',
            ],
            placeholder: 'Ask about experience, projects, architecture...',
            footer: '🔒 Domain-restricted assistant · 100% deterministic · No external API',
        },

        // ─── Recruiter Window ───────────────────────────────────────
        recruiter: {
            badge: '📊 Executive Summary Mode',
            name: 'Luigis — Java Backend Developer',
            subtitle: '3+ years building high-availability enterprise applications with expertise in Spring Boot, financial systems, and mission-critical platforms.',
            stats: [
                { label: 'Years', value: '3+' },
                { label: 'Stack', value: 'Java/Spring' },
                { label: 'Focus', value: 'Enterprise' },
                { label: 'Status', value: 'Available' },
            ],
            highlightsTitle: 'Key Highlights',
            highlights: [
                {
                    icon: '🏗️',
                    title: 'Enterprise Architecture',
                    description: 'Designed and implemented microservices architectures using Hexagonal Architecture, Spring Boot, and event-driven patterns for scalable enterprise systems.',
                    metric: '3+ production systems',
                },
                {
                    icon: '🔒',
                    title: 'Security',
                    description: 'Built OAuth2 Authorization Server with JWT, RBAC with granular per-endpoint permissions, and zero-trust access control securing 50+ endpoints.',
                    metric: '50+ secured endpoints',
                },
                {
                    icon: '💰',
                    title: 'Financial Systems',
                    description: 'Delivered a complete Credit Management System handling the entire lifecycle from application to portfolio tracking with full audit trail.',
                    metric: 'End-to-end financial platform',
                },
                {
                    icon: '⚡',
                    title: 'Operational Impact',
                    description: 'Reduced system configuration time by 60% through centralized parameterization. Designed robust enterprise solutions with high-availability requirements.',
                    metric: '60% time reduction',
                },
                {
                    icon: '💻',
                    title: 'Availability',
                    description: 'Available for remote work or on-site positions. Experience working collaboratively in multidisciplinary teams, promoting continuous improvement and effective communication.',
                    metric: '3+ years experience',
                },
            ],
            techTitle: 'Primary Technology Stack',
        },

        // ─── Knowledge Base (Assistant Answers) ─────────────────────
        knowledgeBase: {
            fallbackShort: 'Please ask a more specific question about my experience, projects, architecture, or technologies.',
            fallbackRestricted: '🔒 This portfolio assistant is restricted to professional information. Feel free to ask about my experience, projects, architecture decisions, technologies, security design, or business impact.',
        },
    },

    es: {
        // ─── Language Selector ───────────────────────────────────────
        langSelector: {
            title: 'Bienvenido a mi Portafolio',
            subtitle: 'Por favor selecciona tu idioma preferido',
            en: 'English',
            es: 'Español',
        },

        // ─── Window Titles ──────────────────────────────────────────
        windowTitles: {
            about: 'Sobre Mí',
            projects: 'Proyectos',
            architecture: 'Arquitectura',
            resume: 'Currículum',
            contact: 'Contacto',
            terminal: 'Terminal',
            assistant: 'Asistente IA',
            recruiter: 'Resumen Ejecutivo',
        },

        // ─── Start Menu ─────────────────────────────────────────────
        startMenu: {
            header: 'Luigis — Portafolio',
            subtitle: 'Desarrollador Backend Java',
            executiveSummary: '📊 Modo Resumen Ejecutivo',
            footer: '⚡ Desarrollado con Next.js & TypeScript',
        },

        // ─── About Window ───────────────────────────────────────────
        about: {
            sectionTitle: 'Sobre Mí',
            name: 'Luigis — Desarrollador Backend Java',
            bio: 'Desarrollador Backend Java con más de 3 años de experiencia en el desarrollo de aplicaciones empresariales de alta disponibilidad y rendimiento. Especializado en Spring Boot, construcción de APIs REST y servicios SOAP, con experiencia en sistemas financieros y plataformas de misión crítica.\n\nHe participado en la construcción, mantenimiento y optimización de soluciones robustas, integrando bases de datos como PostgreSQL y Oracle. Me enfoco en el diseño de arquitecturas escalables, código limpio y mantenible, aplicando buenas prácticas y estándares de calidad orientados a resultados.\n\nTrabajo de manera colaborativa en equipos multidisciplinarios, promoviendo la mejora continua, la comunicación efectiva y la entrega de valor al negocio.',
            badge1: '🏢 Sistemas Empresariales',
            badge2: '🔒 Seguridad',
            badge3: '💻 Remoto / Presencial',
            skillsTitle: 'Habilidades Técnicas',
            careerTitle: 'Trayectoria Profesional',
            career: [
                { year: 'Ene 2026–Presente', role: 'Desarrollador Backend Java — Proyectos Propios', desc: 'Proyectos empresariales y desarrollo de software a la medida. ERP financiero para educación superior, microservicios con Spring Boot, OAuth2/JWT, RBAC y sistemas de gestión de créditos.' },
                { year: '2020–Ago 2025', role: 'Desarrollador Java — Caseware Ingeniería S.A.S.', desc: 'Desarrollo de soluciones empresariales utilizando Java, Spring Boot, ZK Framework y Oracle. Participación en el diseño, implementación y mantenimiento de sistemas orientados a la mejora de procesos internos.' },
                { year: '2018–2020', role: 'Desarrollador PHP — Sistemas AsapAseco', desc: 'Desarrollo de aplicaciones en PHP, Bootstrap y el framework CodeIgniter. Responsable de la administración de servidores y la optimización del rendimiento de las aplicaciones.' },
            ],
        },

        // ─── Projects Window ────────────────────────────────────────
        projects: {
            sidebar: 'Proyectos',
            techStack: 'Stack Tecnológico',
            keyFeatures: 'Características Clave',
            businessImpact: '📊 Impacto de Negocio',
            items: [
                {
                    title: 'Sistema de Gestión de Créditos',
                    description: 'Plataforma financiera integral que gestiona el ciclo completo del crédito desde la solicitud hasta el seguimiento del portafolio.',
                    highlights: [
                        'Servidor de Autorización OAuth2 con claims JWT personalizados',
                        'RBAC con permisos granulares por menú',
                        'Ciclo completo de crédito (solicitar → evaluar → aprobar → desembolsar → pagar)',
                        'Microservicios en Docker con API Gateway',
                        'Validaciones financieras seguras en cada paso',
                    ],
                    impact: 'Procesa operaciones financieras con auditoría completa y seguridad zero-trust',
                },
                {
                    title: 'Rediseño IAM RBAC',
                    description: 'Sistema empresarial de gestión de identidad y acceso con control de acceso basado en roles jerárquicos.',
                    highlights: [
                        'Roles jerárquicos con permisos CRUD por módulo',
                        'Autorización basada en menú controlando la visibilidad de UI',
                        'Claims JWT personalizados con el conjunto completo de permisos',
                        'Frontend React dinámico con renderizado basado en permisos',
                        'Registro de auditoría para todos los eventos de acceso',
                    ],
                    impact: 'Asegurando 50+ endpoints con RBAC granular y arquitectura zero-trust',
                },
                {
                    title: 'Microservicio de Parametrización ERP',
                    description: 'Backbone de gestión de configuración centralizada para todo el ecosistema ERP.',
                    highlights: [
                        'Migraciones versionadas con Flyway',
                        'Comunicación event-driven con RabbitMQ',
                        'Soporte de arquitectura multi-tenant',
                        'Arquitectura Limpia con separación dominio/infraestructura',
                        'Backbone de configuración central para ERP',
                    ],
                    impact: 'Redujo el tiempo de configuración del sistema en un 60%',
                },
                {
                    title: 'ERP Financiero Educación Superior (Caseware)',
                    description: 'Solución empresarial orientada a la mejora de procesos internos y gestión financiera institucional.',
                    highlights: [
                        'Desarrollado con Java, Spring Boot y ZK Framework',
                        'Integración con bases de datos Oracle y PostgreSQL',
                        'Diseño e implementación de sistemas de mejora de procesos',
                        'Plataformas de misión crítica para educación superior',
                        'Aplicación de código limpio y estándares de calidad',
                    ],
                    impact: 'Optimización de flujos de trabajo internos y auditoría financiera institucional',
                },
                {
                    title: 'Softwares a la Medida',
                    description: 'Desarrollo de aplicaciones empresariales especializadas según necesidades específicas de alta disponibilidad.',
                    highlights: [
                        'Desarrollo ágil de software empresarial personalizado',
                        'Tecnologías: PHP, Bootstrap, CodeIgniter, Spring Boot',
                        'Servicios REST y SOAP de alto rendimiento',
                        'Integración con diversos motores (Oracle, PostgreSQL)',
                        'Enfoque en diseño de soluciones escalables y mantenibles',
                    ],
                    impact: 'Entrega de soluciones alineadas al negocio con foco en resultados y valor',
                },
            ],
        },

        // ─── Architecture Window ────────────────────────────────────
        architecture: {
            tabs: {
                overview: '🏗️ Vista General',
                jwt: '🔐 Flujo JWT',
                authorization: '🛡️ Autorización',
            },
            overviewTitle: 'Arquitectura de Microservicios',
            overviewLegend: 'Cada servicio sigue la Arquitectura Hexagonal (Puertos y Adaptadores) con bases de datos independientes (patrón Database-per-Service)',
            labels: {
                client: 'Cliente (SPA)',
                apiGateway: 'API Gateway',
                authServer: 'Servidor Auth',
                iamService: 'Servicio IAM',
                creditsService: 'Servicio Créditos',
                paramsService: 'Servicio Params',
                reportsService: 'Servicio Reportes',
            },
            jwtTitle: 'Flujo de Autenticación JWT',
            jwtSteps: [
                { label: 'Autenticación del Cliente', description: 'El usuario envía credenciales (usuario/contraseña) al Servidor de Autorización OAuth2.' },
                { label: 'Validación de Credenciales', description: 'El Servidor de Autorización valida las credenciales contra la base de datos IAM usando hash BCrypt.' },
                { label: 'Generación del JWT', description: 'El servidor genera un JWT con claims personalizados: ID de usuario, roles (ADMIN, USER), permisos (CRUD por módulo) y contexto organizacional.' },
                { label: 'Entrega del Token', description: 'Token de acceso JWT + token de refresco devueltos al cliente. Token de acceso con TTL corto, token de refresco con TTL largo.' },
                { label: 'Solicitud API', description: 'El cliente incluye el JWT en la cabecera Authorization (Bearer token) para cada solicitud API a través del API Gateway.' },
                { label: 'Validación del Token', description: 'El Resource Server valida la firma del JWT, expiración y extrae los claims para decisiones de autorización.' },
                { label: 'Verificación de Autorización', description: 'Anotaciones @PreAuthorize verifican roles/permisos extraídos contra los requisitos del endpoint. Zero-trust: cada solicitud es verificada.' },
            ],
            authTitle: 'Flujo de Decisión de Autorización',
            authNodes: {
                incoming: '📥 Solicitud API Entrante',
                validJwt: '¿JWT Válido?',
                tokenExpired: '¿Token Expirado?',
                hasRole: '¿Tiene Rol Requerido?',
                hasPerm: '¿Tiene Permiso CRUD?',
                continue: 'Continuar',
                unauthorized: '401 No Autorizado',
                refreshFlow: 'Flujo de Refresco',
                forbidden: '403 Prohibido',
                grantAccess: 'Acceso Concedido',
                execute: '✅ Ejecutar Lógica de Negocio + Log de Auditoría',
            },
            zeroTrustTitle: 'Modelo Zero-Trust:',
            zeroTrustDesc: 'Cada solicitud API pasa por esta cadena de decisiones. Ninguna acción es implícitamente confiable. Los permisos RBAC se evalúan por recurso con granularidad CRUD. Todas las decisiones se registran en auditoría para cumplimiento.',
        },

        // ─── Resume Window ──────────────────────────────────────────
        resume: {
            title: 'Currículum Profesional',
            name: 'Luigis',
            role: 'Desarrollador Backend Java',
            summary: '3+ años desarrollando aplicaciones empresariales de alta disponibilidad con Spring Boot, APIs REST, servicios SOAP y sistemas financieros. Enfocado en arquitecturas escalables, código limpio y estándares de calidad. Experiencia con PostgreSQL, Oracle, Docker y plataformas de misión crítica.',
            competenciesTitle: 'Competencias Principales',
            experienceTitle: 'Experiencia Profesional',
            experiences: [
                {
                    period: 'Ene 2026 — Presente',
                    title: 'Desarrollador Backend Java — Proyectos Propios',
                    items: [
                        'Proyectos empresariales y desarrollo de software a la medida',
                        'ERP financiero para educación superior con Spring Boot y microservicios',
                        'Servidor de Autorización OAuth2 con claims JWT personalizados',
                        'Sistema RBAC asegurando 50+ endpoints con permisos granulares',
                    ],
                },
                {
                    period: '2020 — Ago 2025',
                    title: 'Desarrollador Java — Caseware Ingeniería S.A.S.',
                    items: [
                        'Desarrollo de soluciones empresariales con Java, Spring Boot, ZK Framework y Oracle',
                        'Diseño, implementación y mantenimiento de sistemas para mejora de procesos internos',
                        'Integraciones con bases de datos Oracle y PostgreSQL',
                        'Aplicación de buenas prácticas y estándares de calidad',
                    ],
                },
                {
                    period: '2018 — 2020',
                    title: 'Desarrollador PHP — Sistemas AsapAseco',
                    items: [
                        'Desarrollo de aplicaciones en PHP con Bootstrap y framework CodeIgniter',
                        'Administración de servidores y optimización de rendimiento de aplicaciones',
                        'Desarrollo frontend e integración con backend',
                    ],
                },
            ],
            downloadBtn: '📥 Descargar Currículum (PDF)',
        },

        // ─── Contact Window ─────────────────────────────────────────
        contact: {
            title: 'Ponte en Contacto',
            methods: [
                { icon: '📧', label: 'Email', value: 'Disponible a solicitud' },
                { icon: '💼', label: 'LinkedIn', value: 'Conéctate conmigo' },
                { icon: '🐙', label: 'GitHub', value: 'Ver mis repositorios' },
                { icon: '🌍', label: 'Ubicación', value: 'Remoto / Presencial' },
            ],
            formTitle: 'Enviar un Mensaje',
            namePlaceholder: 'Tu Nombre',
            emailPlaceholder: 'Tu Email',
            messagePlaceholder: 'Tu Mensaje',
            sendBtn: '📤 Enviar Mensaje',
            sentBtn: '✅ ¡Mensaje Enviado!',
        },

        // ─── Terminal Window ────────────────────────────────────────
        terminal: {
            welcome: 'Bienvenido al Terminal del Portafolio v1.0',
            helpHint: 'Escribe "help" para ver los comandos disponibles.\n',
            notFound: (cmd: string) => `Comando no encontrado: ${cmd}. Escribe "help" para ver los comandos disponibles.`,
            commands: {
                help: `Comandos disponibles:
  help        - Mostrar este mensaje de ayuda
  about       - Sobre el desarrollador
  skills      - Listar habilidades técnicas
  projects    - Listar proyectos
  experience  - Mostrar resumen de experiencia
  architecture - Vista general de arquitectura
  security    - Enfoque de seguridad
  clear       - Limpiar terminal
  neofetch    - Información del sistema`,
                about: `Luigis — Desarrollador Backend Java
3+ años de desarrollo de software empresarial
Especializado en Spring Boot, APIs REST/SOAP, Microservicios, Arquitectura Hexagonal`,
                skills: `[Backend]      Java · Spring Boot · Spring Security · JPA/Hibernate · MyBatis · Node.js
[Arquitectura] Hexagonal · Microservicios · REST/SOAP · Docker · Kubernetes
[Base de Datos] PostgreSQL · MySQL · Oracle · PL/SQL · Flyway
[Frontend]     React · Next.js · ZK Framework
[DevOps]       Docker · Kubernetes · Git · Linux · CI/CD
[Seguridad]    OAuth2 · JWT · RBAC · Spring Security`,
                projects: `1. Sistema de Gestión de Créditos — Plataforma financiera completa
2. Rediseño IAM RBAC              — Gestión de acceso empresarial
3. Parametrización ERP            — Servicio de configuración centralizada`,
                experience: `Ene 2026-Presente  Desarrollador Backend Java — Proyectos Propios
2020-Ago 2025      Desarrollador Java — Caseware Ingeniería S.A.S.
2018-2020      Desarrollador PHP — Sistemas AsapAseco`,
                architecture: `┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  API Gateway │────▶│  Auth Server  │────▶│  Resource    │
│  (Enrutamiento)│   │  (OAuth2/JWT) │     │  Servers     │
└─────────────┘     └──────────────┘     └─────────────┘
       │                                         │
       ▼                                         ▼
┌─────────────┐                          ┌─────────────┐
│  RabbitMQ   │◀─────────────────────────│  PostgreSQL  │
│  (Eventos)  │                          │  (Datos)     │
└─────────────┘                          └─────────────┘`,
                security: `Servidor de Autorización OAuth2 + JWT:
• Emisión de tokens con claims personalizados (roles, permisos, contexto org)
• Validación de JWT en Resource Server
• Control de acceso basado en scopes
• RBAC con verificaciones @PreAuthorize por endpoint
• Zero-trust: cada acción verificada contra la matriz de permisos`,
                neofetch: `       ╱╲         luigis@portafolio
       ╱  ╲        ─────────────
      ╱    ╲       SO: Simulación de Escritorio Interactivo
     ╱  ▲   ╲      Stack: Java / Spring Boot
    ╱  ╱ ╲   ╲    Arq: Hexagonal / Microservicios
   ╱  ╱   ╲   ╲   Seguridad: OAuth2 / JWT / RBAC
  ╱  ╱     ╲   ╲  BD: PostgreSQL / MySQL / Oracle
 ╱──╱───────╲──╲  DevOps: Docker / K8s / Git
                   Shell: portfolio-shell v1.0`,
            },
        },

        // ─── Assistant Window ───────────────────────────────────────
        assistant: {
            greeting: '👋 ¡Hola! Soy el Asistente IA, un asistente profesional restringido al dominio.\n\nPuedo responder preguntas sobre:\n• 🏢 Experiencia y Trayectoria\n• 📂 Proyectos y Portafolio\n• 🏗️ Arquitectura y Patrones de Diseño\n• 🔒 Seguridad e IAM\n• 🔧 Stack Tecnológico\n• 📊 Impacto de Negocio\n\n¡Pregúntame lo que quieras en estos dominios!',
            suggestedQuestions: [
                '¿Cuál es tu experiencia?',
                'Cuéntame sobre tus proyectos',
                '¿Cómo abordas la seguridad?',
                '¿Cuál es tu stack tecnológico?',
                'Describe tus patrones de arquitectura',
                '¿Qué impacto de negocio has tenido?',
            ],
            placeholder: 'Pregunta sobre experiencia, proyectos, arquitectura...',
            footer: '🔒 Asistente restringido al dominio · 100% determinístico · Sin API externa',
        },

        // ─── Recruiter Window ───────────────────────────────────────
        recruiter: {
            badge: '📊 Modo Resumen Ejecutivo',
            name: 'Luigis — Desarrollador Backend Java',
            subtitle: '3+ años desarrollando aplicaciones empresariales de alta disponibilidad con experiencia en Spring Boot, sistemas financieros y plataformas de misión crítica.',
            stats: [
                { label: 'Años', value: '3+' },
                { label: 'Stack', value: 'Java/Spring' },
                { label: 'Enfoque', value: 'Empresarial' },
                { label: 'Estado', value: 'Disponible' },
            ],
            highlightsTitle: 'Puntos Destacados',
            highlights: [
                {
                    icon: '🏗️',
                    title: 'Arquitectura Empresarial',
                    description: 'Diseño e implementación de arquitecturas de microservicios usando Arquitectura Hexagonal, Spring Boot y patrones event-driven para sistemas empresariales escalables.',
                    metric: '3+ sistemas en producción',
                },
                {
                    icon: '🔒',
                    title: 'Seguridad',
                    description: 'Construcción de Servidor de Autorización OAuth2 con JWT, RBAC con permisos granulares por endpoint y control de acceso zero-trust asegurando 50+ endpoints.',
                    metric: '50+ endpoints asegurados',
                },
                {
                    icon: '💰',
                    title: 'Sistemas Financieros',
                    description: 'Entrega de un Sistema de Gestión de Créditos completo manejando todo el ciclo de vida desde la solicitud hasta el seguimiento del portafolio con auditoría completa.',
                    metric: 'Plataforma financiera completa',
                },
                {
                    icon: '⚡',
                    title: 'Impacto Operacional',
                    description: 'Reducción del tiempo de configuración del sistema en 60% mediante parametrización centralizada. Diseño de soluciones empresariales robustas con requisitos de alta disponibilidad.',
                    metric: '60% reducción de tiempo',
                },
                {
                    icon: '💻',
                    title: 'Disponibilidad',
                    description: 'Disponible para trabajo remoto o presencial. Experiencia trabajando de manera colaborativa en equipos multidisciplinarios, promoviendo la mejora continua y la comunicación efectiva.',
                    metric: '3+ años de experiencia',
                },
            ],
            techTitle: 'Stack Tecnológico Principal',
        },

        // ─── Knowledge Base (Assistant Answers) ─────────────────────
        knowledgeBase: {
            fallbackShort: 'Por favor haz una pregunta más específica sobre mi experiencia, proyectos, arquitectura o tecnologías.',
            fallbackRestricted: '🔒 Este asistente del portafolio está restringido a información profesional. Puedes preguntar sobre mi experiencia, proyectos, decisiones de arquitectura, tecnologías, diseño de seguridad o impacto de negocio.',
        },
    },
} as const;
