import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateTsInertialDto } from './dto/create-ts-inertial.dto';
import { PrismaService } from '@app/prisma/prisma.service';
import { UpdateTsInertialDto } from './dto/update-ts-inertial.dto'; // Assuming you have this DTO defined

@Injectable()
export class TsInertialService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createTsInertialDto: CreateTsInertialDto) {
    return await this.prisma.tSInertial.create({ data: createTsInertialDto });
  }

  async findAll() {
    return await this.prisma.tSInertial.findMany();
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
