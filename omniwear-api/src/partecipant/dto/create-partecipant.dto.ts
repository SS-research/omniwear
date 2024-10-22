import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsDate, IsOptional, IsString } from 'class-validator';
import { Type } from 'class-transformer';

export class CreatePartecipantDto {
  @ApiPropertyOptional({
    description: 'Unique identifier for the participant',
    example: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
  })
  @IsString()
  @IsOptional()
  partecipant_id?: string;

  @ApiPropertyOptional({
    description: 'The date and time when the participant was created',
    example: '2024-10-02T14:48:00.000Z',
  })
  @IsDate()
  @IsOptional()
  @Type(() => Date) // Ensures transformation to Date
  created_at?: Date;
}
