'use client';

import React, { createContext, useContext, useState, useCallback, ReactNode } from 'react';
import { WindowType, WINDOW_REGISTRY } from '@/types/windows';

export interface WindowState {
    id: WindowType;
    title: string;
    isOpen: boolean;
    isMinimized: boolean;
    isMaximized: boolean;
    position: { x: number; y: number };
    size: { width: number; height: number };
    zIndex: number;
    icon: string;
}

interface WindowManagerContextType {
    windows: WindowState[];
    openWindow: (id: WindowType) => void;
    closeWindow: (id: WindowType) => void;
    minimizeWindow: (id: WindowType) => void;
    maximizeWindow: (id: WindowType) => void;
    restoreWindow: (id: WindowType) => void;
    focusWindow: (id: WindowType) => void;
    updatePosition: (id: WindowType, position: { x: number; y: number }) => void;
    startMenuOpen: boolean;
    setStartMenuOpen: (open: boolean) => void;
    highestZIndex: number;
}

const WindowManagerContext = createContext<WindowManagerContextType | null>(null);

function createDefaultWindows(): WindowState[] {
    return Object.values(WINDOW_REGISTRY).map(config => ({
        id: config.id,
        title: config.title,
        isOpen: false,
        isMinimized: false,
        isMaximized: false,
        position: { ...config.defaultPosition },
        size: { ...config.defaultSize },
        zIndex: 1,
        icon: config.icon,
    }));
}

export function WindowManagerProvider({ children }: { children: ReactNode }) {
    const [windows, setWindows] = useState<WindowState[]>(createDefaultWindows);
    const [highestZIndex, setHighestZIndex] = useState(10);
    const [startMenuOpen, setStartMenuOpen] = useState(false);

    const focusWindow = useCallback((id: WindowType) => {
        setHighestZIndex(prev => {
            const newZ = prev + 1;
            setWindows(ws => ws.map(w => w.id === id ? { ...w, zIndex: newZ } : w));
            return newZ;
        });
    }, []);

    const openWindow = useCallback((id: WindowType) => {
        setStartMenuOpen(false);
        setHighestZIndex(prev => {
            const newZ = prev + 1;
            setWindows(ws => ws.map(w =>
                w.id === id ? { ...w, isOpen: true, isMinimized: false, zIndex: newZ } : w
            ));
            return newZ;
        });
    }, []);

    const closeWindow = useCallback((id: WindowType) => {
        setWindows(ws => ws.map(w =>
            w.id === id ? { ...w, isOpen: false, isMinimized: false, isMaximized: false } : w
        ));
    }, []);

    const minimizeWindow = useCallback((id: WindowType) => {
        setWindows(ws => ws.map(w =>
            w.id === id ? { ...w, isMinimized: true } : w
        ));
    }, []);

    const maximizeWindow = useCallback((id: WindowType) => {
        setWindows(ws => ws.map(w =>
            w.id === id ? { ...w, isMaximized: !w.isMaximized } : w
        ));
    }, []);

    const restoreWindow = useCallback((id: WindowType) => {
        setHighestZIndex(prev => {
            const newZ = prev + 1;
            setWindows(ws => ws.map(w =>
                w.id === id ? { ...w, isMinimized: false, zIndex: newZ } : w
            ));
            return newZ;
        });
    }, []);

    const updatePosition = useCallback((id: WindowType, position: { x: number; y: number }) => {
        setWindows(ws => ws.map(w =>
            w.id === id ? { ...w, position } : w
        ));
    }, []);

    return (
        <WindowManagerContext.Provider value={{
            windows,
            openWindow,
            closeWindow,
            minimizeWindow,
            maximizeWindow,
            restoreWindow,
            focusWindow,
            updatePosition,
            startMenuOpen,
            setStartMenuOpen,
            highestZIndex,
        }}>
            {children}
        </WindowManagerContext.Provider>
    );
}

export function useWindowManager() {
    const ctx = useContext(WindowManagerContext);
    if (!ctx) throw new Error('useWindowManager must be used within WindowManagerProvider');
    return ctx;
}
