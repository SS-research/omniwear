import { IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { CreateTsHealthDto } from './create-ts-health.dto';

export class CreateManyTsHealthDto {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateTsHealthDto)
  tsHealths: CreateTsHealthDto[];
}
