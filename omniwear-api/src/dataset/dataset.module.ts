import { Module } from '@nestjs/common';
import { DatasetService } from './dataset.service';
import { DatasetController } from './dataset.controller';
import { PrismaModule } from '@app/prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [DatasetController],
  providers: [DatasetService],
})
export class DatasetModule {}
