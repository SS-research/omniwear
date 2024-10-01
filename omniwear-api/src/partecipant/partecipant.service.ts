import { Injectable, NotFoundException } from '@nestjs/common';
import { CreatePartecipantDto } from './dto/create-partecipant.dto';
import { UpdatePartecipantDto } from './dto/update-partecipant.dto';
import { PrismaService } from '@app/prisma/prisma.service';

@Injectable()
export class PartecipantService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createPartecipantDto: CreatePartecipantDto) {
    return await this.prisma.partecipant.create({ data: createPartecipantDto });
  }

  async findAll() {
    return await this.prisma.partecipant.findMany();
  }

  async findOne(partecipantID: string) {
    const partecipant = await this.prisma.partecipant.findUnique({
      where: { partecipant_id: partecipantID },
    });

    if (!partecipant) {
      throw new NotFoundException(
        `Partecipant with ID: ${partecipantID} not found`,
      );
    }

    return partecipant;
  }

  async update(
    partecipantID: string,
    updatePartecipantDto: UpdatePartecipantDto,
  ) {
    await this.findOne(partecipantID);

    return await this.prisma.partecipant.update({
      where: { partecipant_id: partecipantID },
      data: updatePartecipantDto,
    });
  }

  async remove(partecipantID: string) {
    await this.findOne(partecipantID);
    return await this.prisma.partecipant.delete({
      where: { partecipant_id: partecipantID },
    });
  }
}
