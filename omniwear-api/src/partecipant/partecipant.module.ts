import { Module } from '@nestjs/common';
import { PartecipantService } from './partecipant.service';
import { PartecipantController } from './partecipant.controller';
import { PrismaModule } from '@app/prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [PartecipantController],
  providers: [PartecipantService],
})
export class PartecipantModule {}
