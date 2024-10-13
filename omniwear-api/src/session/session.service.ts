import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateSessionDto } from './dto/create-session.dto';
import { UpdateSessionDto } from './dto/update-session.dto';
import { PrismaService } from '@app/prisma/prisma.service';

@Injectable()
export class SessionService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createSessionDto: CreateSessionDto) {
    return await this.prisma.session.create({ data: createSessionDto });
  }

  async findAll() {
    return await this.prisma.session.findMany();
  }

  async findOne(session_id: string) {
    const session = await this.prisma.session.findUnique({
      where: { session_id },
    });

    if (!session) {
      throw new NotFoundException(`Session with ID: ${session_id} not found`);
    }

    return session;
  }

  async update(session_id: string, updateSessionDto: UpdateSessionDto) {
    await this.findOne(session_id);

    return await this.prisma.session.update({
      where: { session_id },
      data: updateSessionDto,
    });
  }

  async remove(session_id: string) {
    await this.findOne(session_id);
    return this.prisma.session.delete({ where: { session_id } });
  }
}
