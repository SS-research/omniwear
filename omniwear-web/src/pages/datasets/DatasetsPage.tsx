import { createDataset, getAllDatasets, TDataset } from '@/api/dataset';
import HealthIcon from '@/components/icons/HealthIcon';
import SensorIcon from '@/components/icons/SensorIcon';
import { useToast } from '@/components/ToastContext';
import { downloadCSV } from '@/helpers/downloadCSV';
import { Button } from 'primereact/button';
import { Column } from 'primereact/column';
import { DataTable, DataTablePageEvent } from 'primereact/datatable';
import { Tag } from 'primereact/tag';
import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import CreateDatasetDialogForm from './components/CreateDatasetDialogForm';
import StorageOptionEnum from '@/api/dataset/storage_option_enum';

export default function DatasetsPage() {
    const [datasets, setDatasets] = useState<TDataset[]>([]);

    const [loading, setLoading] = useState(true);

    const [searchParams, setSearchParams] = useSearchParams();
    const navigate = useNavigate();

    const [totalRecords, setTotalRecords] = useState(0);
    const limit = parseInt(searchParams.get('limit') || '6', 10);
    const page = parseInt(searchParams.get('page') || '1', 10);

    const { showToast } = useToast();

    useEffect(() => {
        fetchDatasets();
    }, [limit, page]);

    const fetchDatasets = async () => {
        setLoading(true);
        const paginationOptions = { limit, page };
        try {
            const response = await getAllDatasets(paginationOptions);
            setDatasets(response.data);
            setTotalRecords(response.total);
            showToast({
                severity: 'info',
                summary: 'Success',
                detail: 'Datasets have been fetched successfully!',
                life: 3000,
            });
        } catch (error) {
            showToast({
                severity: 'error',
                summary: 'Error',
                detail: 'Failed to fetch datasets.',
                life: 3000,
            });
        }
        setLoading(false);
    };

    const onPageChange = (event: DataTablePageEvent) => {
        const newPage = event.page! + 1;
        const newLimit = event.rows;
        setSearchParams({ page: newPage.toString(), limit: newLimit.toString() });
    };

    const paginatorLeft = (
        <div className="flex gap-2">
            <Button
                icon="pi pi-refresh"
                className="shadow"
                tooltip="Refresh"
                onClick={fetchDatasets}
            />
            {datasets.length !== 0 && (
                <Button
                    icon="pi pi-download"
                    className="shadow"
                    tooltip="Download .csv"
                    onClick={() => {
                        downloadCSV(datasets, 'dataset.csv');
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
    const paginatorRight = (
        // <Button
        //     icon="pi pi-plus"
        //     className="shadow bg-primary text-white"
        //     tooltip="Create a new dataset"
        //     tooltipOptions={{ position: 'left' }}
        // />
        <CreateDatasetDialogForm onSubmit={createDataset} />
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
                    />
                    <Column
                        field="inertial_collection_duration_seconds"
                        header="Inertial Collection Duration Seconds"
                        bodyClassName="text-center"
                    />
                    <Column
                        field="inertial_sleep_duration_seconds"
                        header="Inertial Sleep Duration Seconds"
                        bodyClassName="text-center"
                    />
                    <Column
                        field="inertial_features"
                        header="Inertial Features"
                        bodyClassName="text-center"
                    />

                    <Column
                        field="health_features"
                        header="Health Features"
                        bodyClassName="text-center"
                    />
                    <Column
                        field="health_reading_frequency"
                        header="Health Reading Frequency"
                        bodyClassName="text-center"
                    />
                    <Column
                        field="health_reading_interval"
                        header="Health Reading Interval"
                        bodyClassName="text-center"
                    />

                    <Column
                        field="storage_option"
                        header="Storage Option"
                        bodyClassName="text-center"
                        body={(dataset: TDataset) => (
                            <Tag
                                value={dataset.storage_option}
                                className={`px-3 py-1 text-xs font-semibold rounded ${dataset.storage_option === StorageOptionEnum.REMOTE ? 'bg-primary' : 'bg-secondary'}`}
                            />
                        )}
                    />

                    <Column
                        field="created_at"
                        header="Created At"
                        bodyClassName="text-center"
                    />
                    <Column
                        field="updated_at"
                        header="Updated At"
                        bodyClassName="text-center"
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
                                            onClick={() =>
                                                navigate(
                                                    `/ts-inertial/dataset/${dataset.dataset_id}`
                                                )
                                            }
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
                                            onClick={() =>
                                                navigate(`/ts-health/dataset/${dataset.dataset_id}`)
                                            }
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
