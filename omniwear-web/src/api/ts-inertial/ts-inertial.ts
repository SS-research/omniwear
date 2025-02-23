import { CreateTsInertialDto, TTsInertial, UpdateTsInertialDto } from './types';
import { RequestMethod, apiRequest } from '../apiRequest';
import { TPaginationOptionsDto, TPaginationResponseDto } from '../pagination';

const ENDPOINT = 'ts-inertial';

export const createTsInertial = async (tsInertialData: CreateTsInertialDto) => {
    return apiRequest<CreateTsInertialDto, TTsInertial>(RequestMethod.POST, ENDPOINT, tsInertialData);
};

export const getAllTsInertials = async (paginationOptionsDto: TPaginationOptionsDto): Promise<TPaginationResponseDto<TTsInertial>> => {
    return apiRequest<void, TPaginationResponseDto<TTsInertial>>(RequestMethod.GET, `${ENDPOINT}?limit=${paginationOptionsDto.limit}&page=${paginationOptionsDto.page}`);
};

export const getAllTsInertialsByDatasetId = async (datasetId: string, paginationOptionsDto: TPaginationOptionsDto): Promise<TPaginationResponseDto<TTsInertial>> => {
    return apiRequest<void, TPaginationResponseDto<TTsInertial>>(RequestMethod.GET, `${ENDPOINT}/dataset/${datasetId}?limit=${paginationOptionsDto.limit}&page=${paginationOptionsDto.page}`);
}

export const getTsInertialById = async (tsInertialId: string) => {
    return apiRequest<void, TTsInertial>(RequestMethod.GET, `${ENDPOINT}/${tsInertialId}`);
};

export const updateTsInertial = async (tsInertialId: string, tsInertialData: UpdateTsInertialDto) => {
    return apiRequest<UpdateTsInertialDto, UpdateTsInertialDto>(RequestMethod.PATCH, `${ENDPOINT}/${tsInertialId}`, tsInertialData);
};

export const deleteTsInertial = async (tsInertialId: string) => {
    return apiRequest<void, void>(RequestMethod.DELETE, `${ENDPOINT}/${tsInertialId}`);
};
