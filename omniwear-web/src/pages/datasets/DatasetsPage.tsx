import { getAllDatasets, TDataset } from '@/api/dataset';
import HealthIcon from '@/components/icons/HealthIcon';
import SensorIcon from '@/components/icons/SensorIcon';
import { Button } from 'primereact/button';
import { Column } from 'primereact/column';
import { DataTable } from 'primereact/datatable';
import { Tag } from 'primereact/tag';
import { useEffect, useState } from 'react';

export default function DatasetsPage() {
    const [datasets, setDatasets] = useState<TDataset[]>([]);

    useEffect(() => {
        if (datasets.length === 0) {
            getAllDatasets().then((data) => setDatasets(data));
        }
    }, []);

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
                onClick={() => getAllDatasets().then((data) => setDatasets(data))}
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
                    resizableColumns
                    paginator
                    emptyMessage="No datasets found."
                    paginatorRight={paginatorRight}
                    paginatorLeft={paginatorLeft}
                    rows={6}
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
                                            onClick={() => console.log('TO IMPLEMENT')}
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
                                            onClick={() => console.log('TO IMPLEMENT')}
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
