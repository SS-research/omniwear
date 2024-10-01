import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { PrismaModule } from './prisma/prisma.module';
import { TsInertialModule } from './ts-inertial/ts-inertial.module';
import { PartecipantModule } from './partecipant/partecipant.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    PrismaModule,
    TsInertialModule,
    PartecipantModule,
  ],
  controllers: [AppController],
})
export class AppModule {}
