'use client';

import { WindowManagerProvider } from '@/contexts/WindowManager';
import Desktop from '@/components/Desktop';

export default function Home() {
  return (
    <WindowManagerProvider>
      <Desktop />
    </WindowManagerProvider>
  );
}
