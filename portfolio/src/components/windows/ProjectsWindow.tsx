'use client';

import React, { useState } from 'react';

interface Project {
    title: string;
    description: string;
    stack: string[];
    highlights: string[];
    impact: string;
}

const projects: Project[] = [
    {
        title: 'Credit Management System',
        description: 'Comprehensive financial platform managing the complete credit lifecycle from application to portfolio tracking.',
        stack: ['Spring Boot 3', 'OAuth2', 'JWT', 'PostgreSQL', 'Docker', 'RabbitMQ'],
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
        stack: ['Spring Security', 'JWT', 'React', 'Next.js', 'PostgreSQL', 'Flyway'],
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
        stack: ['Spring Boot', 'JPA/Hibernate', 'RabbitMQ', 'Flyway', 'Clean Architecture'],
        highlights: [
            'Flyway versioned database migrations',
            'RabbitMQ event-driven communication',
            'Multi-tenant architecture support',
            'Clean Architecture with domain/infrastructure separation',
            'Central configuration backbone for ERP',
        ],
        impact: 'Reduced system configuration time by 60%',
    },
];

export default function ProjectsWindow() {
    const [selected, setSelected] = useState(0);
    const project = projects[selected];

    return (
        <div style={{ display: 'flex', height: '100%' }}>
            {/* Sidebar */}
            <div style={{
                width: 200,
                minWidth: 200,
                borderRight: '1px solid var(--win-border)',
                background: 'rgba(0,0,0,0.15)',
                padding: '12px 0',
                overflow: 'auto',
            }}>
                <div style={{ padding: '0 16px 8px', fontSize: 11, color: 'var(--win-text-secondary)', textTransform: 'uppercase', letterSpacing: 0.5 }}>
                    Projects
                </div>
                {projects.map((p, i) => (
                    <button
                        key={i}
                        onClick={() => setSelected(i)}
                        style={{
                            display: 'block',
                            width: '100%',
                            padding: '10px 16px',
                            background: selected === i ? 'rgba(0,120,212,0.15)' : 'transparent',
                            border: 'none',
                            borderLeft: selected === i ? '3px solid var(--win-accent)' : '3px solid transparent',
                            color: selected === i ? 'var(--win-text)' : 'var(--win-text-secondary)',
                            cursor: 'pointer',
                            fontSize: 12,
                            textAlign: 'left',
                            transition: 'all 0.15s',
                        }}
                        onMouseEnter={e => { if (selected !== i) e.currentTarget.style.background = 'rgba(255,255,255,0.04)'; }}
                        onMouseLeave={e => { if (selected !== i) e.currentTarget.style.background = 'transparent'; }}
                    >
                        {p.title}
                    </button>
                ))}
            </div>

            {/* Detail */}
            <div style={{ flex: 1, padding: 24, overflow: 'auto' }}>
                <div className="section-heading">{project.title}</div>
                <p style={{ fontSize: 13, color: 'var(--win-text-secondary)', lineHeight: 1.6, marginBottom: 16 }}>
                    {project.description}
                </p>

                {/* Tech stack */}
                <div style={{ marginBottom: 20 }}>
                    <div style={{ fontSize: 12, fontWeight: 600, color: 'var(--win-accent)', marginBottom: 8, textTransform: 'uppercase', letterSpacing: 0.5 }}>
                        Tech Stack
                    </div>
                    <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
                        {project.stack.map(s => (
                            <span key={s} className="skill-badge">{s}</span>
                        ))}
                    </div>
                </div>

                {/* Key highlights */}
                <div style={{ marginBottom: 20 }}>
                    <div style={{ fontSize: 12, fontWeight: 600, color: 'var(--win-accent)', marginBottom: 8, textTransform: 'uppercase', letterSpacing: 0.5 }}>
                        Key Features
                    </div>
                    <ul style={{ padding: '0 0 0 16px', margin: 0 }}>
                        {project.highlights.map((h, i) => (
                            <li key={i} style={{ fontSize: 12, color: 'var(--win-text-secondary)', lineHeight: 1.8 }}>
                                {h}
                            </li>
                        ))}
                    </ul>
                </div>

                {/* Impact */}
                <div style={{
                    padding: '14px 18px',
                    background: 'linear-gradient(135deg, rgba(0,120,212,0.1) 0%, rgba(139,92,246,0.08) 100%)',
                    border: '1px solid rgba(0,120,212,0.2)',
                    borderRadius: 8,
                }}>
                    <div style={{ fontSize: 11, fontWeight: 600, color: 'var(--win-accent)', marginBottom: 4, textTransform: 'uppercase' }}>
                        📊 Business Impact
                    </div>
                    <div style={{ fontSize: 13, color: 'var(--win-text)', fontWeight: 500 }}>
                        {project.impact}
                    </div>
                </div>
            </div>
        </div>
    );
}
