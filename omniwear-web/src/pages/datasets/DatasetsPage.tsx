import { getAllDatasets, TDataset } from '@/api/dataset';
import HealthIcon from '@/components/icons/HealthIcon';
import SensorIcon from '@/components/icons/SensorIcon';
import { Button } from 'primereact/button';
import { Column } from 'primereact/column';
import { DataTable, DataTablePageEvent } from 'primereact/datatable';
import { Tag } from 'primereact/tag';
import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';

export default function DatasetsPage() {
    const [datasets, setDatasets] = useState<TDataset[]>([]);

    const [loading, setLoading] = useState(true);
    
    const [searchParams, setSearchParams] = useSearchParams();
    const navigate = useNavigate();

    const [totalRecords, setTotalRecords] = useState(0);
    const limit = parseInt(searchParams.get('limit') || '6', 10);
    const page = parseInt(searchParams.get('page') || '1', 10);

    useEffect(() => {
        fetchDatasets();
    }, [limit, page]);

    const fetchDatasets = async () => {
        setLoading(true);
        const paginationOptions = { limit, page };
        const response = await getAllDatasets(paginationOptions);
        setDatasets(response.data);
        setTotalRecords(response.total);
        setLoading(false);
    };

    const onPageChange = (event: DataTablePageEvent) => {
        const newPage = event.page! + 1;
        const newLimit = event.rows;

        setSearchParams({ page: newPage.toString(), limit: newLimit.toString() });
    };


    const convertToCSV = (data: TDataset[]) => {
        const headers = [
            'Dataset ID',
            'Inertial Collection Frequency',
            'Inertial Collection Duration Seconds',
            'Inertial Sleep Duration Seconds',
            'Inertial Features',
            'Health Features',
            'Health Reading Frequency',
            'Health Reading Interval',
            'Storage Option',
            'Created At',
            'Updated At',
        ];

        const rows = data.map((dataset) => [
            dataset.dataset_id,
            dataset.inertial_collection_frequency,
            dataset.inertial_collection_duration_seconds,
            dataset.inertial_sleep_duration_seconds,
            dataset.inertial_features,
            dataset.health_features,
            dataset.health_reading_frequency,
            dataset.health_reading_interval,
            dataset.storage_option,
            dataset.created_at,
            dataset.updated_at,
        ]);

        const csvContent = [headers.join(','), ...rows.map((row) => row.join(','))].join('\n');

        return csvContent;
    };

    const downloadCSV = () => {
        const csvData = convertToCSV(datasets);
        const blob = new Blob([csvData], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        const url = URL.createObjectURL(blob);

        link.href = url;
        link.setAttribute('download', 'datasets.csv');
        link.click();

        URL.revokeObjectURL(url); // Clean up the URL object
    };

    const paginatorLeft = (
        <div className="flex gap-2">
            <Button
                icon="pi pi-refresh"
                className="shadow"
                tooltip="Refresh"
                onClick={fetchDatasets}
            />
            <Button icon="pi pi-download" className="shadow" tooltip="Download .csv" onClick={downloadCSV}/>
        </div>
    );
    const paginatorRight = (
        <Button
            icon="pi pi-plus"
            className="shadow bg-primary"
            tooltip="Create a new dataset"
            tooltipOptions={{ position: 'left' }}
        />
    );

    return (
        <div className="w-full h-full overflow-y-auto scrollbar max-h-[80%]">
            <h2 className="mt-1 text-center text-2xl">Datasets</h2>
            <div className="card">
                <DataTable
                    value={datasets}
                    scrollable
                    tableStyle={{
                        columnGap: '2px',
                    }}
                    width={30}
                    first={(page - 1) * limit}
                    resizableColumns
                    paginator
                    totalRecords={totalRecords}
                    lazy
                    loading={loading}
                    onPage={onPageChange}
                    emptyMessage="No datasets found."
                    paginatorRight={paginatorRight}
                    paginatorLeft={paginatorLeft}
                    rows={limit}
                >
                    <Column field="dataset_id" header="Dataset ID" sortable />

                    <Column
                        field="inertial_collection_frequency"
                        header="Inertial Collection Frequency"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="inertial_collection_duration_seconds"
                        header="Inertial Collection Duration Seconds"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="inertial_sleep_duration_seconds"
                        header="Inertial Sleep Duration Seconds"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="inertial_features"
                        header="Inertial Features"
                        bodyClassName="text-center"
                        sortable
                    />

                    <Column
                        field="health_features"
                        header="Health Features"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="health_reading_frequency"
                        header="Health Reading Frequency"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="health_reading_interval"
                        header="Health Reading Interval"
                        bodyClassName="text-center"
                        sortable
                    />

                    <Column
                        field="storage_option"
                        header="Storage Option"
                        bodyClassName="text-center"
                        sortable
                        body={(dataset: TDataset) => (
                            <Tag
                                value={dataset.storage_option}
                                className={`px-3 py-1 text-xs font-semibold rounded ${dataset.storage_option === 'REMOTE' ? 'bg-primary' : 'bg-secondary'}`}
                            />
                        )}
                    />

                    <Column
                        field="created_at"
                        header="Created At"
                        bodyClassName="text-center"
                        sortable
                    />
                    <Column
                        field="updated_at"
                        header="Updated At"
                        bodyClassName="text-center"
                        sortable
                    />

                    <Column
                        bodyStyle={{ minWidth: '18rem' }}
                        body={(dataset: TDataset) => (
                            <div className="flex gap-2 items-center justify-center">
                                {dataset.storage_option === 'REMOTE' &&
                                    dataset.inertial_features.trim() !== '' && (
                                        <Button
                                            icon={<SensorIcon />}
                                            tooltip="Inspect inertial data"
                                            tooltipOptions={{ position: 'bottom' }}
                                            severity="danger"
                                            className="shadow"
                                            onClick={() => navigate(`/dataset/${dataset.dataset_id}/ts-inertial`)}
                                        />
                                    )}
                                {dataset.storage_option === 'REMOTE' &&
                                    dataset.health_features.trim() !== '' && (
                                        <Button
                                            icon={<HealthIcon />}
                                            tooltip="Inspect health data"
                                            tooltipOptions={{ position: 'bottom' }}
                                            severity="danger"
                                            className="shadow"
                                            onClick={() => navigate(`/dataset/${dataset.dataset_id}/ts-health`)}
                                        />
                                    )}
                                <Button
                                    icon="pi pi-trash"
                                    severity="danger"
                                    className="shadow"
                                    tooltip="Delete"
                                    tooltipOptions={{ position: 'bottom' }}
                                    onClick={() => console.log('TO IMPLEMENT')}
                                />
                            </div>
                        )}
                        bodyClassName="text-center"
                    />
                </DataTable>
            </div>
        </div>
    );
}
