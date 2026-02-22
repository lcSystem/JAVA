'use client';

import React, { useState } from 'react';
import { WindowManagerProvider } from '@/contexts/WindowManager';
import { LanguageProvider } from '@/contexts/LanguageContext';
import Desktop from '@/components/Desktop';
import LanguageSelector from '@/components/LanguageSelector';
import { Locale } from '@/data/translations';

export default function Home() {
  const [locale, setLocale] = useState<Locale | null>(null);

  if (!locale) {
    return <LanguageSelector onSelect={setLocale} />;
  }

  return (
    <LanguageProvider locale={locale}>
      <WindowManagerProvider>
        <Desktop />
      </WindowManagerProvider>
    </LanguageProvider>
  );
}
