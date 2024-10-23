import StorageOptionEnum from "./storage_option_enum";

type CreateDatasetDto = {
    inertial_collection_frequency: number;
    inertial_collection_duration_seconds: number;
    inertial_sleep_duration_seconds: number;
    inertial_features: string;

    health_features: string;
    health_reading_frequency: number;
    health_reading_interval: number;

    storage_option: StorageOptionEnum;
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