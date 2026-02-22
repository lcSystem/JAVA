// ─── Intent Detection System ────────────────────────────────────────
// Replaces basic keyword matching with domain-based intent classification.

import { Locale } from './translations';

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
    answerEs: string;
    intent: Intent;
}

// ─── Intent Detection Patterns ──────────────────────────────────────
const INTENT_PATTERNS: Record<Intent, string[]> = {
    experience: ['experience', 'years', 'how long', 'background', 'career', 'about', 'who', 'introduce', 'profile', 'summary', 'resume', 'work history',
        'experiencia', 'años', 'cuánto tiempo', 'trayectoria', 'carrera', 'quién', 'presentar', 'perfil', 'resumen', 'historial'],
    projects: ['project', 'portfolio', 'credit', 'erp', 'iam redesign', 'system', 'platform', 'application', 'built', 'developed',
        'proyecto', 'portafolio', 'crédito', 'sistema', 'plataforma', 'aplicación', 'construido', 'desarrollado'],
    architecture: ['architecture', 'design', 'pattern', 'hexagonal', 'clean', 'microservices', 'distributed', 'ddd', 'cqrs', 'event-driven',
        'arquitectura', 'diseño', 'patrón', 'limpia', 'microservicios', 'distribuido'],
    security: ['security', 'oauth', 'oauth2', 'jwt', 'token', 'authentication', 'authorization', 'rbac', 'role', 'permission', 'access control',
        'seguridad', 'autenticación', 'autorización', 'rol', 'permiso', 'control de acceso'],
    iam: ['iam', 'identity', 'access management', 'rbac', 'permission', 'role-based', 'zero-trust',
        'identidad', 'gestión de acceso'],
    skills: ['tech', 'stack', 'technology', 'tools', 'skills', 'database', 'docker', 'kubernetes', 'rabbitmq', 'spring', 'java', 'api', 'gateway', 'postgresql', 'devops', 'node', 'mybatis', 'zk', 'php', 'codeigniter',
        'tecnología', 'herramientas', 'habilidades', 'base de datos'],
    contact: ['contact', 'reach', 'email', 'hire', 'available', 'visa', 'relocation', 'remote', 'location', 'country',
        'contacto', 'email', 'contratar', 'disponible', 'visa', 'reubicación', 'remoto', 'ubicación', 'país'],
    impact: ['impact', 'business', 'value', 'achievement', 'result', 'measurable',
        'impacto', 'negocio', 'valor', 'logro', 'resultado'],
    fallback: [],
};

