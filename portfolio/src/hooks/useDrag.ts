'use client';

import { useState, useCallback, useRef, useEffect } from 'react';

interface UseDragOptions {
    initialPosition: { x: number; y: number };
    onDragEnd?: (position: { x: number; y: number }) => void;
    disabled?: boolean;
}

export function useDrag({ initialPosition, onDragEnd, disabled }: UseDragOptions) {
    const [position, setPosition] = useState(initialPosition);
    const [isDragging, setIsDragging] = useState(false);
    const dragRef = useRef<{ startX: number; startY: number; startPosX: number; startPosY: number } | null>(null);

    useEffect(() => {
        setPosition(initialPosition);
    }, [initialPosition.x, initialPosition.y]);

    const onMouseDown = useCallback((e: React.MouseEvent) => {
        if (disabled) return;
        e.preventDefault();
        dragRef.current = {
            startX: e.clientX,
            startY: e.clientY,
            startPosX: position.x,
            startPosY: position.y,
        };
        setIsDragging(true);
    }, [position, disabled]);

    useEffect(() => {
        if (!isDragging) return;

        const onMouseMove = (e: MouseEvent) => {
            if (!dragRef.current) return;
            const dx = e.clientX - dragRef.current.startX;
            const dy = e.clientY - dragRef.current.startY;
            const newX = Math.max(0, Math.min(window.innerWidth - 100, dragRef.current.startPosX + dx));
            const newY = Math.max(0, Math.min(window.innerHeight - 100, dragRef.current.startPosY + dy));
            setPosition({ x: newX, y: newY });
        };

        const onMouseUp = () => {
            setIsDragging(false);
            if (dragRef.current) {
                onDragEnd?.(position);
            }
            dragRef.current = null;
        };

        window.addEventListener('mousemove', onMouseMove);
        window.addEventListener('mouseup', onMouseUp);
        return () => {
            window.removeEventListener('mousemove', onMouseMove);
            window.removeEventListener('mouseup', onMouseUp);
        };
    }, [isDragging, onDragEnd, position]);

    return { position, isDragging, onMouseDown };
}
