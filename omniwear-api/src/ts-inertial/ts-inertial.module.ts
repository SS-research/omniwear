import { Module } from '@nestjs/common';
import { TsInertialGateway } from './ts-inertial.gateway';
import { TsInertialService } from './ts-inertial.service';
import { PrismaModule } from '@app/prisma/prisma.module';
import { TsInertialController } from './ts-inertial.controller';

@Module({
  imports: [PrismaModule],
  providers: [TsInertialGateway, TsInertialService],
  exports: [TsInertialGateway],
  controllers: [TsInertialController],
})
export class TsInertialModule {}
