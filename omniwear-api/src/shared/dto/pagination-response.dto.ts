import { IsInt, IsNotEmpty } from 'class-validator';

export type TPaginationResponseDto<T> = {
  data: T[];
  total: number;
  page: number;
  lastPage: number;
};

export class PaginationResponseDto<T> {
  @IsNotEmpty()
  data: T[];

  @IsInt()
  total: number;

  @IsInt()
  page: number;

  @IsInt()
  lastPage: number;

  constructor(options: TPaginationResponseDto<T>) {
    this.data = options.data;
    this.total = options.total;
    this.page = options.page;
    this.lastPage = options.lastPage;
  }
}
