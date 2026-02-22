'use client';

import React, { useState, useEffect } from 'react';
import { useWindowManager } from '@/contexts/WindowManager';
import { WindowType } from '@/types/windows';

export default function Taskbar() {
    const { windows, openWindow, restoreWindow, minimizeWindow, focusWindow, startMenuOpen, setStartMenuOpen } = useWindowManager();
    const [time, setTime] = useState('');

    useEffect(() => {
        const update = () => {
            const now = new Date();
            setTime(now.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true }));
        };
        update();
        const interval = setInterval(update, 30000);
        return () => clearInterval(interval);
    }, []);

    const openWindows = windows.filter(w => w.isOpen);

    const handleTaskbarClick = (id: WindowType) => {
        const win = windows.find(w => w.id === id);
        if (!win) return;
        if (win.isMinimized) {
            restoreWindow(id);
        } else {
            // If it's the topmost window, minimize it; otherwise focus it
            const maxZ = Math.max(...openWindows.filter(w => !w.isMinimized).map(w => w.zIndex));
            if (win.zIndex === maxZ) {
                minimizeWindow(id);
            } else {
                focusWindow(id);
            }
        }
    };

    return (
        <div className="taskbar">
            {/* Start button */}
            <button
                onClick={(e) => { e.stopPropagation(); setStartMenuOpen(!startMenuOpen); }}
                style={{
                    width: 48,
                    height: 48,
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    border: 'none',
                    background: startMenuOpen ? 'rgba(0, 120, 212, 0.2)' : 'transparent',
                    cursor: 'pointer',
                    transition: 'background 0.15s',
                    flexShrink: 0,
                }}
                onMouseEnter={e => { if (!startMenuOpen) (e.target as HTMLButtonElement).style.background = 'rgba(255,255,255,0.06)'; }}
                onMouseLeave={e => { if (!startMenuOpen) (e.target as HTMLButtonElement).style.background = 'transparent'; }}
            >
                <svg width="18" height="18" viewBox="0 0 20 20" fill="none">
                    <rect x="1" y="1" width="8" height="8" fill="#0078d4" rx="1" />
                    <rect x="11" y="1" width="8" height="8" fill="#0078d4" rx="1" />
                    <rect x="1" y="11" width="8" height="8" fill="#0078d4" rx="1" />
                    <rect x="11" y="11" width="8" height="8" fill="#0078d4" rx="1" />
                </svg>
            </button>

            {/* Separator */}
            <div style={{ width: 1, height: 24, background: 'rgba(255,255,255,0.08)', margin: '0 4px', flexShrink: 0 }} />

            {/* Open window buttons */}
            <div style={{ display: 'flex', alignItems: 'center', gap: 2, flex: 1, overflow: 'hidden' }}>
                {openWindows.map(w => {
                    const isActive = !w.isMinimized && w.zIndex === Math.max(...openWindows.filter(ow => !ow.isMinimized).map(ow => ow.zIndex));
                    return (
                        <button
                            key={w.id}
                            onClick={() => handleTaskbarClick(w.id as WindowType)}
                            style={{
                                display: 'flex',
                                alignItems: 'center',
                                gap: 6,
                                padding: '4px 12px',
                                height: 36,
                                background: isActive ? 'rgba(255,255,255,0.08)' : 'transparent',
                                border: 'none',
                                borderBottom: isActive ? '2px solid var(--win-accent)' : '2px solid transparent',
                                color: isActive ? 'var(--win-text)' : 'var(--win-text-secondary)',
                                cursor: 'pointer',
                                fontSize: 12,
                                borderRadius: '4px 4px 0 0',
                                transition: 'all 0.15s',
                                whiteSpace: 'nowrap',
                                maxWidth: 160,
                                overflow: 'hidden',
                                textOverflow: 'ellipsis',
                            }}
                            onMouseEnter={e => { if (!isActive) (e.currentTarget as HTMLButtonElement).style.background = 'rgba(255,255,255,0.04)'; }}
                            onMouseLeave={e => { if (!isActive) (e.currentTarget as HTMLButtonElement).style.background = 'transparent'; }}
                        >
                            <span>{w.icon}</span>
                            <span>{w.title}</span>
                        </button>
                    );
                })}
            </div>

            {/* System Tray */}
            <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: 12,
                paddingRight: 12,
                fontSize: 12,
                color: 'var(--win-text-secondary)',
                flexShrink: 0,
            }}>
                <span style={{ fontSize: 14 }}>🔊</span>
                <span style={{ fontSize: 14 }}>🌐</span>
                <span>{time}</span>
            </div>
        </div>
    );
}
