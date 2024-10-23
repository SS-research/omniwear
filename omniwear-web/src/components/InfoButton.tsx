import { Button } from 'primereact/button';
import { OverlayPanel } from 'primereact/overlaypanel';
import { useRef, ReactNode } from 'react';

interface InfoButtonProps {
    content: ReactNode;
}

export function InfoButton({ content }: InfoButtonProps) {
    const overlayRef = useRef<OverlayPanel | null>(null);

    return (
        <>
            <Button
                icon="pi pi-info-circle"
                className="shadow w-6 h-6"
                onClick={(e) => overlayRef.current?.toggle(e)}
            />
            <OverlayPanel ref={overlayRef} className="p-3">
                <div className='w-72 max-h-40 overflow-y-auto scrollbar text-pretty'>  
                    {content}
                </div>
            </OverlayPanel>
        </>
    );
}