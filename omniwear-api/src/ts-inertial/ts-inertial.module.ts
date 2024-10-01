import { Module } from '@nestjs/common';
import { TsInertialGateway } from './ts-inertial.gateway';

@Module({
  providers: [TsInertialGateway],
  exports: [TsInertialGateway],
})
export class TsInertialModule {}
