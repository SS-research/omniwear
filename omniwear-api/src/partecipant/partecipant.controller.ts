import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { PartecipantService } from './partecipant.service';
import { CreatePartecipantDto } from './dto/create-partecipant.dto';
import { UpdatePartecipantDto } from './dto/update-partecipant.dto';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('partecipant')
@Controller('partecipant')
export class PartecipantController {
  constructor(private readonly partecipantService: PartecipantService) {}

  @Post()
  async create(@Body() createPartecipantDto: CreatePartecipantDto) {
    return await this.partecipantService.create(createPartecipantDto);
  }

  @Get()
  async findAll() {
    return await this.partecipantService.findAll();
  }

  @Get(':partecipant_id')
  async findOne(@Param('partecipant_id') partecipant_id: string) {
    return await this.partecipantService.findOne(partecipant_id);
  }

  @Patch(':partecipant_id')
  async update(
    @Param('partecipant_id') partecipant_id: string,
    @Body() updatePartecipantDto: UpdatePartecipantDto,
  ) {
    return await this.partecipantService.update(
      partecipant_id,
      updatePartecipantDto,
    );
  }

  @Delete(':partecipant_id')
  async remove(@Param('partecipant_id') partecipant_id: string) {
    return await this.partecipantService.remove(partecipant_id);
  }
}
