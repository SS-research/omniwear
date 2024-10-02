import { Module } from '@nestjs/common';
import { TsHealthService } from './ts-health.service';
import { TsHealthController } from './ts-health.controller';
import { PrismaModule } from '@app/prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [TsHealthController],
  providers: [TsHealthService],
})
export class TsHealthModule {}
