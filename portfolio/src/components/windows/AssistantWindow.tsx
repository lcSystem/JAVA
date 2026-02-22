'use client';

import React, { useState, useRef, useEffect, KeyboardEvent } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import { findAnswer, Intent } from '@/data/knowledgeBase';

interface Message {
    role: 'user' | 'assistant';
    content: string;
    intent?: Intent;
}

const INTENT_LABELS: Record<Intent, { label: string; color: string }> = {
    experience: { label: 'EXPERIENCE', color: '#60a5fa' },
    projects: { label: 'PROJECTS', color: '#34d399' },
    architecture: { label: 'ARCHITECTURE', color: '#a78bfa' },
    security: { label: 'SECURITY', color: '#f87171' },
    iam: { label: 'IAM', color: '#fbbf24' },
    skills: { label: 'SKILLS', color: '#38bdf8' },
    contact: { label: 'CONTACT', color: '#fb923c' },
    impact: { label: 'IMPACT', color: '#4ade80' },
    fallback: { label: 'RESTRICTED', color: '#ef4444' },
};

export default function AssistantWindow() {
    const { locale, t } = useLanguage();
    const at = t.assistant;

    const [messages, setMessages] = useState<Message[]>([
        {
            role: 'assistant',
            content: at.greeting,
            intent: undefined,
        },
    ]);
    const [input, setInput] = useState('');
    const scrollRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        if (scrollRef.current) {
            scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
        }
    }, [messages]);

    const handleSend = (text?: string) => {
        const query = text || input.trim();
        if (!query) return;

        const userMsg: Message = { role: 'user', content: query };
        const { answer, intent } = findAnswer(query, locale);
        const assistantMsg: Message = { role: 'assistant', content: answer, intent };

        setMessages(prev => [...prev, userMsg, assistantMsg]);
        setInput('');
    };

    const handleKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
        if (e.key === 'Enter') handleSend();
    };

    return (
        <div style={{ height: '100%', display: 'flex', flexDirection: 'column', background: '#0f0f1a' }}>
            {/* Messages */}
            <div ref={scrollRef} style={{ flex: 1, overflow: 'auto', padding: 16 }}>
                {messages.map((msg, i) => (
                    <div
                        key={i}
                        className="fade-in"
                        style={{
                            display: 'flex',
                            justifyContent: msg.role === 'user' ? 'flex-end' : 'flex-start',
                            marginBottom: 12,
                        }}
                    >
                        <div style={{
                            maxWidth: '85%',
                            padding: '10px 14px',
                            borderRadius: msg.role === 'user' ? '16px 16px 4px 16px' : '16px 16px 16px 4px',
                            background: msg.role === 'user'
                                ? 'linear-gradient(135deg, var(--win-accent), #6366f1)'
                                : 'rgba(255,255,255,0.06)',
                            color: 'var(--win-text)',
                            fontSize: 13,
                            lineHeight: 1.6,
                            whiteSpace: 'pre-wrap',
                        }}>
                            {/* Intent badge for assistant messages */}
                            {msg.role === 'assistant' && msg.intent && (
                                <div style={{
                                    display: 'inline-block',
                                    fontSize: 9,
                                    fontWeight: 700,
                                    padding: '2px 8px',
                                    borderRadius: 10,
                                    background: `${INTENT_LABELS[msg.intent].color}22`,
                                    color: INTENT_LABELS[msg.intent].color,
                                    marginBottom: 6,
                                    letterSpacing: 0.5,
                                }}>
                                    {INTENT_LABELS[msg.intent].label}
                                </div>
                            )}
                            {msg.role === 'assistant' && msg.intent && <br />}
                            {msg.content}
                        </div>
                    </div>
                ))}
            </div>

            {/* Suggested questions */}
            {messages.length <= 1 && (
                <div style={{
                    padding: '0 16px 8px',
                    display: 'flex',
                    flexWrap: 'wrap',
                    gap: 6,
                }}>
                    {at.suggestedQuestions.map((q: string) => (
                        <button
                            key={q}
                            onClick={() => handleSend(q)}
                            style={{
                                fontSize: 11,
                                padding: '5px 12px',
                                background: 'rgba(0,120,212,0.1)',
                                border: '1px solid rgba(0,120,212,0.2)',
                                borderRadius: 16,
                                color: 'var(--win-accent)',
                                cursor: 'pointer',
                                transition: 'all 0.15s',
                            }}
                            onMouseEnter={e => { e.currentTarget.style.background = 'rgba(0,120,212,0.2)'; }}
                            onMouseLeave={e => { e.currentTarget.style.background = 'rgba(0,120,212,0.1)'; }}
                        >
                            {q}
                        </button>
                    ))}
                </div>
            )}

            {/* Input */}
            <div style={{ padding: '8px 12px 12px', borderTop: '1px solid rgba(255,255,255,0.06)' }}>
                <div style={{ display: 'flex', gap: 8 }}>
                    <input
                        className="chat-input"
                        placeholder={at.placeholder}
                        value={input}
                        onChange={e => setInput(e.target.value)}
                        onKeyDown={handleKeyDown}
                    />
                    <button
                        onClick={() => handleSend()}
                        style={{
                            width: 40,
                            height: 40,
                            borderRadius: '50%',
                            background: 'var(--win-accent)',
                            border: 'none',
                            color: 'white',
                            cursor: 'pointer',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            fontSize: 16,
                            flexShrink: 0,
                            transition: 'background 0.15s',
                        }}
                        onMouseEnter={e => (e.currentTarget.style.background = 'var(--win-accent-hover)')}
                        onMouseLeave={e => (e.currentTarget.style.background = 'var(--win-accent)')}
                    >
                        ➤
                    </button>
                </div>
                <div style={{
                    fontSize: 10,
                    color: 'var(--win-text-secondary)',
                    marginTop: 6,
                    textAlign: 'center',
                    opacity: 0.6,
                }}>
                    {at.footer}
                </div>
            </div>
        </div>
    );
}
