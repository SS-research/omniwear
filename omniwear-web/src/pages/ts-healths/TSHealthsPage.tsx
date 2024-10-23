import { Button } from 'primereact/button';
import { DataTable, DataTablePageEvent } from 'primereact/datatable';
import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { getAllTsHealthsByDatasetId, TTsHealth } from '@/api/ts-health';
import { useToast } from '@/components/ToastContext';
import { Column } from 'primereact/column';
import { downloadCSV } from '@/helpers/downloadCSV';

export default function TSHealthsPage() {
    const { datasetId } = useParams();
    const navigate = useNavigate();
    const { showToast } = useToast();

    const [healthData, setHealthData] = useState<TTsHealth[]>([]);
    const [loading, setLoading] = useState(true);
    const [totalRecords, setTotalRecords] = useState(0);
    const [limit, setLimit] = useState(6);
    const [page, setPage] = useState(1);

    useEffect(() => {
        fetchHealthData();
    }, [datasetId, limit, page]);

    const fetchHealthData = async () => {
        setLoading(true);
        const paginationOptions = { limit, page };
        try {
            const response = await getAllTsHealthsByDatasetId(datasetId!, paginationOptions);
            setHealthData(response.data);
            setTotalRecords(response.total);
            showToast({
                severity: 'info',
                summary: 'Success',
                detail: 'Health data fetched successfully!',
                life: 3000,
            });
        } catch (error) {
            showToast({
                severity: 'error',
                summary: 'Error',
                detail: 'Failed to fetch health data.',
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
                onClick={fetchHealthData}
            />
            {healthData.length !== 0 && (
                <Button
                    icon="pi pi-download"
                    className="shadow"
                    tooltip="Download .csv"
                    onClick={() => {
                        downloadCSV(healthData, 'ts-healths.csv');
                        showToast({
                            severity: 'success',
                            summary: 'Success',
                            detail: 'Health data .csv exported successfully',
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

            <h3 className="mt-1 text-center text-2xl">Health Data for Dataset {datasetId}</h3>
            <div className="card">
                <DataTable
                    value={healthData}
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
                    emptyMessage="No health data found."
                    rows={limit}
                    first={(page - 1) * limit}
                >
                    <Column
                        field="ts_health_id"
                        header="Health ID"
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
                        field="start_timestamp"
                        header="Start Timestamp"
                        body={(rowData: TTsHealth) => new Date(rowData.start_timestamp).toLocaleString()}
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="end_timestamp"
                        header="End Timestamp"
                        body={(rowData: TTsHealth) => new Date(rowData.end_timestamp).toLocaleString()}
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="heart_rate"
                        header="Heart Rate"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="blood_pressure"
                        header="Blood Pressure"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="temperature"
                        header="Temperature"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="created_at"
                        header="Created At"
                        bodyClassName="text-center"
                        body={(rowData: TTsHealth) => new Date(rowData.created_at).toLocaleString()}
                        sortable
                    />
                    <Column
                        field="updated_at"
                        header="Updated At"
                        bodyClassName="text-center"
                        body={(rowData: TTsHealth) => new Date(rowData.updated_at).toLocaleString()}
                        sortable
                    />
                </DataTable>
            </div>
        </div>
    );
}
