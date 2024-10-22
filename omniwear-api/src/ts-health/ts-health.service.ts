import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '@app/prisma/prisma.service';
import { CreateTsHealthDto } from './dto/create-ts-health.dto';
import { UpdateTsHealthDto } from './dto/update-ts-health.dto';
import { CreateManyTsHealthDto } from './dto/create-many-ts-health.dto';
import { PaginationOptionsDto, PaginationResponseDto } from '@app/shared/dto';
import { TSHealth } from '@prisma/client';

@Injectable()
export class TsHealthService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createTsHealthDto: CreateTsHealthDto) {
    return await this.prisma.tSHealth.create({ data: createTsHealthDto });
  }

  async createMany(createManyTsHealthsDto: CreateManyTsHealthDto) {
    return await this.prisma.tSHealth.createMany({
      data: createManyTsHealthsDto.tsHealths,
    });
  }

  async findAll(paginationOptions: PaginationOptionsDto) {
    const { limit, page } = paginationOptions;
    const skip = (page - 1) * limit;

    const [result, total] = await this.prisma.$transaction([
      this.prisma.tSHealth.findMany({
        take: limit,
        skip,
      }),
      this.prisma.tSHealth.count(),
    ]);

    return new PaginationResponseDto<TSHealth>({
      data: result,
      total,
      page,
      lastPage: Math.ceil(total / limit),
    });
  }

  async findByDatasetId(
    datasetId: string,
    paginationOptions: PaginationOptionsDto,
  ) {
    const { limit, page } = paginationOptions;
    const skip = (page - 1) * limit;

    const [result, total] = await this.prisma.$transaction([
      this.prisma.tSHealth.findMany({
        where: {
          session: { dataset_id: datasetId },
        },
        take: limit,
        skip,
      }),
      this.prisma.tSHealth.count({
        where: {
          session: { dataset_id: datasetId },
        },
      }),
    ]);

    return new PaginationResponseDto<TSHealth>({
      data: result,
      total,
      page,
      lastPage: Math.ceil(total / limit),
    });
  }

  async findOne(ts_health_id: string) {
    const tsHealth = await this.prisma.tSHealth.findUnique({
      where: { ts_health_id },
    });

    if (!tsHealth) {
      throw new NotFoundException(
        `TsHealth with ID: ${ts_health_id} not found`,
      );
    }

    return tsHealth;
  }

  async update(ts_health_id: string, updateTsHealthDto: UpdateTsHealthDto) {
    await this.findOne(ts_health_id);

    return await this.prisma.tSHealth.update({
      where: { ts_health_id },
      data: updateTsHealthDto,
    });
  }

  async remove(ts_health_id: string) {
    await this.findOne(ts_health_id);

    return await this.prisma.tSHealth.delete({
      where: { ts_health_id },
    });
  }
}
