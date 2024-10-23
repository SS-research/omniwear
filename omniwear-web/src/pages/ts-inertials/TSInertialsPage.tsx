import { Button } from 'primereact/button';
import { DataTable, DataTablePageEvent } from 'primereact/datatable';
import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { getAllTsInertialsByDatasetId, TTsInertial } from '@/api/ts-inertial';
import { useToast } from '@/components/ToastContext';
import { Column } from 'primereact/column';
import { downloadCSV } from '@/helpers/downloadCSV';

export default function TSInertialsPage() {
    const { datasetId } = useParams();

    const navigate = useNavigate();
    const { showToast } = useToast();

    const [inertialData, setInertialData] = useState<TTsInertial[]>([]);
    const [loading, setLoading] = useState(true);
    const [totalRecords, setTotalRecords] = useState(0);
    const [limit, setLimit] = useState(6);
    const [page, setPage] = useState(1);

    useEffect(() => {
        fetchInertialData();
    }, [datasetId, limit, page]);

    const fetchInertialData = async () => {
        setLoading(true);
        const paginationOptions = { limit, page };
        try {
            const response = await getAllTsInertialsByDatasetId(datasetId!, paginationOptions);
            setInertialData(response.data);
            setTotalRecords(response.total);
            showToast({
                severity: 'info',
                summary: 'Success',
                detail: 'Inertial data fetched successfully!',
                life: 3000,
            });
        } catch (error) {
            showToast({
                severity: 'error',
                summary: 'Error',
                detail: 'Failed to fetch inertial data.',
                life: 3000,
            });
        }
        setLoading(false);
    };

    const onPageChange = (event: DataTablePageEvent) => {
        setPage(event.page! + 1);
        setLimit(event.rows);
    };

    const handleGoBack = () => {
        navigate(-1);
    };


    const paginatorLeft = (
        <div className="flex gap-2">
            <Button
                icon="pi pi-refresh"
                className="shadow"
                tooltip="Refresh"
                onClick={fetchInertialData}
            />
            {inertialData.length !== 0 && (
                <Button
                    icon="pi pi-download"
                    className="shadow"
                    tooltip="Download .csv"
                    onClick={() => {
                        downloadCSV(inertialData, 'ts-inertials.csv');
                        showToast({
                            severity: 'success',
                            summary: 'Success',
                            detail: 'Dataset .csv exported successfully',
                            life: 3000,
                        });
                    }}
                />
            )}
        </div>
    );

    return (
        <div className="relative w-full h-full overflow-y-auto scrollbar max-h-[80%]">
            <div className="absolute top-1 left-4">
                <Button
                    className="h-10 w-10 bg-primary text-white"
                    icon="pi pi-arrow-left"
                    onClick={handleGoBack}
                />
            </div>

            <h3 className="mt-1 text-center text-2xl">Inertial Data for Dataset {datasetId}</h3>
            <div className="card">
                <DataTable
                    value={inertialData}
                    paginator
                    scrollable
                    tableStyle={{
                        columnGap: '2px',
                    }}
                    resizableColumns
                    lazy
                    loading={loading}
                    totalRecords={totalRecords}
                    onPage={onPageChange}
                    paginatorLeft={paginatorLeft}
                    paginatorRight={<></>}
                    emptyMessage="No inertial data found."
                    rows={limit}
                    first={(page - 1) * limit}
                >
                    <Column
                        field="ts_inertial_id"
                        header="Inertial ID"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="session_id"
                        header="Session ID"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="timestamp"
                        header="Timestamp"
                        body={(rowData: TTsInertial) =>
                            new Date(rowData.timestamp).toLocaleString()
                        }
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="smartphone_accelerometer_x"
                        header="Accelerometer X"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="smartphone_accelerometer_y"
                        header="Accelerometer Y"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="smartphone_accelerometer_z"
                        header="Accelerometer Z"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="smartphone_gyroscope_x"
                        header="Gyroscope X"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="smartphone_gyroscope_y"
                        header="Gyroscope Y"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="smartphone_gyroscope_z"
                        header="Gyroscope Z"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="smartphone_magnometer_x"
                        header="Magnometer X"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="smartphone_magnometer_y"
                        header="Magnometer Y"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="smartphone_magnometer_z"
                        header="Magnometer Z"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="created_at"
                        header="Created At"
                        bodyClassName="text-center"
                        body={(rowData: TTsInertial) =>
                            new Date(rowData.created_at).toLocaleString()
                        }
                        sortable
                    />
                    <Column
                        field="updated_at"
                        header="Updated At"
                        bodyClassName="text-center"
                        body={(rowData: TTsInertial) =>
                            new Date(rowData.updated_at).toLocaleString()
                        }
                        sortable
                    />
                </DataTable>
            </div>
        </div>
    );
}
