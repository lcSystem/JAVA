// ─── Strong Typing: Window System ───────────────────────────────────
export type WindowType =
    | "about"
    | "projects"
    | "architecture"
    | "resume"
    | "contact"
    | "terminal"
    | "assistant"
    | "recruiter";

export interface WindowConfig {
    id: WindowType;
    title: string;
    icon: string;
    defaultSize: { width: number; height: number };
    defaultPosition: { x: number; y: number };
    desktopIcon: boolean;
    startMenuItem: boolean;
}

// ─── Central Window Registry ────────────────────────────────────────
export const WINDOW_REGISTRY: Record<WindowType, WindowConfig> = {
    about: {
        id: "about",
        title: "About Me",
        icon: "👤",
        defaultSize: { width: 720, height: 520 },
        defaultPosition: { x: 80, y: 40 },
        desktopIcon: true,
        startMenuItem: true,
    },
    projects: {
        id: "projects",
        title: "Projects",
        icon: "📂",
        defaultSize: { width: 860, height: 580 },
        defaultPosition: { x: 120, y: 60 },
        desktopIcon: true,
        startMenuItem: true,
    },
    architecture: {
        id: "architecture",
        title: "Architecture",
        icon: "🏗️",
        defaultSize: { width: 820, height: 560 },
        defaultPosition: { x: 100, y: 50 },
        desktopIcon: true,
        startMenuItem: true,
    },
    resume: {
        id: "resume",
        title: "Resume",
        icon: "📄",
        defaultSize: { width: 700, height: 520 },
        defaultPosition: { x: 160, y: 70 },
        desktopIcon: true,
        startMenuItem: true,
    },
    contact: {
        id: "contact",
        title: "Contact",
        icon: "✉️",
        defaultSize: { width: 560, height: 480 },
        defaultPosition: { x: 200, y: 80 },
        desktopIcon: true,
        startMenuItem: true,
    },
    terminal: {
        id: "terminal",
        title: "Terminal",
        icon: "💻",
        defaultSize: { width: 680, height: 440 },
        defaultPosition: { x: 140, y: 90 },
        desktopIcon: true,
        startMenuItem: true,
    },
    assistant: {
        id: "assistant",
        title: "DevAssistant AI",
        icon: "🤖",
        defaultSize: { width: 480, height: 560 },
        defaultPosition: { x: 240, y: 60 },
        desktopIcon: true,
        startMenuItem: true,
    },
    recruiter: {
        id: "recruiter",
        title: "Executive Summary",
        icon: "🎯",
        defaultSize: { width: 700, height: 540 },
        defaultPosition: { x: 180, y: 50 },
        desktopIcon: false,
        startMenuItem: true,
    },
};

export const ALL_WINDOW_TYPES = Object.keys(WINDOW_REGISTRY) as WindowType[];
