// ─── Intent Detection System ────────────────────────────────────────
// Replaces basic keyword matching with domain-based intent classification.

export type Intent =
    | "experience"
    | "projects"
    | "architecture"
    | "security"
    | "iam"
    | "skills"
    | "contact"
    | "impact"
    | "fallback";

export interface KnowledgeEntry {
    keywords: string[];
    answer: string;
    intent: Intent;
}

// ─── Intent Detection Patterns ──────────────────────────────────────
const INTENT_PATTERNS: Record<Intent, string[]> = {
    experience: ['experience', 'years', 'how long', 'background', 'career', 'about', 'who', 'introduce', 'profile', 'summary', 'resume', 'work history'],
    projects: ['project', 'portfolio', 'credit', 'erp', 'iam redesign', 'system', 'platform', 'application', 'built', 'developed'],
    architecture: ['architecture', 'design', 'pattern', 'hexagonal', 'clean', 'microservices', 'distributed', 'ddd', 'cqrs', 'event-driven'],
    security: ['security', 'oauth', 'oauth2', 'jwt', 'token', 'authentication', 'authorization', 'rbac', 'role', 'permission', 'access control'],
    iam: ['iam', 'identity', 'access management', 'rbac', 'permission', 'role-based', 'zero-trust'],
    skills: ['tech', 'stack', 'technology', 'tools', 'skills', 'database', 'docker', 'kubernetes', 'rabbitmq', 'spring', 'java', 'api', 'gateway', 'postgresql', 'devops'],
    contact: ['contact', 'reach', 'email', 'hire', 'available', 'visa', 'relocation', 'remote', 'location'],
    impact: ['impact', 'business', 'value', 'achievement', 'result', 'measurable'],
    fallback: [],
};

