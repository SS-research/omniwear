import { CreateTsHealthDto, TTsHealth, UpdateTsHealthDto } from './types';
import { RequestMethod, apiRequest } from '../apiRequest';
import { TPaginationOptionsDto, TPaginationResponseDto } from '../pagination';

const ENDPOINT = 'ts-health';

export const createTsHealth = async (tsHealthData: CreateTsHealthDto) => {
    return apiRequest<CreateTsHealthDto, TTsHealth>(RequestMethod.POST, ENDPOINT, tsHealthData);
};

export const getAllTsHealths = async (paginationOptionsDto: TPaginationOptionsDto): Promise<TPaginationResponseDto<TTsHealth>> => {
    return apiRequest<void, TPaginationResponseDto<TTsHealth>>(RequestMethod.GET, `${ENDPOINT}?limit=${paginationOptionsDto.limit}&page=${paginationOptionsDto.page}`);
};

export const getAllTsHealthsByDatasetId = async (datasetId: string, paginationOptionsDto: TPaginationOptionsDto): Promise<TPaginationResponseDto<TTsHealth>> => {
    return apiRequest<void, TPaginationResponseDto<TTsHealth>>(RequestMethod.GET, `${ENDPOINT}/dataset/${datasetId}?limit=${paginationOptionsDto.limit}&page=${paginationOptionsDto.page}`);
};

export const getTsHealthById = async (tsHealthId: string) => {
    return apiRequest<void, TTsHealth>(RequestMethod.GET, `${ENDPOINT}/${tsHealthId}`);
};

export const updateTsHealth = async (tsHealthId: string, tsHealthData: UpdateTsHealthDto) => {
    return apiRequest<UpdateTsHealthDto, UpdateTsHealthDto>(RequestMethod.PATCH, `${ENDPOINT}/${tsHealthId}`, tsHealthData);
};

export const deleteTsHealth = async (tsHealthId: string) => {
    return apiRequest<void, void>(RequestMethod.DELETE, `${ENDPOINT}/${tsHealthId}`);
};
