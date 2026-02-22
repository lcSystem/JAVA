'use client';

import React, { createContext, useContext, ReactNode } from 'react';
import { translations, Locale } from '@/data/translations';

// Use a loose type for translations so EN and ES are compatible
type Translations = (typeof translations)[Locale];

interface LanguageContextType {
    locale: Locale;
    t: Translations;
}

const LanguageContext = createContext<LanguageContextType | null>(null);

export function LanguageProvider({ locale, children }: { locale: Locale; children: ReactNode }) {
    const t = translations[locale] as Translations;

    return (
        <LanguageContext.Provider value={{ locale, t }}>
            {children}
        </LanguageContext.Provider>
    );
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function useLanguage(): { locale: Locale; t: any } {
    const ctx = useContext(LanguageContext);
    if (!ctx) throw new Error('useLanguage must be used within LanguageProvider');
    return ctx;
}
