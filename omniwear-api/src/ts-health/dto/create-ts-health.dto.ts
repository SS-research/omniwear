import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsUUID, IsString, IsDate } from 'class-validator';

export class CreateTsHealthDto {
  @ApiPropertyOptional({
    description:
      'The unique identifier of the health data. It is optional and auto-generated if not provided.',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  @IsUUID()
  ts_health_id?: string;

  @ApiProperty({
    description:
      'The unique identifier of the session to which this health data belongs.',
    example: '987e6543-b21d-34f5-c987-526734198700',
  })
  @IsUUID()
  session_id: string;

  @ApiProperty({
    description: 'The start timestamp of the health data.',
    example: '2024-09-30T13:45:30.000Z',
  })
  @IsDate()
  @Type(() => Date)
  start_timestamp: Date;

  @ApiProperty({
    description: 'The end timestamp of the health data.',
    example: '2024-09-30T14:00:30.000Z',
  })
  @IsDate()
  @Type(() => Date)
  end_timestamp: Date;

  @ApiProperty({
    description:
      'The category of the health data, such as heart rate, steps, etc.',
    example: 'heart_rate',
  })
  @IsString()
  category: string;

  @ApiProperty({
    description:
      'The unit of measurement for the health data, such as bpm, steps, etc.',
    example: 'bpm',
  })
  @IsString()
  unit: string;

  @ApiProperty({
    description:
      'The value of the health data, typically a string that can represent numerical or other values.',
    example: '72',
  })
  @IsString()
  value: string;
}