// ─── Knowledge Base ─────────────────────────────────────────────────
export const knowledgeBase: KnowledgeEntry[] = [
    // Experience & Background
    {
        keywords: ['experience', 'years', 'how long', 'background', 'career'],
        answer: 'I am a Senior Java Backend Developer with 8+ years of professional experience in enterprise software development. I specialize in building scalable, secure backend systems using Spring Boot, microservices architecture, and cloud-native technologies. My career has been focused on financial systems, ERP platforms, and identity/access management solutions.',
        intent: 'experience'
    },
    {
        keywords: ['about', 'who', 'introduce', 'yourself', 'profile', 'summary'],
        answer: 'I am a Senior Java Backend Developer specializing in enterprise-grade backend systems. My expertise spans Spring Boot, microservices, OAuth2/JWT security, and clean architecture patterns. I have deep experience in financial platforms, ERP systems, and IAM solutions. I bring strong architectural thinking, security-first design, and proven delivery on complex enterprise projects.',
        intent: 'experience'
    },
    // Architecture
    {
        keywords: ['architecture', 'design', 'pattern', 'hexagonal', 'clean'],
        answer: 'I follow Clean Architecture and Hexagonal Architecture (Ports & Adapters) principles. This ensures domain logic remains isolated from infrastructure concerns. The domain layer contains business rules with zero external dependencies. Application services orchestrate use cases through input/output ports. Infrastructure adapters handle persistence, messaging, and external integrations. This approach enables testability, flexibility, and maintainability at enterprise scale.',
        intent: 'architecture'
    },
    {
        keywords: ['microservices', 'distributed', 'service'],
        answer: 'I design microservices following domain-driven decomposition. Each service owns its data, has well-defined API contracts, and communicates via REST and asynchronous messaging (RabbitMQ). I implement API Gateway patterns for routing and security, use Docker containers for deployment, and Kubernetes for orchestration. Service discovery, circuit breakers, and distributed tracing are part of my standard stack.',
        intent: 'architecture'
    },
    // Security
    {
        keywords: ['security', 'oauth', 'oauth2', 'jwt', 'token', 'authentication', 'authorization'],
        answer: 'I implement OAuth2 Authorization Server with Spring Security, issuing JWT tokens with custom claims. The security architecture includes: Authorization Server for token issuance, Resource Servers validating JWTs, token refresh mechanisms, and scope-based access control. JWTs carry custom claims like roles, permissions, and organizational context for fine-grained authorization.',
        intent: 'security'
    },
    // IAM
    {
        keywords: ['rbac', 'role', 'permission', 'access control', 'iam', 'identity'],
        answer: 'I have designed and implemented enterprise RBAC systems with granular CRUD permissions per module. The model includes: Roles assigned to users, Permissions defining CRUD operations per resource, Menu-based authorization controlling UI visibility, JWT claims carrying permission sets, and endpoint-level @PreAuthorize checks. This ensures zero-trust security where every action is verified against the user\'s permission matrix.',
        intent: 'iam'
    },
    // Projects
    {
        keywords: ['credit', 'financial', 'loan', 'credit management'],
        answer: 'The Credit Management System is a comprehensive financial platform built with Spring Boot 3, featuring: OAuth2 Authorization Server with JWT, RBAC with granular per-menu permissions, PostgreSQL for data persistence, Dockerized microservices with API Gateway, complete credit lifecycle management (application, evaluation, approval, disbursement, payments, portfolio tracking), and secure financial validations at every step.',
        intent: 'projects'
    },
    {
        keywords: ['erp', 'parameterization', 'parameter', 'configuration'],
        answer: 'The ERP Parameterization Microservice manages system-wide configurations using: Flyway for versioned database migrations, JPA/Hibernate for persistence, RabbitMQ for event-driven communication with other services, multi-tenant architecture support, and Clean Architecture with clear domain/infrastructure separation. It serves as the central configuration backbone for the entire ERP ecosystem.',
        intent: 'projects'
    },
    {
        keywords: ['iam', 'redesign', 'access management'],
        answer: 'The IAM RBAC Redesign project involved restructuring the entire identity and access management system: Roles with hierarchical permissions, CRUD operations per module, menu-based authorization for UI control, JWT custom claims carrying the full permission set, React frontend with dynamic menu rendering based on permissions, and audit logging for all access events.',
        intent: 'projects'
    },
    {
        keywords: ['project', 'projects', 'portfolio', 'work'],
        answer: 'My key enterprise projects include:\n\n• **Credit Management System** — Complete financial platform with OAuth2, JWT, RBAC, and microservices architecture.\n• **ERP Parameterization Microservice** — Centralized configuration management with RabbitMQ integration and Clean Architecture.\n• **IAM RBAC Redesign** — Enterprise identity management with granular CRUD permissions and menu-based authorization.',
        intent: 'projects'
    },
    // Skills / Technology
    {
        keywords: ['tech', 'stack', 'technology', 'technologies', 'tools', 'skills'],
        answer: 'My core technology stack:\n\n**Backend**: Java 17+, Spring Boot 3, Spring Security, Spring Data JPA\n**Security**: OAuth2 Authorization Server, JWT, RBAC\n**Architecture**: Hexagonal/Clean Architecture, Microservices, DDD\n**Database**: PostgreSQL, MySQL, Oracle\n**Messaging**: RabbitMQ\n**DevOps**: Docker, Kubernetes\n**API**: REST, API Gateway\n**Frontend**: React/Next.js with TypeScript',
        intent: 'skills'
    },
    {
        keywords: ['database', 'postgresql', 'mysql', 'oracle', 'sql'],
        answer: 'I work with PostgreSQL (primary choice for new projects), MySQL, and Oracle databases. I implement Flyway for version-controlled migrations, optimize queries with proper indexing strategies, and design normalized schemas with referential integrity. For microservices, each service owns its database following the Database-per-Service pattern.',
        intent: 'skills'
    },
    {
        keywords: ['docker', 'kubernetes', 'container', 'devops', 'deployment', 'deploy'],
        answer: 'I containerize all services with Docker, using multi-stage builds for optimization. Docker Compose handles local development environments. For production, Kubernetes manages orchestration with proper health checks, resource limits, and horizontal pod autoscaling. CI/CD pipelines automate testing, building, and deployment workflows.',
        intent: 'skills'
    },
    {
        keywords: ['rabbitmq', 'messaging', 'queue', 'event', 'async'],
        answer: 'I implement asynchronous communication between microservices using RabbitMQ. This includes: event-driven architecture for decoupled services, reliable message delivery with acknowledgments, dead letter queues for error handling, and event sourcing patterns where applicable.',
        intent: 'skills'
    },
    {
        keywords: ['api', 'gateway', 'rest', 'endpoint'],
        answer: 'I design RESTful APIs following best practices: proper HTTP methods, status codes, pagination, and HATEOAS principles. API Gateway handles routing, rate limiting, and authentication token validation. All endpoints are documented with OpenAPI/Swagger and protected with appropriate authorization checks.',
        intent: 'skills'
    },
    {
        keywords: ['spring', 'spring boot', 'java', 'backend'],
        answer: 'Spring Boot 3 is my primary framework. I leverage the full Spring ecosystem: Spring Security for OAuth2/JWT, Spring Data JPA for persistence, Spring Cloud for microservices patterns, Spring AMQP for RabbitMQ integration, and Spring Actuator for observability. I follow convention-over-configuration principles while maintaining explicit security configurations.',
        intent: 'skills'
    },
    // Business Impact
    {
        keywords: ['impact', 'business', 'value', 'achievement', 'result'],
        answer: 'Key achievements:\n\n• Designed and delivered a complete **Credit Management System** processing financial operations with full audit trail\n• Built an **IAM system** securing 50+ endpoints with granular RBAC\n• Reduced system configuration time by **60%** through the ERP Parameterization Microservice\n• Established **architectural standards** adopted across multiple teams\n• Improved security posture through **zero-trust** access control implementation',
        intent: 'impact'
    },
    // Contact
    {
        keywords: ['contact', 'reach', 'email', 'hire', 'available'],
        answer: 'You can reach me through the Contact window in this portfolio. I have links to Email, LinkedIn, and GitHub available there. I am currently open to international opportunities and enterprise-level positions.',
        intent: 'contact'
    },
    {
        keywords: ['visa', 'relocation', 'international', 'remote', 'location'],
        answer: 'I am open to international opportunities and willing to relocate with visa sponsorship. I also have experience working in remote and distributed teams across different time zones. My portfolio is designed to demonstrate enterprise-level competence for international recruiters and visa processes.',
        intent: 'contact'
    },
];

