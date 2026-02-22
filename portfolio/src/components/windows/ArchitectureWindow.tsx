'use client';

import React, { useState } from 'react';
import { motion } from 'framer-motion';

type ArchTab = 'overview' | 'jwt' | 'authorization';

// ─── Component Box ──────────────────────────────────────────────────
function ArchBox({ label, icon, color, delay = 0 }: { label: string; icon: string; color: string; delay?: number }) {
    return (
        <motion.div
            initial={{ opacity: 0, scale: 0.85 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.4, delay }}
            style={{
                padding: '14px 20px',
                background: `linear-gradient(135deg, ${color}18, ${color}08)`,
                border: `1px solid ${color}40`,
                borderRadius: 10,
                textAlign: 'center',
                minWidth: 120,
                cursor: 'default',
                transition: 'transform 0.2s, border-color 0.2s',
            }}
            whileHover={{ scale: 1.05, borderColor: color }}
        >
            <div style={{ fontSize: 22, marginBottom: 4 }}>{icon}</div>
            <div style={{ fontSize: 11, fontWeight: 600, color: 'var(--win-text)' }}>{label}</div>
        </motion.div>
    );
}

// ─── Animated Arrow ─────────────────────────────────────────────────
function AnimatedArrow({ direction = 'right', delay = 0 }: { direction?: 'right' | 'down'; delay?: number }) {
    const isHorizontal = direction === 'right';
    return (
        <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.3, delay }}
            style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                padding: isHorizontal ? '0 4px' : '4px 0',
                position: 'relative',
            }}
        >
            <svg
                width={isHorizontal ? 56 : 20}
                height={isHorizontal ? 20 : 56}
                viewBox={isHorizontal ? '0 0 56 20' : '0 0 20 56'}
            >
                {isHorizontal ? (
                    <>
                        <motion.line
                            x1="0" y1="10" x2="44" y2="10"
                            stroke="var(--win-accent)"
                            strokeWidth="2"
                            strokeDasharray="6 4"
                            initial={{ pathLength: 0 }}
                            animate={{ pathLength: 1 }}
                            transition={{ duration: 0.8, delay: delay + 0.2 }}
                        />
                        <motion.polygon
                            points="44,4 56,10 44,16"
                            fill="var(--win-accent)"
                            initial={{ opacity: 0 }}
                            animate={{ opacity: 1 }}
                            transition={{ duration: 0.3, delay: delay + 0.8 }}
                        />
                    </>
                ) : (
                    <>
                        <motion.line
                            x1="10" y1="0" x2="10" y2="44"
                            stroke="var(--win-accent)"
                            strokeWidth="2"
                            strokeDasharray="6 4"
                            initial={{ pathLength: 0 }}
                            animate={{ pathLength: 1 }}
                            transition={{ duration: 0.8, delay: delay + 0.2 }}
                        />
                        <motion.polygon
                            points="4,44 10,56 16,44"
                            fill="var(--win-accent)"
                            initial={{ opacity: 0 }}
                            animate={{ opacity: 1 }}
                            transition={{ duration: 0.3, delay: delay + 0.8 }}
                        />
                    </>
                )}
            </svg>
        </motion.div>
    );
}

// ─── JWT Flow Step ──────────────────────────────────────────────────
function JwtStep({ step, label, description, delay }: { step: number; label: string; description: string; delay: number }) {
    return (
        <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.4, delay }}
            style={{
                display: 'flex',
                gap: 14,
                padding: '12px 16px',
                background: 'rgba(0,120,212,0.06)',
                border: '1px solid rgba(0,120,212,0.15)',
                borderRadius: 8,
            }}
        >
            <div style={{
                width: 32,
                height: 32,
                borderRadius: '50%',
                background: 'var(--win-accent)',
                color: 'white',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: 14,
                fontWeight: 700,
                flexShrink: 0,
            }}>
                {step}
            </div>
            <div>
                <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--win-text)', marginBottom: 2 }}>{label}</div>
                <div style={{ fontSize: 11, color: 'var(--win-text-secondary)', lineHeight: 1.5 }}>{description}</div>
            </div>
        </motion.div>
    );
}

