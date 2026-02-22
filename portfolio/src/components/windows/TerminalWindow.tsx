'use client';

import React, { useState, useRef, useEffect, KeyboardEvent } from 'react';

interface TerminalLine {
    type: 'input' | 'output';
    content: string;
}

const COMMANDS: Record<string, string> = {
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
    about: `Luis — Senior Java Backend Developer
8+ years of enterprise software development
Specializing in Spring Boot, Microservices, OAuth2/JWT, Clean Architecture`,
    skills: `[Backend]     Java 17+ · Spring Boot 3 · Spring Security · JPA/Hibernate
[Security]    OAuth2 · JWT · RBAC · Zero-Trust · IAM
[Architecture] Hexagonal · Clean · DDD · Microservices · CQRS
[Database]    PostgreSQL · MySQL · Oracle · Flyway · Redis
[DevOps]      Docker · Kubernetes · CI/CD · GitHub Actions
[Messaging]   RabbitMQ · Event-Driven · Async Patterns`,
    projects: `1. Credit Management System  — Full financial lifecycle platform
2. IAM RBAC Redesign         — Enterprise access management
3. ERP Parameterization      — Centralized configuration service`,
    experience: `2024-Present  Lead Backend Architect
2021-2024     Senior Java Developer
2018-2021     Java Developer`,
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
    neofetch: `       ╱╲         luis@portfolio
      ╱  ╲        ─────────────
     ╱    ╲       OS: Interactive Desktop Simulation
    ╱  ▲   ╲      Stack: Java 17+ / Spring Boot 3
   ╱  ╱ ╲   ╲    Arch: Hexagonal / Clean / DDD
  ╱  ╱   ╲   ╲   Security: OAuth2 / JWT / RBAC
 ╱  ╱     ╲   ╲  DB: PostgreSQL / MySQL / Oracle
╱──╱───────╲──╲  DevOps: Docker / K8s / CI-CD
                  Shell: portfolio-shell v1.0`,
};

export default function TerminalWindow() {
    const [lines, setLines] = useState<TerminalLine[]>([
        { type: 'output', content: 'Welcome to Portfolio Terminal v1.0' },
        { type: 'output', content: 'Type "help" for available commands.\n' },
    ]);
    const [input, setInput] = useState('');
    const scrollRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        if (scrollRef.current) {
            scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
        }
    }, [lines]);

    const handleCommand = (cmd: string) => {
        const trimmed = cmd.trim().toLowerCase();
        const newLines: TerminalLine[] = [
            ...lines,
            { type: 'input', content: `$ ${cmd}` },
        ];

        if (trimmed === 'clear') {
            setLines([]);
            setInput('');
            return;
        }

        const output = COMMANDS[trimmed];
        if (output) {
            newLines.push({ type: 'output', content: output });
        } else if (trimmed) {
            newLines.push({ type: 'output', content: `Command not found: ${trimmed}. Type "help" for available commands.` });
        }

        setLines(newLines);
        setInput('');
    };

    const handleKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
        if (e.key === 'Enter') {
            handleCommand(input);
        }
    };

    return (
        <div style={{
            height: '100%',
            background: '#0c0c0c',
            fontFamily: "'Cascadia Code', 'Consolas', 'Courier New', monospace",
            fontSize: 14,
            display: 'flex',
            flexDirection: 'column',
        }}>
            <div ref={scrollRef} style={{ flex: 1, overflow: 'auto', padding: '12px 16px' }}>
                {lines.map((line, i) => (
                    <div key={i} style={{
                        color: line.type === 'input' ? '#16c60c' : '#cccccc',
                        whiteSpace: 'pre-wrap',
                        lineHeight: 1.5,
                        marginBottom: 2,
                    }}>
                        {line.content}
                    </div>
                ))}
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <span style={{ color: '#16c60c' }}>$</span>
                    <input
                        className="terminal-input"
                        value={input}
                        onChange={e => setInput(e.target.value)}
                        onKeyDown={handleKeyDown}
                        autoFocus
                        spellCheck={false}
                    />
                </div>
            </div>
        </div>
    );
}
