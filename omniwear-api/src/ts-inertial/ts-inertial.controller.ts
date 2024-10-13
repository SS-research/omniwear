import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { TsInertialService } from './ts-inertial.service';
import { CreateTsInertialDto } from './dto/create-ts-inertial.dto';
import { UpdateTsInertialDto } from './dto/update-ts-inertial.dto';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('ts-inertial')
@Controller('ts-inertial')
export class TsInertialController {
  constructor(private readonly tsInertialService: TsInertialService) {}

  @Post()
  async create(@Body() createTsInertialDto: CreateTsInertialDto) {
    return await this.tsInertialService.create(createTsInertialDto);
  }

  @Get()
  async findAll() {
    return await this.tsInertialService.findAll();
  }

  @Get(':ts_inertial_id')
  async findOne(@Param('ts_inertial_id') ts_inertial_id: string) {
    return await this.tsInertialService.findOne(ts_inertial_id);
  }

  @Patch(':ts_inertial_id')
  async update(
    @Param('ts_inertial_id') ts_inertial_id: string,
    @Body() updateTsInertialDto: UpdateTsInertialDto,
  ) {
    return await this.tsInertialService.update(
      ts_inertial_id,
      updateTsInertialDto,
    );
  }

  @Delete(':ts_inertial_id')
  async remove(@Param('ts_inertial_id') ts_inertial_id: string) {
    return await this.tsInertialService.remove(ts_inertial_id);
  }
}
