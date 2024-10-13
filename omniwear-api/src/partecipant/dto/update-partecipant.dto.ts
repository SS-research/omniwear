import { PartialType } from '@nestjs/swagger';
import { CreatePartecipantDto } from './create-partecipant.dto';

export class UpdatePartecipantDto extends PartialType(CreatePartecipantDto) {}
