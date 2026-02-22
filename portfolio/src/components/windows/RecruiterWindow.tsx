'use client';

import React from 'react';

export default function RecruiterWindow() {
    const highlights = [
        {
            icon: '🏗️',
            title: 'Enterprise Architecture',
            description: 'Designed and implemented microservices architectures using Hexagonal/Clean Architecture, DDD, and event-driven patterns for scalable enterprise systems.',
            metric: '3+ production systems',
        },
        {
            icon: '🔒',
            title: 'Security Engineering',
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
            description: 'Reduced system configuration time by 60% through centralized parameterization. Established architectural standards adopted across multiple teams.',
            metric: '60% time reduction',
        },
        {
            icon: '🌍',
            title: 'International Readiness',
            description: 'Open to relocation with visa sponsorship. Experience working in distributed teams across time zones. Portfolio designed for enterprise-level demonstration.',
            metric: '8+ years experience',
        },
    ];

    return (
        <div style={{ height: '100%', overflow: 'auto' }}>
            {/* Header banner */}
            <div style={{
                padding: '28px 24px 20px',
                background: 'linear-gradient(135deg, rgba(0,120,212,0.2) 0%, rgba(139,92,246,0.15) 50%, rgba(16,185,129,0.1) 100%)',
                borderBottom: '1px solid rgba(0,120,212,0.2)',
                textAlign: 'center',
            }}>
                <div style={{
                    fontSize: 10,
                    fontWeight: 700,
                    color: 'var(--win-accent)',
                    textTransform: 'uppercase',
                    letterSpacing: 2,
                    marginBottom: 8,
                }}>
                    📊 Executive Summary Mode
                </div>
                <h1 style={{
                    fontSize: 22,
                    fontWeight: 700,
                    color: 'var(--win-text)',
                    marginBottom: 4,
                }}>
                    Luis — Senior Java Backend Developer
                </h1>
                <p style={{
                    fontSize: 13,
                    color: 'var(--win-text-secondary)',
                    maxWidth: 500,
                    margin: '0 auto',
                    lineHeight: 1.5,
                }}>
                    8+ years building enterprise-grade backend systems with proven expertise in
                    security architecture, microservices, and financial platforms.
                </p>
            </div>

            {/* Quick stats */}
            <div style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(4, 1fr)',
                gap: 1,
                background: 'var(--win-border)',
            }}>
                {[
                    { label: 'Years', value: '8+' },
                    { label: 'Stack', value: 'Java/Spring' },
                    { label: 'Focus', value: 'Enterprise' },
                    { label: 'Status', value: 'Available' },
                ].map(stat => (
                    <div key={stat.label} style={{
                        padding: '14px 8px',
                        background: 'var(--win-surface)',
                        textAlign: 'center',
                    }}>
                        <div style={{ fontSize: 18, fontWeight: 700, color: 'var(--win-accent)' }}>{stat.value}</div>
                        <div style={{ fontSize: 10, color: 'var(--win-text-secondary)', marginTop: 2, textTransform: 'uppercase', letterSpacing: 0.5 }}>{stat.label}</div>
                    </div>
                ))}
            </div>

            {/* Key highlights */}
            <div style={{ padding: '20px 24px' }}>
                <div style={{
                    fontSize: 12,
                    fontWeight: 600,
                    color: 'var(--win-text-secondary)',
                    textTransform: 'uppercase',
                    letterSpacing: 0.5,
                    marginBottom: 16,
                }}>
                    Key Highlights
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                    {highlights.map((h, i) => (
                        <div key={i} style={{
                            display: 'flex',
                            gap: 14,
                            padding: '14px 16px',
                            background: 'rgba(255,255,255,0.02)',
                            border: '1px solid var(--win-border)',
                            borderRadius: 8,
                            transition: 'all 0.2s',
                        }}>
                            <div style={{
                                fontSize: 24,
                                width: 40,
                                textAlign: 'center',
                                flexShrink: 0,
                                paddingTop: 2,
                            }}>
                                {h.icon}
                            </div>
                            <div style={{ flex: 1 }}>
                                <div style={{
                                    display: 'flex',
                                    justifyContent: 'space-between',
                                    alignItems: 'center',
                                    marginBottom: 4,
                                }}>
                                    <span style={{ fontSize: 13, fontWeight: 600, color: 'var(--win-text)' }}>
                                        {h.title}
                                    </span>
                                    <span style={{
                                        fontSize: 10,
                                        fontWeight: 600,
                                        color: 'var(--win-accent)',
                                        padding: '2px 10px',
                                        background: 'rgba(0,120,212,0.1)',
                                        borderRadius: 10,
                                    }}>
                                        {h.metric}
                                    </span>
                                </div>
                                <p style={{ fontSize: 12, color: 'var(--win-text-secondary)', lineHeight: 1.5, margin: 0 }}>
                                    {h.description}
                                </p>
                            </div>
                        </div>
                    ))}
                </div>
            </div>

            {/* Primary stack */}
            <div style={{
                padding: '0 24px 24px',
            }}>
                <div style={{
                    fontSize: 12,
                    fontWeight: 600,
                    color: 'var(--win-text-secondary)',
                    textTransform: 'uppercase',
                    letterSpacing: 0.5,
                    marginBottom: 12,
                }}>
                    Primary Technology Stack
                </div>
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
                    {[
                        'Java 17+', 'Spring Boot 3', 'OAuth2/JWT', 'PostgreSQL',
                        'Docker', 'Kubernetes', 'RabbitMQ', 'Clean Architecture',
                        'Microservices', 'DDD', 'REST API', 'React/Next.js'
                    ].map(tech => (
                        <span key={tech} className="skill-badge">{tech}</span>
                    ))}
                </div>
            </div>
        </div>
    );
}
