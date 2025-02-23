import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateTsInertialDto } from './dto/create-ts-inertial.dto';
import { PrismaService } from '@app/prisma/prisma.service';
import { UpdateTsInertialDto } from './dto/update-ts-inertial.dto'; // Assuming you have this DTO defined
import { PaginationOptionsDto, PaginationResponseDto } from '@app/shared/dto';
import { TSInertial } from '@prisma/client';
import { CreateManyTsInertialDto } from './dto/create-many-ts-inertial.dto';

@Injectable()
export class TsInertialService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createTsInertialDto: CreateTsInertialDto) {
    return await this.prisma.tSInertial.create({ data: createTsInertialDto });
  }

  async createMany(createManyTsInertialDto: CreateManyTsInertialDto) {
    return await this.prisma.tSInertial.createMany({
      data: createManyTsInertialDto.data,
    });
  }

  async findAll(paginationOptions: PaginationOptionsDto) {
    const { limit, page } = paginationOptions;
    const skip = (page - 1) * limit;

    const [result, total] = await this.prisma.$transaction([
      this.prisma.tSInertial.findMany({
        take: limit,
        skip,
      }),
      this.prisma.tSInertial.count(),
    ]);

    return new PaginationResponseDto<TSInertial>({
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
      this.prisma.tSInertial.findMany({
        where: {
          session: { dataset_id: datasetId },
        },
        take: limit,
        skip,
      }),
      this.prisma.tSInertial.count({
        where: {
          session: { dataset_id: datasetId },
        },
      }),
    ]);

    return new PaginationResponseDto<TSInertial>({
      data: result,
      total,
      page,
      lastPage: Math.ceil(total / limit),
    });
  }

  async findOne(ts_inertial_id: string) {
    const tsInertial = await this.prisma.tSInertial.findUnique({
      where: { ts_inertial_id },
    });

    if (!tsInertial) {
      throw new NotFoundException(
        `TsInertial with ID: ${ts_inertial_id} not found`,
      );
    }

    return tsInertial;
  }

  async update(
    ts_inertial_id: string,
    updateTsInertialDto: UpdateTsInertialDto,
  ) {
    await this.findOne(ts_inertial_id);

    return await this.prisma.tSInertial.update({
      where: { ts_inertial_id },
      data: updateTsInertialDto,
    });
  }

  async remove(ts_inertial_id: string) {
    await this.findOne(ts_inertial_id);

    return await this.prisma.tSInertial.delete({
      where: { ts_inertial_id },
    });
  }
}
