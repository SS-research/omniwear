import { IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { CreateTsInertialDto } from './create-ts-inertial.dto';
import { ApiProperty } from '@nestjs/swagger';

export class CreateManyTsInertialDto {
  @ApiProperty({
    description: 'A list of inertial data you want to create.',
    type: CreateTsInertialDto,
    isArray: true,
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateTsInertialDto)
  data: CreateTsInertialDto[];
}
