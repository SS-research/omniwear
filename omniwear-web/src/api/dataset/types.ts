
type CreateDatasetDto = {
    inertial_collection_frequency: string;
    inertial_collection_duration_seconds: string;
    inertial_sleep_duration_seconds: string;
    inertial_features: string;

    health_features: string;
    health_reading_frequency: string;
    health_reading_interval: string;

    storage_option: "REMOTE" | "LOCAL";
}

type UpdateDatasetDto = Partial<CreateDatasetDto> & {}

type TDataset = CreateDatasetDto & {
    dataset_id: string;
    created_at: Date;
    updated_at: Date;
}

export type {
    CreateDatasetDto,
    UpdateDatasetDto,
    TDataset
}