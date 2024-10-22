import { CreateDatasetDto, TDataset, UpdateDatasetDto } from './types';
import { RequestMethod, apiRequest } from '../apiRequest';
import { TPaginationOptionsDto, TPaginationResponseDto } from '../pagination';

const ENDPOINT = 'dataset';

export const createDataset = async (datasetData: CreateDatasetDto) => {
    return apiRequest<CreateDatasetDto, TDataset>(RequestMethod.POST, ENDPOINT, datasetData);
};

export const getAllDatasets = async (paginationOptionsDto: TPaginationOptionsDto): Promise<TPaginationResponseDto<TDataset>> => {
    return apiRequest<void, TPaginationResponseDto<TDataset>>(RequestMethod.GET, `${ENDPOINT}?limit=${paginationOptionsDto.limit}&page=${paginationOptionsDto.page}`);
};

export const getDatasetById = async (datasetId: string) => {
    return apiRequest<void, TDataset>(RequestMethod.GET, `${ENDPOINT}/${datasetId}`);
};

export const updateDataset = async (datasetId: string, datasetData: UpdateDatasetDto) => {
    return apiRequest<UpdateDatasetDto, UpdateDatasetDto>(RequestMethod.PATCH, `${ENDPOINT}/${datasetId}`, datasetData);
};

export const deleteDataset = async (datasetId: string) => {
    return apiRequest<void, void>(RequestMethod.DELETE, `${ENDPOINT}/${datasetId}`);
};