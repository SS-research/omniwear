import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors();
  const config = new DocumentBuilder()
    .setTitle('omniwear API')
    .setDescription('omniwear API')
    .setVersion('1.0')
    .addTag('omniwear-api')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);
  app.useGlobalPipes(
    new ValidationPipe({
      transform: true, // This enables transformation
      whitelist: true, // This strips properties that are not decorated
    }),
  );
  await app.listen(3000);
}
bootstrap();
