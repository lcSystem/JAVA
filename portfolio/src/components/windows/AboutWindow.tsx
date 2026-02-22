'use client';

import React from 'react';

export default function AboutWindow() {
    const skills = [
        { category: 'Backend', items: ['Java 17+', 'Spring Boot 3', 'Spring Security', 'Spring Data JPA', 'Hibernate'] },
        { category: 'Architecture', items: ['Hexagonal / Clean', 'Microservices', 'DDD', 'CQRS', 'Event-Driven'] },
        { category: 'Security', items: ['OAuth2', 'JWT', 'RBAC', 'Zero-Trust', 'Spring Security'] },
        { category: 'Database', items: ['PostgreSQL', 'MySQL', 'Oracle', 'Flyway', 'Redis'] },
        { category: 'DevOps', items: ['Docker', 'Kubernetes', 'CI/CD', 'GitHub Actions'] },
        { category: 'Messaging', items: ['RabbitMQ', 'Event Sourcing', 'Async Patterns'] },
    ];

    return (
        <div style={{ padding: 24, height: '100%', overflow: 'auto' }}>
            <div className="section-heading">About Me</div>

            {/* Profile section */}
            <div style={{
                display: 'flex',
                gap: 20,
                marginBottom: 24,
                alignItems: 'flex-start',
            }}>
                <div style={{
                    width: 80,
                    height: 80,
                    borderRadius: '50%',
                    background: 'linear-gradient(135deg, var(--win-accent) 0%, #6366f1 100%)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    fontSize: 36,
                    flexShrink: 0,
                }}>
                    👤
                </div>
                <div>
                    <h2 style={{ fontSize: 20, fontWeight: 700, marginBottom: 4, color: 'var(--win-text)' }}>
                        Luis — Senior Java Backend Developer
                    </h2>
                    <p style={{ fontSize: 13, color: 'var(--win-text-secondary)', lineHeight: 1.6, marginBottom: 12 }}>
                        8+ years of professional experience building enterprise-grade backend systems.
                        Specialist in Spring Boot microservices, OAuth2/JWT security architecture,
                        and clean architecture patterns. Deep expertise in financial platforms,
                        ERP systems, and IAM solutions.
                    </p>
                    <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                        <span className="skill-badge" style={{ background: 'rgba(0,120,212,0.15)', color: '#60a5fa' }}>🏢 Enterprise Systems</span>
                        <span className="skill-badge" style={{ background: 'rgba(139,92,246,0.15)', color: '#a78bfa' }}>🔒 Security Expert</span>
                        <span className="skill-badge" style={{ background: 'rgba(16,185,129,0.15)', color: '#34d399' }}>🌍 Open to Relocation</span>
                    </div>
                </div>
            </div>

            {/* Skills grid */}
            <div className="section-heading" style={{ marginTop: 20 }}>Technical Skills</div>
            <div style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fill, minmax(240px, 1fr))',
                gap: 12,
            }}>
                {skills.map(group => (
                    <div key={group.category} style={{
                        background: 'rgba(255,255,255,0.02)',
                        border: '1px solid var(--win-border)',
                        borderRadius: 8,
                        padding: 14,
                    }}>
                        <div style={{
                            fontSize: 12,
                            fontWeight: 600,
                            color: 'var(--win-accent)',
                            marginBottom: 8,
                            textTransform: 'uppercase',
                            letterSpacing: 0.5,
                        }}>
                            {group.category}
                        </div>
                        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
                            {group.items.map(item => (
                                <span key={item} className="skill-badge">{item}</span>
                            ))}
                        </div>
                    </div>
                ))}
            </div>

            {/* Experience timeline */}
            <div className="section-heading" style={{ marginTop: 24 }}>Career Highlights</div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                {[
                    { year: '2024–Present', role: 'Lead Backend Architect', desc: 'Designing and building enterprise ERP platform with microservices, IAM, and credit management systems.' },
                    { year: '2021–2024', role: 'Senior Java Developer', desc: 'Led development of financial platforms with OAuth2/JWT security, RBAC, and distributed systems.' },
                    { year: '2018–2021', role: 'Java Developer', desc: 'Built core backend services for enterprise applications using Spring Boot and PostgreSQL.' },
                ].map(item => (
                    <div key={item.year} style={{
                        display: 'flex',
                        gap: 16,
                        padding: '12px 16px',
                        background: 'rgba(255,255,255,0.02)',
                        borderRadius: 6,
                        borderLeft: '3px solid var(--win-accent)',
                    }}>
                        <div style={{ fontSize: 11, color: 'var(--win-accent)', fontWeight: 600, minWidth: 90, flexShrink: 0 }}>
                            {item.year}
                        </div>
                        <div>
                            <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--win-text)', marginBottom: 2 }}>{item.role}</div>
                            <div style={{ fontSize: 12, color: 'var(--win-text-secondary)', lineHeight: 1.5 }}>{item.desc}</div>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
}
