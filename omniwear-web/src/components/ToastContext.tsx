import { createContext, useContext, useRef } from 'react';
import { Toast, ToastMessage } from 'primereact/toast';

interface ToastContextProps {
    showToast: (message: ToastMessage) => void;
}

const ToastContext = createContext<ToastContextProps | undefined>(undefined);

export const ToastProvider = ({ children }: { children: React.ReactNode }) => {
    const toast = useRef<Toast>(null);

    const showToast = (message: ToastMessage) => {
        toast.current?.show(message);
    };

    return (
        <ToastContext.Provider value={{ showToast }}>
            {children}
            <Toast ref={toast} />
        </ToastContext.Provider>
    );
};

export const useToast = (): ToastContextProps => {
    const context = useContext(ToastContext);
    if (!context) {
        throw new Error('useToast must be used within a ToastProvider');
    }
    return context;
};
