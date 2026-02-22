'use client';

import React from 'react';
import { useWindowManager } from '@/contexts/WindowManager';
import { useLanguage } from '@/contexts/LanguageContext';
import { WINDOW_REGISTRY, WindowType } from '@/types/windows';
import Window from './Window';
import AboutWindow from './windows/AboutWindow';
import ProjectsWindow from './windows/ProjectsWindow';
import ArchitectureWindow from './windows/ArchitectureWindow';
import ResumeWindow from './windows/ResumeWindow';
import ContactWindow from './windows/ContactWindow';
import TerminalWindow from './windows/TerminalWindow';
import AssistantWindow from './windows/AssistantWindow';
import RecruiterWindow from './windows/RecruiterWindow';
import Taskbar from './Taskbar';
import StartMenu from './StartMenu';

const WINDOW_CONTENT: Record<WindowType, React.FC> = {
    about: AboutWindow,
    projects: ProjectsWindow,
    architecture: ArchitectureWindow,
    resume: ResumeWindow,
    contact: ContactWindow,
    terminal: TerminalWindow,
    assistant: AssistantWindow,
    recruiter: RecruiterWindow,
};

export default function Desktop() {
    const { windows, openWindow, startMenuOpen, setStartMenuOpen } = useWindowManager();
    const { t } = useLanguage();

    const desktopIcons = Object.values(WINDOW_REGISTRY).filter(c => c.desktopIcon);

    return (
        <div
            style={{
                width: '100vw',
                height: '100vh',
                position: 'relative',
                overflow: 'hidden',
                backgroundImage: 'url(/bg.png)',
                backgroundSize: 'cover',
                backgroundPosition: 'center',
                backgroundRepeat: 'no-repeat',
            }}
            onClick={() => { if (startMenuOpen) setStartMenuOpen(false); }}
        >
            {/* Dark overlay for readability */}
            <div style={{
                position: 'absolute',
                inset: 0,
                background: 'linear-gradient(135deg, rgba(0,0,0,0.55) 0%, rgba(0,0,0,0.4) 50%, rgba(0,0,0,0.55) 100%)',
                pointerEvents: 'none',
                zIndex: 0,
            }} />

            {/* Desktop icons */}
            <div style={{
                position: 'absolute',
                top: 20,
                left: 20,
                display: 'flex',
                flexDirection: 'column',
                gap: 4,
                zIndex: 1,
            }}>
                {desktopIcons.map(config => (
                    <div
                        key={config.id}
                        className="desktop-icon"
                        onDoubleClick={() => openWindow(config.id)}
                    >
                        <div style={{ fontSize: 36 }}>{config.icon}</div>
                        <span>{t.windowTitles[config.id]}</span>
                    </div>
                ))}
            </div>

            {/* Render all windows (minimized ones are hidden via CSS, not unmounted) */}
            {windows.map(w => {
                const ContentComponent = WINDOW_CONTENT[w.id];
                return (
                    <Window key={w.id} windowState={w}>
                        <ContentComponent />
                    </Window>
                );
            })}

            {/* Start Menu */}
            {startMenuOpen && <StartMenu />}

            {/* Taskbar */}
            <Taskbar />
        </div>
    );
}
