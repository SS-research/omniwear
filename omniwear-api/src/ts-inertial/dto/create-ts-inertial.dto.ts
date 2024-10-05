import { Type } from 'class-transformer';
import { IsDate, IsNumber, IsOptional, IsUUID } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateTsInertialDto {
  @ApiPropertyOptional({
    description:
      'The unique identifier of the inertial record. This is optional and will be auto-generated if not provided.',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  @IsUUID()
  @IsOptional()
  ts_inertial_id?: string;

  @ApiProperty({
    description:
      'The unique identifier of the session to which this inertial data belongs.',
    example: '987e6543-b21d-34f5-c987-526734198700',
  })
  @IsUUID()
  session_id: string;

  @ApiProperty({
    description: 'The timestamp when the inertial data was recorded.',
    example: '2024-10-02T00:13:53.940Z',
  })
  @IsDate()
  @Type(() => Date)
  timestamp: Date;

  @ApiPropertyOptional({
    description: 'Timestamp for smartphone accelerometer data.',
    example: '2024-10-02T00:13:53.940Z',
  })
  @IsDate()
  @Type(() => Date)
  @IsOptional()
  smartphone_accelerometer_timestamp?: Date;

  @ApiPropertyOptional({
    description: 'X-axis data from the smartphone accelerometer.',
    example: 0.98,
  })
  @IsNumber()
  @IsOptional()
  smartphone_accelerometer_x?: number;

  @ApiPropertyOptional({
    description: 'Y-axis data from the smartphone accelerometer.',
    example: -0.23,
  })
  @IsNumber()
  @IsOptional()
  smartphone_accelerometer_y?: number;

  @ApiPropertyOptional({
    description: 'Z-axis data from the smartphone accelerometer.',
    example: 9.81,
  })
  @IsNumber()
  @IsOptional()
  smartphone_accelerometer_z?: number;

  @ApiPropertyOptional({
    description: 'Timestamp for smartphone gyroscope data.',
    example: '2024-10-02T00:13:53.940Z',
  })
  @IsDate()
  @Type(() => Date)
  @IsOptional()
  smartphone_gyroscope_timestamp?: Date;

  @ApiPropertyOptional({
    description: 'X-axis data from the smartphone gyroscope.',
    example: 0.12,
  })
  @IsNumber()
  @IsOptional()
  smartphone_gyroscope_x?: number;

  @ApiPropertyOptional({
    description: 'Y-axis data from the smartphone gyroscope.',
    example: -0.45,
  })
  @IsNumber()
  @IsOptional()
  smartphone_gyroscope_y?: number;

  @ApiPropertyOptional({
    description: 'Z-axis data from the smartphone gyroscope.',
    example: 0.67,
  })
  @IsNumber()
  @IsOptional()
  smartphone_gyroscope_z?: number;

  @ApiPropertyOptional({
    description: 'Timestamp for smartphone magnetometer data.',
    example: '2024-10-02T00:13:53.940Z',
  })
  @IsDate()
  @Type(() => Date)
  @IsOptional()
  smartphone_magnometer_timestamp?: Date;

  @ApiPropertyOptional({
    description: 'X-axis data from the smartphone magnetometer.',
    example: 30.15,
  })
  @IsNumber()
  @IsOptional()
  smartphone_magnometer_x?: number;

  @ApiPropertyOptional({
    description: 'Y-axis data from the smartphone magnetometer.',
    example: -45.23,
  })
  @IsNumber()
  @IsOptional()
  smartphone_magnometer_y?: number;

  @ApiPropertyOptional({
    description: 'Z-axis data from the smartphone magnetometer.',
    example: 60.89,
  })
  @IsNumber()
  @IsOptional()
  smartphone_magnometer_z?: number;
}
