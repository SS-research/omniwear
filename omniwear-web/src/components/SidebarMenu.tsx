import { Sidebar } from 'primereact/sidebar';
import { Menu } from 'primereact/menu';
import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import { Button } from 'primereact/button';

export default function SidebarMenu() {
    const [visible, setVisible] = useState(false);
    const navigate = useNavigate();

    const menuItems = [
        {
            label: 'Home',
            items: [
                {
                    label: 'Datasets',
                    icon: 'pi pi-database',
                    command: () => {
                        navigate('/dataset');
                    },
                },
                {
                    label: 'Logout',
                    icon: 'pi pi-sign-out',
                    command: () => {
                        navigate('/login');
                    },
                },
            ],
        },
    ];

    return (
        <>
            <Sidebar visible={visible} onHide={() => setVisible(false)}>
                <div className="flex flex-col gap-3">
                    <h2 className="text-center font-bold">Menu</h2>
                    <Menu model={menuItems} className="w-full min-w-full" />
                </div>
            </Sidebar>

            {/* Button to toggle the sidebar */}
            <Button
                icon="pi pi-bars"
                className="shadow rounded-sm"
                size="large"
                onClick={() => setVisible(true)}
            />
        </>
    );
}
