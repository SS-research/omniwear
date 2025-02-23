
type TPaginationOptionsDto = {
    limit: number;
    page: number;
}

type TPaginationResponseDto<T> = {
    data: T[];
    total: number;
    page: number;
    lastPage: number;
};

export type {
    TPaginationOptionsDto,
    TPaginationResponseDto
}