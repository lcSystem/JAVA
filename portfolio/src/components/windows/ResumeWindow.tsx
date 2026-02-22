'use client';

import React from 'react';
import { useLanguage } from '@/contexts/LanguageContext';

export default function ResumeWindow() {
    const { t } = useLanguage();
    const rt = t.resume;

    return (
        <div style={{ padding: 24, height: '100%', overflow: 'auto' }}>
            <div className="section-heading">{rt.title}</div>

            {/* Header */}
            <div style={{
                padding: '20px 24px',
                background: 'linear-gradient(135deg, rgba(0,120,212,0.12) 0%, rgba(139,92,246,0.08) 100%)',
                border: '1px solid rgba(0,120,212,0.2)',
                borderRadius: 8,
                marginBottom: 24,
            }}>
                <h2 style={{ fontSize: 20, fontWeight: 700, color: 'var(--win-text)', marginBottom: 4 }}>
                    {rt.name}
                </h2>
                <div style={{ fontSize: 14, color: 'var(--win-accent)', fontWeight: 500, marginBottom: 8 }}>
                    {rt.role}
                </div>
                <p style={{ fontSize: 12, color: 'var(--win-text-secondary)', lineHeight: 1.6 }}>
                    {rt.summary}
                </p>
            </div>

            {/* Core Competencies */}
            <div style={{ marginBottom: 24 }}>
                <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--win-accent)', marginBottom: 12, textTransform: 'uppercase', letterSpacing: 0.5 }}>
                    {rt.competenciesTitle}
                </div>
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
                    {[
                        'Java 17+ / Spring Boot 3',
                        'OAuth2 / JWT / Spring Security',
                        'Microservices Architecture',
                        'Hexagonal / Clean Architecture',
                        'PostgreSQL / MySQL / Oracle',
                        'Docker / Kubernetes',
                        'RabbitMQ / Event-Driven',
                        'REST API / API Gateway',
                    ].map(skill => (
                        <div key={skill} style={{
                            fontSize: 12,
                            color: 'var(--win-text-secondary)',
                            padding: '6px 0',
                            borderBottom: '1px solid rgba(255,255,255,0.04)',
                            display: 'flex',
                            alignItems: 'center',
                            gap: 8,
                        }}>
                            <span style={{ color: 'var(--win-accent)', fontSize: 8 }}>●</span>
                            {skill}
                        </div>
                    ))}
                </div>
            </div>

            {/* Experience */}
            <div style={{ marginBottom: 24 }}>
                <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--win-accent)', marginBottom: 12, textTransform: 'uppercase', letterSpacing: 0.5 }}>
                    {rt.experienceTitle}
                </div>
                {rt.experiences.map((exp: { period: string; title: string; items: string[] }) => (
                    <div key={exp.period} style={{
                        padding: '14px 18px',
                        marginBottom: 10,
                        borderLeft: '3px solid var(--win-accent)',
                        background: 'rgba(255,255,255,0.02)',
                        borderRadius: '0 6px 6px 0',
                    }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 8 }}>
                            <span style={{ fontSize: 13, fontWeight: 600, color: 'var(--win-text)' }}>{exp.title}</span>
                            <span style={{ fontSize: 11, color: 'var(--win-accent)', fontWeight: 500 }}>{exp.period}</span>
                        </div>
                        <ul style={{ padding: '0 0 0 14px', margin: 0 }}>
                            {exp.items.map((item: string, i: number) => (
                                <li key={i} style={{ fontSize: 12, color: 'var(--win-text-secondary)', lineHeight: 1.7 }}>
                                    {item}
                                </li>
                            ))}
                        </ul>
                    </div>
                ))}
            </div>

            {/* Download button */}
            <div style={{ textAlign: 'center', paddingTop: 12 }}>
                <button
                    onClick={() => window.open('/cv', '_blank')}
                    style={{
                        padding: '10px 32px',
                        background: 'var(--win-accent)',
                        border: 'none',
                        borderRadius: 6,
                        color: 'white',
                        fontSize: 13,
                        fontWeight: 600,
                        cursor: 'pointer',
                        transition: 'background 0.2s',
                    }}
                    onMouseEnter={e => (e.currentTarget.style.background = 'var(--win-accent-hover)')}
                    onMouseLeave={e => (e.currentTarget.style.background = 'var(--win-accent)')}
                >
                    {rt.downloadBtn}
                </button>
            </div>
        </div>
    );
}
