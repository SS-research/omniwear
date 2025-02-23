import { IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { CreateTsHealthDto } from './create-ts-health.dto';
import { ApiProperty } from '@nestjs/swagger';

export class CreateManyTsHealthDto {
  @ApiProperty({
    description: 'A list of health data you want to create.',
    type: CreateTsHealthDto,
    isArray: true,
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateTsHealthDto)
  data: CreateTsHealthDto[];
}
