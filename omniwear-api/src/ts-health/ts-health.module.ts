import { Module } from '@nestjs/common';
import { TsHealthService } from './ts-health.service';
import { TsHealthController } from './ts-health.controller';
import { PrismaModule } from '@app/prisma/prisma.module';
import { TsHealthGateway } from './ts-health.gateway';

@Module({
  imports: [PrismaModule],
  controllers: [TsHealthController],
  providers: [TsHealthService, TsHealthGateway],
})
export class TsHealthModule {}