// ─── Knowledge Base ─────────────────────────────────────────────────
export const knowledgeBase: KnowledgeEntry[] = [
    // Experience & Background
    {
        keywords: ['experience', 'years', 'how long', 'background', 'career', 'experiencia', 'años', 'trayectoria', 'carrera'],
        answer: 'I am a Java Backend Developer with 3+ years of experience in enterprise software development. I specialize in building high-availability, high-performance applications using Spring Boot, REST APIs, and SOAP services. My career includes work at Caseware Ingeniería (Java/Spring Boot/Oracle) and Sistemas AsapAseco (PHP/CodeIgniter/Server admin).',
        answerEs: 'Soy un Desarrollador Backend Java con más de 3 años de experiencia en desarrollo de software empresarial. Me especializo en construir aplicaciones de alta disponibilidad y rendimiento usando Spring Boot, APIs REST y servicios SOAP. Mi trayectoria incluye Caseware Ingeniería (Java/Spring Boot/Oracle) y Sistemas AsapAseco (PHP/CodeIgniter/Admin servidores).',
        intent: 'experience'
    },
    {
        keywords: ['about', 'who', 'introduce', 'yourself', 'profile', 'summary', 'quién', 'presentar', 'perfil', 'resumen'],
        answer: 'I am Luigis, a Java Backend Developer focused on designing scalable architectures and clean, maintainable code. I have experience in financial systems and mission-critical platforms. I work collaboratively in multidisciplinary teams, promoting continuous improvement and delivering value to the business.',
        answerEs: 'Soy Luigis, Desarrollador Backend Java enfocado en diseñar arquitecturas escalables y código limpio y mantenible. Tengo experiencia en sistemas financieros y plataformas de misión crítica. Trabajo de manera colaborativa promoviendo la mejora continua y entrega de valor al negocio.',
        intent: 'experience'
    },
    // Architecture
    {
        keywords: ['architecture', 'design', 'pattern', 'hexagonal', 'clean', 'arquitectura', 'diseño', 'patrón', 'limpia'],
        answer: 'I follow cleaner architecture principles like Hexagonal Architecture to ensure domain logic remains isolated and testable. My focus is on scalability and performance for enterprise systems.',
        answerEs: 'Sigo principios de arquitectura limpia como Arquitectura Hexagonal para asegurar que la lógica de dominio permanezca aislada y testeable. Mi enfoque es la escalabilidad y el rendimiento para sistemas empresariales.',
        intent: 'architecture'
    },
    // Security
    {
        keywords: ['security', 'oauth', 'oauth2', 'jwt', 'token', 'authentication', 'authorization', 'seguridad', 'autenticación', 'autorización'],
        answer: 'I implement security using Spring Security, OAuth2, and JWT. I have experience building Authorization Servers and Resource Servers with granular RBAC and zero-trust principles.',
        answerEs: 'Implemento seguridad usando Spring Security, OAuth2 y JWT. Tengo experiencia construyendo Servidores de Autorización y Resource Servers con RBAC granular y principios zero-trust.',
        intent: 'security'
    },
    // Projects
    {
        keywords: ['caseware', 'asapaseco', 'company', 'work', 'empresa', 'trabajo'],
        answer: 'I have experience at Caseware Ingeniería S.A.S. (until Aug 2025) developing enterprise solutions using Java, Spring Boot, and Oracle. Since Jan 2026, I have been focused on own projects and freelance software development.',
        answerEs: 'Tengo experiencia en Caseware Ingeniería S.A.S. (hasta Ago 2025) desarrollando soluciones empresariales usando Java, Spring Boot y Oracle. Desde Ene 2026, me he enfocado en proyectos propios y desarrollo freelance.',
        intent: 'experience'
    },
    {
        keywords: ['caseware', 'financial erp', 'erp financiero', 'higher education', 'educación superior'],
        answer: 'I have experience at Caseware Ingeniería S.A.S. developing a Financial ERP for higher education using Java, Spring Boot, and ZK Framework. This mission-critical platform focuses on process optimization and financial auditing.',
        answerEs: 'Tengo experiencia en Caseware Ingeniería S.A.S. desarrollando un ERP Financiero para educación superior usando Java, Spring Boot y ZK Framework. Esta plataforma de misión crítica se enfoca en la optimización de procesos y auditoría financiera.',
        intent: 'projects'
    },
    {
        keywords: ['custom software', 'softwares a la medida', 'bespoke', 'tailored', 'php', 'bootstrap'],
        answer: 'I specialize in developing custom software solutions ("softwares a la medida") tailored to business needs, using diverse technologies like PHP (CodeIgniter/Bootstrap) and Java (Spring Boot) to deliver high-availability systems.',
        answerEs: 'Me especializo en el desarrollo de soluciones de software a la medida según necesidades del negocio, usando diversas tecnologías como PHP (CodeIgniter/Bootstrap) y Java (Spring Boot) para entregar sistemas de alta disponibilidad.',
        intent: 'projects'
    },
    // Skills
    {
        keywords: ['tech', 'stack', 'technology', 'tools', 'skills', 'tecnología', 'herramientas', 'habilidades'],
        answer: 'My primary stack: Java, Spring Boot, Hexagonal Architecture, Microservices, Node.js, JPA/Hibernate, MyBatis, REST/SOAP, PostgreSQL, MySQL, Oracle, PL/SQL, React, Next.js, ZK, Git, Flyway, and Linux.',
        answerEs: 'Mi stack principal: Java, Spring Boot, Arquitectura Hexagonal, Microservicios, Node.js, JPA/Hibernate, MyBatis, REST/SOAP, PostgreSQL, MySQL, Oracle, PL/SQL, React, Next.js, ZK, Git, Flyway y Linux.',
        intent: 'skills'
    },
    // Contact
    {
        keywords: ['remote', 'onsite', 'reallocation', 'country', 'remoto', 'presencial', 'país'],
        answer: 'I am available for remote work or on-site positions within my country. I am not currently open to international relocation.',
        answerEs: 'Estoy disponible para trabajo remoto o presencial dentro de mi país. Actualmente no estoy abierto a reubicación internacional.',
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
export function findAnswer(query: string, locale: Locale = 'en'): { answer: string; intent: Intent } {
    const lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.length < 2) {
        return {
            answer: locale === 'es'
                ? 'Por favor haz una pregunta más específica sobre mi experiencia, proyectos, arquitectura o tecnologías.'
                : 'Please ask a more specific question about my experience, projects, architecture, or technologies.',
            intent: 'fallback',
        };
    }

    const intent = detectIntent(lowerQuery);

    // Security: restrict off-domain queries
    if (intent === 'fallback') {
        return {
            answer: locale === 'es'
                ? '🔒 Este asistente del portafolio está restringido a información profesional. Puedes preguntar sobre mi experiencia, proyectos, decisiones de arquitectura, tecnologías, seguridad o impacto de negocio.'
                : '🔒 This portfolio assistant is restricted to professional information. Feel free to ask about my experience, projects, architecture decisions, technologies, security, or business impact.',
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
        const answer = locale === 'es' ? bestMatch.answerEs : bestMatch.answer;
        return { answer, intent };
    }

    return {
        answer: locale === 'es'
            ? '🔒 Este asistente del portafolio está restringido a información profesional. Puedes preguntar sobre mi experiencia, proyectos, decisiones de arquitectura, tecnologías, seguridad o impacto de negocio.'
            : '🔒 This portfolio assistant is restricted to professional information. Feel free to ask about my experience, projects, architecture decisions, technologies, security, or business impact.',
        intent: 'fallback',
    };
}
