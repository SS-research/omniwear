import { PartialType } from '@nestjs/swagger';
import { CreateTsHealthDto } from './create-ts-health.dto';

export class UpdateTsHealthDto extends PartialType(CreateTsHealthDto) {}
