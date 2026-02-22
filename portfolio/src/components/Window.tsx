'use client';

import React, { useRef, useEffect } from 'react';
import { motion } from 'framer-motion';
import { useWindowManager, WindowState } from '@/contexts/WindowManager';
import { WindowType } from '@/types/windows';
import { useDrag } from '@/hooks/useDrag';

interface WindowProps {
    windowState: WindowState;
    children: React.ReactNode;
}

export default function Window({ windowState, children }: WindowProps) {
    const { closeWindow, minimizeWindow, maximizeWindow, focusWindow, updatePosition } = useWindowManager();
    const windowRef = useRef<HTMLDivElement>(null);

    const { position, isDragging, onMouseDown } = useDrag({
        initialPosition: windowState.position,
        onDragEnd: (pos) => updatePosition(windowState.id as WindowType, pos),
        disabled: windowState.isMaximized,
    });

    const handleFocus = () => {
        focusWindow(windowState.id as WindowType);
    };

    // Don't render if not open; if minimized, hide via CSS (don't unmount)
    if (!windowState.isOpen) return null;

    const style: React.CSSProperties = windowState.isMaximized
        ? {
            position: 'fixed',
            top: 0,
            left: 0,
            width: '100vw',
            height: 'calc(100vh - 48px)',
            zIndex: windowState.zIndex,
        }
        : {
            position: 'absolute',
            top: position.y,
            left: position.x,
            width: windowState.size.width,
            height: windowState.size.height,
            zIndex: windowState.zIndex,
        };

    return (
        <motion.div
            ref={windowRef}
            initial={{ opacity: 0, scale: 0.92, y: 20 }}
            animate={{
                opacity: windowState.isMinimized ? 0 : 1,
                scale: windowState.isMinimized ? 0.8 : 1,
                y: windowState.isMinimized ? 60 : 0,
            }}
            transition={{ duration: 0.2, ease: 'easeOut' }}
            style={{
                ...style,
                display: 'flex',
                flexDirection: 'column',
                pointerEvents: windowState.isMinimized ? 'none' : 'auto',
                visibility: windowState.isMinimized ? 'hidden' : 'visible',
            }}
            className="rounded-lg overflow-hidden"
            onMouseDown={handleFocus}
        >
            {/* Glass background */}
            <div
                style={{
                    position: 'absolute',
                    inset: 0,
                    background: 'var(--win-surface)',
                    border: '1px solid var(--win-border)',
                    borderRadius: '8px',
                    boxShadow: 'var(--win-shadow-active)',
                    zIndex: -1,
                }}
            />

            {/* Title bar */}
            <div
                onMouseDown={onMouseDown}
                style={{
                    height: 32,
                    minHeight: 32,
                    background: 'var(--win-titlebar)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    paddingLeft: 12,
                    cursor: windowState.isMaximized ? 'default' : (isDragging ? 'grabbing' : 'grab'),
                    borderTopLeftRadius: 8,
                    borderTopRightRadius: 8,
                    userSelect: 'none',
                }}
            >
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 12, color: 'var(--win-text-secondary)' }}>
                    <span>{windowState.icon}</span>
                    <span>{windowState.title}</span>
                </div>
                <div style={{ display: 'flex' }}>
                    <button
                        className="win-btn"
                        onClick={(e) => { e.stopPropagation(); minimizeWindow(windowState.id as WindowType); }}
                        aria-label="Minimize"
                    >
                        <svg width="10" height="1" viewBox="0 0 10 1"><rect width="10" height="1" fill="currentColor" /></svg>
                    </button>
                    <button
                        className="win-btn"
                        onClick={(e) => { e.stopPropagation(); maximizeWindow(windowState.id as WindowType); }}
                        aria-label="Maximize"
                    >
                        <svg width="10" height="10" viewBox="0 0 10 10" fill="none"><rect x="0.5" y="0.5" width="9" height="9" stroke="currentColor" strokeWidth="1" /></svg>
                    </button>
                    <button
                        className="win-btn win-btn-close"
                        onClick={(e) => { e.stopPropagation(); closeWindow(windowState.id as WindowType); }}
                        aria-label="Close"
                    >
                        <svg width="10" height="10" viewBox="0 0 10 10"><line x1="0" y1="0" x2="10" y2="10" stroke="currentColor" strokeWidth="1.2" /><line x1="10" y1="0" x2="0" y2="10" stroke="currentColor" strokeWidth="1.2" /></svg>
                    </button>
                </div>
            </div>

            {/* Content */}
            <div style={{
                flex: 1,
                overflow: 'auto',
                padding: 0,
            }}>
                {children}
            </div>
        </motion.div>
    );
}
