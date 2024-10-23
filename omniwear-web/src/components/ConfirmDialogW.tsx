import { ConfirmDialog } from 'primereact/confirmdialog';
import { ReactNode } from 'react';

type ConfirmationDialogProps = {
    visible: boolean;
    message: string | ReactNode;
    header: string;
    icon?: string;
    onAccept: () => void;
    onReject: () => void;
};

export default function ConfirmDialogW({
    visible,
    message,
    header,
    icon = "pi pi-exclamation-triangle",
    onAccept,
    onReject,
}: ConfirmationDialogProps) {
    return (
        <ConfirmDialog
            visible={visible}
            className="justify-end"
            onHide={onReject}
            message={message}
            header={header}
            icon={icon}
            accept={onAccept}
            reject={onReject}
            pt={{
                footer: {
                    className: 'flex justify-end gap-3',
                },
            }}
        />
    );
}