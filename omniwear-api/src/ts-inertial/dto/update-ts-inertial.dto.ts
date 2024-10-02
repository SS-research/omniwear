import { PartialType } from '@nestjs/swagger';
import { CreateTsInertialDto } from './create-ts-inertial.dto';

export class UpdateTsInertialDto extends PartialType(CreateTsInertialDto) {}
