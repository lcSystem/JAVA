'use client';

import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Locale } from '@/data/translations';

interface LanguageSelectorProps {
    onSelect: (locale: Locale) => void;
}

export default function LanguageSelector({ onSelect }: LanguageSelectorProps) {
    const [exiting, setExiting] = useState(false);
    const [selected, setSelected] = useState<Locale | null>(null);

    const handleSelect = (locale: Locale) => {
        setSelected(locale);
        setExiting(true);
        setTimeout(() => onSelect(locale), 600);
    };

    return (
        <AnimatePresence>
            {!exiting ? (
                <motion.div
                    key="selector"
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    exit={{ opacity: 0, scale: 1.05 }}
                    transition={{ duration: 0.5 }}
                    style={{
                        position: 'fixed',
                        inset: 0,
                        zIndex: 99999,
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        flexDirection: 'column',
                        overflow: 'hidden',
                    }}
                >
                    {/* Background image */}
                    <div
                        style={{
                            position: 'absolute',
                            inset: 0,
                            backgroundImage: 'url(/bg.png)',
                            backgroundSize: 'cover',
                            backgroundPosition: 'center',
                            filter: 'blur(6px) brightness(0.35)',
                            transform: 'scale(1.05)',
                        }}
                    />

                    {/* Overlay gradient */}
                    <div
                        style={{
                            position: 'absolute',
                            inset: 0,
                            background: 'radial-gradient(ellipse at center, rgba(0,120,212,0.08) 0%, rgba(0,0,0,0.5) 100%)',
                        }}
                    />

                    {/* Content */}
                    <motion.div
                        initial={{ opacity: 0, y: 30 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.6, delay: 0.2 }}
                        style={{
                            position: 'relative',
                            zIndex: 1,
                            display: 'flex',
                            flexDirection: 'column',
                            alignItems: 'center',
                            gap: 12,
                        }}
                    >
                        {/* Avatar */}
                        <motion.div
                            initial={{ scale: 0.8, opacity: 0 }}
                            animate={{ scale: 1, opacity: 1 }}
                            transition={{ duration: 0.5, delay: 0.3 }}
                            style={{
                                width: 100,
                                height: 100,
                                borderRadius: '50%',
                                overflow: 'hidden',
                                border: '3px solid rgba(0,120,212,0.5)',
                                boxShadow: '0 0 40px rgba(0,120,212,0.3), 0 8px 32px rgba(0,0,0,0.4)',
                                marginBottom: 8,
                            }}
                        >
                            <img
                                src="/profile.jpeg"
                                alt="Luigis"
                                style={{
                                    width: '100%',
                                    height: '100%',
                                    objectFit: 'cover',
                                    objectPosition: 'center',
                                }}
                            />
                        </motion.div>

                        {/* Title */}
                        <motion.h1
                            initial={{ opacity: 0, y: 10 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ duration: 0.5, delay: 0.4 }}
                            style={{
                                fontSize: 28,
                                fontWeight: 700,
                                color: '#ffffff',
                                textAlign: 'center',
                                margin: 0,
                                textShadow: '0 2px 12px rgba(0,0,0,0.5)',
                                fontFamily: "'Segoe UI', system-ui, -apple-system, sans-serif",
                            }}
                        >
                            Luigis
                        </motion.h1>

                        <motion.p
                            initial={{ opacity: 0, y: 10 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ duration: 0.5, delay: 0.5 }}
                            style={{
                                fontSize: 14,
                                color: 'rgba(255,255,255,0.6)',
                                textAlign: 'center',
                                margin: 0,
                                marginBottom: 32,
                                fontFamily: "'Segoe UI', system-ui, sans-serif",
                            }}
                        >
                            Java Backend Developer
                        </motion.p>

                        {/* Language buttons */}
                        <motion.div
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ duration: 0.5, delay: 0.6 }}
                            style={{
                                display: 'flex',
                                gap: 20,
                            }}
                        >
                            <LanguageButton
                                flag="🇺🇸"
                                label="English"
                                sublabel="View in English"
                                selected={selected === 'en'}
                                onClick={() => handleSelect('en')}
                                delay={0.7}
                            />
                            <LanguageButton
                                flag="🇪🇸"
                                label="Español"
                                sublabel="Ver en Español"
                                selected={selected === 'es'}
                                onClick={() => handleSelect('es')}
                                delay={0.8}
                            />
                        </motion.div>
                    </motion.div>

                    {/* Bottom hint */}
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        transition={{ duration: 0.5, delay: 1.2 }}
                        style={{
                            position: 'absolute',
                            bottom: 40,
                            fontSize: 11,
                            color: 'rgba(255,255,255,0.3)',
                            fontFamily: "'Segoe UI', system-ui, sans-serif",
                            letterSpacing: 1,
                            textTransform: 'uppercase',
                        }}
                    >
                        Select your language to continue
                    </motion.div>
                </motion.div>
            ) : (
                <motion.div
                    key="exiting"
                    initial={{ opacity: 1 }}
                    animate={{ opacity: 0 }}
                    transition={{ duration: 0.5 }}
                    style={{
                        position: 'fixed',
                        inset: 0,
                        zIndex: 99999,
                        background: '#0a0a1a',
                    }}
                />
            )}
        </AnimatePresence>
    );
}

function LanguageButton({
    flag,
    label,
    sublabel,
    selected,
    onClick,
    delay,
}: {
    flag: string;
    label: string;
    sublabel: string;
    selected: boolean;
    onClick: () => void;
    delay: number;
}) {
    return (
        <motion.button
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.4, delay }}
            whileHover={{ scale: 1.05, y: -2 }}
            whileTap={{ scale: 0.97 }}
            onClick={onClick}
            style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                gap: 8,
                padding: '24px 40px',
                background: selected
                    ? 'rgba(0,120,212,0.25)'
                    : 'rgba(255,255,255,0.06)',
                backdropFilter: 'blur(20px)',
                border: selected
                    ? '1px solid rgba(0,120,212,0.6)'
                    : '1px solid rgba(255,255,255,0.1)',
                borderRadius: 16,
                cursor: 'pointer',
                transition: 'all 0.25s ease',
                boxShadow: selected
                    ? '0 0 30px rgba(0,120,212,0.2), 0 8px 32px rgba(0,0,0,0.3)'
                    : '0 4px 24px rgba(0,0,0,0.3)',
                color: '#ffffff',
                minWidth: 160,
            }}
        >
            <span style={{ fontSize: 40 }}>{flag}</span>
            <span style={{
                fontSize: 16,
                fontWeight: 600,
                fontFamily: "'Segoe UI', system-ui, sans-serif",
            }}>
                {label}
            </span>
            <span style={{
                fontSize: 11,
                color: 'rgba(255,255,255,0.45)',
                fontFamily: "'Segoe UI', system-ui, sans-serif",
            }}>
                {sublabel}
            </span>
        </motion.button>
    );
}
