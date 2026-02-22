'use client';

import React, { useState, useRef, useEffect, KeyboardEvent } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';

interface TerminalLine {
    type: 'input' | 'output';
    content: string;
}

export default function TerminalWindow() {
    const { t } = useLanguage();
    const tt = t.terminal;

    const [lines, setLines] = useState<TerminalLine[]>([
        { type: 'output', content: tt.welcome },
        { type: 'output', content: tt.helpHint },
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

        const commands = tt.commands as Record<string, string>;
        const output = commands[trimmed];
        if (output) {
            newLines.push({ type: 'output', content: output });
        } else if (trimmed) {
            newLines.push({ type: 'output', content: tt.notFound(trimmed) });
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