// ─── Intent Detection ───────────────────────────────────────────────
export function detectIntent(query: string): Intent {
    const lowerQuery = query.toLowerCase().trim();
    const scores: Partial<Record<Intent, number>> = {};

    for (const [intent, patterns] of Object.entries(INTENT_PATTERNS)) {
        if (intent === 'fallback') continue;
        let score = 0;
        for (const pattern of patterns) {
            if (lowerQuery.includes(pattern)) {
                score += pattern.length;
            }
        }
        if (score > 0) {
            scores[intent as Intent] = score;
        }
    }

    const sorted = Object.entries(scores).sort((a, b) => (b[1] as number) - (a[1] as number));
    if (sorted.length > 0 && (sorted[0][1] as number) >= 3) {
        return sorted[0][0] as Intent;
    }

    return 'fallback';
}

// ─── Answer Retrieval ───────────────────────────────────────────────
export function findAnswer(query: string): { answer: string; intent: Intent } {
    const lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.length < 2) {
        return {
            answer: 'Please ask a more specific question about my experience, projects, architecture, or technologies.',
            intent: 'fallback',
        };
    }

    const intent = detectIntent(lowerQuery);

    // Security: restrict off-domain queries
    if (intent === 'fallback') {
        return {
            answer: '🔒 This portfolio assistant is restricted to professional information. Feel free to ask about my experience, projects, architecture decisions, technologies, security design, or business impact.',
            intent: 'fallback',
        };
    }

    // Find best matching entry within the detected intent
    let bestMatch: KnowledgeEntry | null = null;
    let bestScore = 0;

    for (const entry of knowledgeBase) {
        // Prioritize entries matching the detected intent
        if (entry.intent !== intent) continue;
        let score = 0;
        for (const keyword of entry.keywords) {
            if (lowerQuery.includes(keyword.toLowerCase())) {
                score += keyword.length;
            }
        }
        if (score > bestScore) {
            bestScore = score;
            bestMatch = entry;
        }
    }

    // If no exact match in intent category, return first entry of that intent
    if (!bestMatch) {
        bestMatch = knowledgeBase.find(e => e.intent === intent) || null;
    }

    if (bestMatch) {
        return { answer: bestMatch.answer, intent };
    }

    return {
        answer: '🔒 This portfolio assistant is restricted to professional information. Feel free to ask about my experience, projects, architecture decisions, technologies, security design, or business impact.',
        intent: 'fallback',
    };
}
