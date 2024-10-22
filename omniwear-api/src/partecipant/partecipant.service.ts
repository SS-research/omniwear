import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreatePartecipantDto } from './dto/create-partecipant.dto';
import { UpdatePartecipantDto } from './dto/update-partecipant.dto';
import { PrismaService } from '@app/prisma/prisma.service';

@Injectable()
export class PartecipantService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createPartecipantDto: CreatePartecipantDto) {
    const { partecipant_id } = createPartecipantDto;

    // If partecipant_id is provided, check if it already exists
    if (partecipant_id) {
      const existingPartecipant = await this.prisma.partecipant.findUnique({
        where: { partecipant_id },
      });

      if (existingPartecipant) {
        // If the participant already exists, throw a conflict exception
        throw new ConflictException(
          `Partecipant with ID: ${partecipant_id} already exists`,
        );
      }
    }
    return await this.prisma.partecipant.create({ data: createPartecipantDto });
  }

  async findAll() {
    return await this.prisma.partecipant.findMany();
  }

  async findOne(partecipant_id: string) {
    const partecipant = await this.prisma.partecipant.findUnique({
      where: { partecipant_id },
    });

    if (!partecipant) {
      throw new NotFoundException(
        `Partecipant with ID: ${partecipant_id} not found`,
      );
    }

    return partecipant;
  }

  async update(
    partecipant_id: string,
    updatePartecipantDto: UpdatePartecipantDto,
  ) {
    await this.findOne(partecipant_id);

    return await this.prisma.partecipant.update({
      where: { partecipant_id },
      data: updatePartecipantDto,
    });
  }

  async remove(partecipant_id: string) {
    await this.findOne(partecipant_id);
    return await this.prisma.partecipant.delete({
      where: { partecipant_id },
    });
  }
}