// ─── Decision Node ──────────────────────────────────────────────────
function DecisionNode({ label, yes, no, delay }: { label: string; yes: string; no: string; delay: number }) {
    return (
        <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.4, delay }}
            style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                gap: 8,
            }}
        >
            <div style={{
                padding: '12px 20px',
                background: 'linear-gradient(135deg, rgba(251,191,36,0.15), rgba(251,191,36,0.05))',
                border: '1px solid rgba(251,191,36,0.3)',
                borderRadius: 8,
                transform: 'rotate(0deg)',
                textAlign: 'center',
                fontSize: 12,
                fontWeight: 600,
                color: 'var(--win-text)',
                minWidth: 140,
            }}>
                ◆ {label}
            </div>
            <div style={{ display: 'flex', gap: 20 }}>
                <div style={{
                    padding: '6px 14px',
                    background: 'rgba(16,185,129,0.1)',
                    border: '1px solid rgba(16,185,129,0.3)',
                    borderRadius: 6,
                    fontSize: 11,
                    color: '#34d399',
                }}>
                    ✅ {yes}
                </div>
                <div style={{
                    padding: '6px 14px',
                    background: 'rgba(239,68,68,0.1)',
                    border: '1px solid rgba(239,68,68,0.3)',
                    borderRadius: 6,
                    fontSize: 11,
                    color: '#f87171',
                }}>
                    ❌ {no}
                </div>
            </div>
        </motion.div>
    );
}

// ─── Main ArchitectureWindow ────────────────────────────────────────
export default function ArchitectureWindow() {
    const [tab, setTab] = useState<ArchTab>('overview');

    return (
        <div style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
            {/* Tabs */}
            <div style={{
                display: 'flex',
                borderBottom: '1px solid var(--win-border)',
                background: 'rgba(0,0,0,0.15)',
            }}>
                {[
                    { id: 'overview' as const, label: '🏗️ System Overview' },
                    { id: 'jwt' as const, label: '🔐 JWT Flow' },
                    { id: 'authorization' as const, label: '🛡️ Authorization' },
                ].map(t => (
                    <button
                        key={t.id}
                        className={`tab-btn ${tab === t.id ? 'active' : ''}`}
                        onClick={() => setTab(t.id)}
                    >
                        {t.label}
                    </button>
                ))}
            </div>

            {/* Content */}
            <div style={{ flex: 1, overflow: 'auto', padding: 24 }}>
                {tab === 'overview' && <OverviewDiagram />}
                {tab === 'jwt' && <JwtFlowDiagram />}
                {tab === 'authorization' && <AuthorizationFlowDiagram />}
            </div>
        </div>
    );
}

// ─── Overview Diagram ───────────────────────────────────────────────
function OverviewDiagram() {
    return (
        <div>
            <div className="section-heading">Microservices Architecture</div>

            {/* Top row: Client → API Gateway → Auth Server */}
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 0, marginBottom: 24 }}>
                <ArchBox label="Client (SPA)" icon="🌐" color="#60a5fa" delay={0} />
                <AnimatedArrow direction="right" delay={0.2} />
                <ArchBox label="API Gateway" icon="🚀" color="#a78bfa" delay={0.3} />
                <AnimatedArrow direction="right" delay={0.5} />
                <ArchBox label="Auth Server" icon="🔐" color="#f87171" delay={0.6} />
            </div>

            {/* Middle row: Microservices */}
            <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 8 }}>
                <AnimatedArrow direction="down" delay={0.8} />
            </div>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 16, marginBottom: 24 }}>
                <ArchBox label="IAM Service" icon="👥" color="#fbbf24" delay={1.0} />
                <ArchBox label="Credits Service" icon="💰" color="#34d399" delay={1.1} />
                <ArchBox label="Params Service" icon="⚙️" color="#fb923c" delay={1.2} />
                <ArchBox label="Reports Service" icon="📊" color="#38bdf8" delay={1.3} />
            </div>

            {/* Bottom row: Infrastructure */}
            <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 8 }}>
                <AnimatedArrow direction="down" delay={1.4} />
            </div>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 16 }}>
                <ArchBox label="PostgreSQL" icon="🐘" color="#60a5fa" delay={1.6} />
                <ArchBox label="RabbitMQ" icon="🐰" color="#fb923c" delay={1.7} />
                <ArchBox label="Docker / K8s" icon="🐳" color="#38bdf8" delay={1.8} />
            </div>

            {/* Legend */}
            <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 2 }}
                style={{
                    marginTop: 24,
                    padding: '12px 16px',
                    background: 'rgba(255,255,255,0.02)',
                    borderRadius: 8,
                    border: '1px solid var(--win-border)',
                    fontSize: 11,
                    color: 'var(--win-text-secondary)',
                    textAlign: 'center',
                }}
            >
                Each service follows Hexagonal Architecture (Ports & Adapters) with independent databases (Database-per-Service pattern)
            </motion.div>
        </div>
    );
}

