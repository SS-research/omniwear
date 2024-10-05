import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsUUID,
  IsString,
  IsDate,
  MinLength,
  IsOptional,
} from 'class-validator';
import { Type } from 'class-transformer';

export class CreateSessionDto {
  @ApiPropertyOptional({
    description:
      'Unique identifier for the session. It can be provided by the client or auto-generated by the server.',
    example: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
  })
  @IsUUID()
  @IsOptional()
  session_id?: string;

  @ApiProperty({
    description: 'Unique identifier for the participant',
    example: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
  })
  @IsUUID()
  partecipant_id: string;

  @ApiProperty({
    description: 'Unique identifier for the dataset',
    example: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
  })
  @IsUUID()
  dataset_id: string;

  @ApiProperty({
    description: 'The start timestamp of the session',
    example: '2024-10-02T14:48:00.000Z',
  })
  @IsDate()
  @Type(() => Date) // Ensures transformation to Date
  start_timestamp: Date;

  @ApiProperty({
    description: 'The end timestamp of the session',
    example: '2024-10-02T15:48:00.000Z',
  })
  @IsDate()
  @Type(() => Date) // Ensures transformation to Date
  end_timestamp: Date;

  @ApiProperty({
    description: 'The smartphone model used in the session',
    example: 'iPhone 13 Pro',
  })
  @IsString()
  @MinLength(1)
  smartphone_model: string;

  @ApiProperty({
    description: 'The smartphone OS version used in the session',
    example: 'iOS 15.1',
  })
  @IsString()
  @MinLength(1)
  smartphone_os_version: string;

  @ApiProperty({
    description: 'The smartwatch model used in the session',
    example: 'Apple Watch Series 7',
  })
  @IsString()
  @MinLength(1)
  smartwatch_model: string;

  @ApiProperty({
    description: 'The smartwatch OS version used in the session',
    example: 'watchOS 8.0',
  })
  @IsString()
  @MinLength(1)
  smartwatch_os_version: string;
}
