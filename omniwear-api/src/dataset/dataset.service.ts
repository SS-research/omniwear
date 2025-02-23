import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateDatasetDto } from './dto/create-dataset.dto';
import { UpdateDatasetDto } from './dto/update-dataset.dto';
import { PrismaService } from '@app/prisma/prisma.service';
import { PaginationOptionsDto, PaginationResponseDto } from '@app/shared/dto';
import { Dataset } from '@prisma/client';

@Injectable()
export class DatasetService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createDatasetDto: CreateDatasetDto) {
    return await this.prisma.dataset.create({ data: createDatasetDto });
  }

  async findAll(paginationOptions: PaginationOptionsDto) {
    const { limit, page } = paginationOptions;
    const skip = (page - 1) * limit;

    const [result, total] = await this.prisma.$transaction([
      this.prisma.dataset.findMany({
        take: limit,
        skip,
      }),
      this.prisma.dataset.count(),
    ]);

    return new PaginationResponseDto<Dataset>({
      data: result,
      total,
      page,
      lastPage: Math.ceil(total / limit),
    });
  }

  async findOne(dataset_id: string) {
    const dataset = await this.prisma.dataset.findUnique({
      where: { dataset_id },
    });

    if (!dataset) {
      throw new NotFoundException(`Dataset with ID: ${dataset_id} not found`);
    }

    return dataset;
  }

  async update(dataset_id: string, updateDatasetDto: UpdateDatasetDto) {
    await this.findOne(dataset_id);

    return await this.prisma.dataset.update({
      where: { dataset_id },
      data: updateDatasetDto,
    });
  }

  async remove(dataset_id: string) {
    await this.findOne(dataset_id);
    return this.prisma.dataset.delete({ where: { dataset_id } });
  }
}