// ─── JWT Flow Diagram ───────────────────────────────────────────────
function JwtFlowDiagram() {
    const steps = [
        { step: 1, label: 'Client Authentication', description: 'User submits credentials (username/password) to the OAuth2 Authorization Server.' },
        { step: 2, label: 'Credential Validation', description: 'Authorization Server validates credentials against the IAM database using BCrypt password hashing.' },
        { step: 3, label: 'JWT Generation', description: 'Server generates JWT with custom claims: user ID, roles (ADMIN, USER), permissions (CRUD per module), and organizational context.' },
        { step: 4, label: 'Token Delivery', description: 'JWT access token + refresh token returned to client. Access token has short TTL, refresh token has longer TTL.' },
        { step: 5, label: 'API Request', description: 'Client includes JWT in Authorization header (Bearer token) for every API request through the API Gateway.' },
        { step: 6, label: 'Token Validation', description: 'Resource Server validates JWT signature, expiration, and extracts claims for authorization decisions.' },
        { step: 7, label: 'Authorization Check', description: '@PreAuthorize annotations check extracted roles/permissions against endpoint requirements. Zero-trust: every request is verified.' },
    ];

    return (
        <div>
            <div className="section-heading">JWT Authentication Flow</div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                {steps.map((s, i) => (
                    <JwtStep key={i} {...s} delay={i * 0.15} />
                ))}
            </div>
        </div>
    );
}

// ─── Authorization Decision Flow ────────────────────────────────────
function AuthorizationFlowDiagram() {
    return (
        <div>
            <div className="section-heading">Authorization Decision Flow</div>
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 16 }}>
                {/* Entry */}
                <motion.div
                    initial={{ opacity: 0, y: -10 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.3 }}
                    style={{
                        padding: '10px 24px',
                        background: 'rgba(0,120,212,0.15)',
                        border: '1px solid rgba(0,120,212,0.3)',
                        borderRadius: 20,
                        fontSize: 13,
                        fontWeight: 600,
                        color: 'var(--win-text)',
                    }}
                >
                    📥 Incoming API Request
                </motion.div>

                <AnimatedArrow direction="down" delay={0.2} />
                <DecisionNode label="Valid JWT?" yes="Continue" no="401 Unauthorized" delay={0.4} />

                <AnimatedArrow direction="down" delay={0.6} />
                <DecisionNode label="Token Expired?" yes="Refresh Flow" no="Continue" delay={0.8} />

                <AnimatedArrow direction="down" delay={1.0} />
                <DecisionNode label="Has Required Role?" yes="Continue" no="403 Forbidden" delay={1.2} />

                <AnimatedArrow direction="down" delay={1.4} />
                <DecisionNode label="Has CRUD Permission?" yes="Grant Access" no="403 Forbidden" delay={1.6} />

                <AnimatedArrow direction="down" delay={1.8} />

                {/* Result */}
                <motion.div
                    initial={{ opacity: 0, scale: 0.9 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ duration: 0.4, delay: 2.0 }}
                    style={{
                        padding: '12px 28px',
                        background: 'linear-gradient(135deg, rgba(16,185,129,0.2), rgba(16,185,129,0.08))',
                        border: '1px solid rgba(16,185,129,0.3)',
                        borderRadius: 20,
                        fontSize: 13,
                        fontWeight: 600,
                        color: '#34d399',
                    }}
                >
                    ✅ Execute Business Logic + Audit Log
                </motion.div>
            </div>

            {/* Info box */}
            <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 2.2 }}
                style={{
                    marginTop: 24,
                    padding: '14px 18px',
                    background: 'rgba(139,92,246,0.08)',
                    border: '1px solid rgba(139,92,246,0.2)',
                    borderRadius: 8,
                    fontSize: 12,
                    color: 'var(--win-text-secondary)',
                    lineHeight: 1.6,
                }}
            >
                <strong style={{ color: 'var(--win-text)' }}>Zero-Trust Model:</strong> Every single API request goes through this decision chain.
                No action is implicitly trusted. RBAC permissions are evaluated per-resource with CRUD granularity.
                All decisions are audit-logged for compliance.
            </motion.div>
        </div>
    );
}
