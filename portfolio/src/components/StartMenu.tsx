'use client';

import React from 'react';
import { motion } from 'framer-motion';
import { useWindowManager } from '@/contexts/WindowManager';
import { WINDOW_REGISTRY, WindowType } from '@/types/windows';

export default function StartMenu() {
    const { openWindow } = useWindowManager();

    const menuItems = Object.values(WINDOW_REGISTRY).filter(c => c.startMenuItem);

    // Split: main items + special recruiter item
    const mainItems = menuItems.filter(c => c.id !== 'recruiter');
    const recruiterItem = menuItems.find(c => c.id === 'recruiter');

    return (
        <motion.div
            className="start-menu"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 20 }}
            transition={{ duration: 0.18, ease: 'easeOut' }}
            onClick={e => e.stopPropagation()}
        >
            {/* Header */}
            <div style={{
                padding: '20px 24px 12px',
                borderBottom: '1px solid rgba(255,255,255,0.06)',
            }}>
                <div style={{ fontSize: 14, fontWeight: 600, color: 'var(--win-text)' }}>
                    Luis — Portfolio
                </div>
                <div style={{ fontSize: 11, color: 'var(--win-text-secondary)', marginTop: 2 }}>
                    Senior Java Backend Developer
                </div>
            </div>

            {/* Menu items */}
            <div style={{ padding: '8px 0' }}>
                {mainItems.map(config => (
                    <button
                        key={config.id}
                        onClick={() => openWindow(config.id)}
                        style={{
                            display: 'flex',
                            alignItems: 'center',
                            gap: 14,
                            width: '100%',
                            padding: '10px 24px',
                            background: 'transparent',
                            border: 'none',
                            color: 'var(--win-text)',
                            cursor: 'pointer',
                            fontSize: 13,
                            textAlign: 'left',
                            transition: 'background 0.15s',
                        }}
                        onMouseEnter={e => (e.currentTarget.style.background = 'rgba(255,255,255,0.06)')}
                        onMouseLeave={e => (e.currentTarget.style.background = 'transparent')}
                    >
                        <span style={{ fontSize: 20, width: 28, textAlign: 'center' }}>{config.icon}</span>
                        <span>{config.title}</span>
                    </button>
                ))}
            </div>

            {/* Executive Summary / Recruiter View — Special highlight */}
            {recruiterItem && (
                <div style={{ borderTop: '1px solid rgba(255,255,255,0.06)', padding: '8px 0' }}>
                    <button
                        onClick={() => openWindow(recruiterItem.id as WindowType)}
                        style={{
                            display: 'flex',
                            alignItems: 'center',
                            gap: 14,
                            width: '100%',
                            padding: '12px 24px',
                            background: 'linear-gradient(90deg, rgba(0,120,212,0.12) 0%, transparent 100%)',
                            border: 'none',
                            color: 'var(--win-accent)',
                            cursor: 'pointer',
                            fontSize: 13,
                            fontWeight: 600,
                            textAlign: 'left',
                            transition: 'background 0.15s',
                        }}
                        onMouseEnter={e => (e.currentTarget.style.background = 'linear-gradient(90deg, rgba(0,120,212,0.22) 0%, transparent 100%)')}
                        onMouseLeave={e => (e.currentTarget.style.background = 'linear-gradient(90deg, rgba(0,120,212,0.12) 0%, transparent 100%)')}
                    >
                        <span style={{ fontSize: 20, width: 28, textAlign: 'center' }}>{recruiterItem.icon}</span>
                        <span>📊 Executive Summary Mode</span>
                    </button>
                </div>
            )}

            {/* Footer */}
            <div style={{
                padding: '12px 24px',
                borderTop: '1px solid rgba(255,255,255,0.06)',
                display: 'flex',
                alignItems: 'center',
                gap: 12,
                fontSize: 11,
                color: 'var(--win-text-secondary)',
            }}>
                <span>⚡ Powered by Next.js & TypeScript</span>
            </div>
        </motion.div>
    );
}
