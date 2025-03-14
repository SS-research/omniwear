import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNumber,
  IsPositive,
  Min,
  IsEnum,
  IsOptional,
} from 'class-validator';
import { StorageOption } from './storage_option.enum';

// TODO: write better ApiProperty.description
export class CreateDatasetDto {
  @ApiProperty({
    description: 'The frequency of inertial collection in Hz.',
    example: 10,
    default: 10,
  })
  @IsNumber()
  @IsPositive()
  inertial_collection_frequency: number = 10;

  @ApiProperty({
    description: 'The duration of inertial collection in seconds.',
    example: 5,
    default: 5,
  })
  @IsNumber()
  @Min(0)
  inertial_collection_duration_seconds: number = 5;

  @ApiProperty({
    description: 'The sleep duration between inertial collections in seconds.',
    example: 5,
    default: 5,
  })
  @IsNumber()
  @Min(0)
  inertial_sleep_duration_seconds: number = 5;

  @ApiPropertyOptional({
    description:
      'The types of inertial features collected, such as accelerometer, gyroscope.',
    example: 'accelerometer,gyroscope',
    default: 'accelerometer,gyroscope',
  })
  @IsString()
  @IsOptional()
  inertial_features: string = 'accelerometer,gyroscope';

  @ApiPropertyOptional({
    description:
      'The health features collected (e.g., heart rate, steps). Use "*" for all features.',
    example: '*',
    default: '*',
  })
  @IsString()
  @IsOptional()
  health_features: string = '*';

  @ApiProperty({
    description: 'The frequency of health readings in Hz.',
    example: 4,
    default: 4,
  })
  @IsNumber()
  @IsPositive()
  health_reading_frequency: number = 4;

  @ApiProperty({
    description: 'The interval between health readings in milliseconds.',
    example: 1800000,
    default: 1800000,
  })
  @IsNumber()
  @Min(0)
  health_reading_interval: number = 1800000;

  @ApiProperty({
    description: 'Where to save the data: LOCAL or REMOTE.',
    example: StorageOption.REMOTE,
    default: StorageOption.REMOTE,
  })
  @IsEnum(StorageOption)
  storage_option: StorageOption = StorageOption.REMOTE;
}
