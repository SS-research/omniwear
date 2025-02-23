import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
} from '@nestjs/common';
import { TsHealthService } from './ts-health.service';
import { CreateTsHealthDto } from './dto/create-ts-health.dto';
import { UpdateTsHealthDto } from './dto/update-ts-health.dto';
import { ApiTags } from '@nestjs/swagger';
import { PaginationOptionsDto } from '@app/shared/dto';
import { CreateManyTsHealthDto } from './dto/create-many-ts-health.dto';

@ApiTags('ts-health')
@Controller('ts-health')
export class TsHealthController {
  constructor(private readonly tsHealthService: TsHealthService) {}

  @Post()
  async create(@Body() createTsHealthDto: CreateTsHealthDto) {
    return await this.tsHealthService.create(createTsHealthDto);
  }

  @Post('/bulk')
  async createBulk(@Body() createManyTsHealthDto: CreateManyTsHealthDto) {
    return await this.tsHealthService.createMany(createManyTsHealthDto);
  }

  @Get()
  async findAll(@Query() paginationOptions: PaginationOptionsDto) {
    return await this.tsHealthService.findAll(paginationOptions);
  }

  @Get(':ts_health_id')
  async findOne(@Param('ts_health_id') ts_health_id: string) {
    return await this.tsHealthService.findOne(ts_health_id);
  }

  @Patch(':ts_health_id')
  async update(
    @Param('ts_health_id') ts_health_id: string,
    @Body() updateTsHealthDto: UpdateTsHealthDto,
  ) {
    return await this.tsHealthService.update(ts_health_id, updateTsHealthDto);
  }

  @Delete(':ts_health_id')
  async remove(@Param('ts_health_id') ts_health_id: string) {
    return await this.tsHealthService.remove(ts_health_id);
  }

  @Get('dataset/:dataset_id')
  async findByDatasetId(
    @Param('dataset_id') dataset_id: string,
    @Query() paginationOptions: PaginationOptionsDto,
  ) {
    return await this.tsHealthService.findByDatasetId(
      dataset_id,
      paginationOptions,
    );
  }
}
