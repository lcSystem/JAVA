'use client';

import React, { useState } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';

export default function ProjectsWindow() {
    const { t } = useLanguage();
    const pt = t.projects;
    const [selected, setSelected] = useState(0);
    const project = pt.items[selected];

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
                    {pt.sidebar}
                </div>
                {pt.items.map((p: { title: string }, i: number) => (
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
                        {pt.techStack}
                    </div>
                    <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
                        {(['Spring Boot 3', 'OAuth2', 'JWT', 'PostgreSQL', 'Docker', 'RabbitMQ',
                            'Spring Security', 'React', 'Next.js', 'Flyway',
                            'JPA/Hibernate', 'Clean Architecture'][0] ? // stacks per project index
                            [
                                ['Spring Boot 3', 'OAuth2', 'JWT', 'PostgreSQL', 'Docker', 'RabbitMQ'],
                                ['Spring Security', 'JWT', 'React', 'Next.js', 'PostgreSQL', 'Flyway'],
                                ['Spring Boot', 'JPA/Hibernate', 'RabbitMQ', 'Flyway', 'Clean Architecture'],
                            ][selected] || [] : []
                        ).map(s => (
                            <span key={s} className="skill-badge">{s}</span>
                        ))}
                    </div>
                </div>

                {/* Key highlights */}
                <div style={{ marginBottom: 20 }}>
                    <div style={{ fontSize: 12, fontWeight: 600, color: 'var(--win-accent)', marginBottom: 8, textTransform: 'uppercase', letterSpacing: 0.5 }}>
                        {pt.keyFeatures}
                    </div>
                    <ul style={{ padding: '0 0 0 16px', margin: 0 }}>
                        {project.highlights.map((h: string, i: number) => (
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
                        {pt.businessImpact}
                    </div>
                    <div style={{ fontSize: 13, color: 'var(--win-text)', fontWeight: 500 }}>
                        {project.impact}
                    </div>
                </div>
            </div>
        </div>
    );
}
