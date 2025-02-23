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
import { DatasetService } from './dataset.service';
import { CreateDatasetDto } from './dto/create-dataset.dto';
import { UpdateDatasetDto } from './dto/update-dataset.dto';
import { ApiTags } from '@nestjs/swagger';
import { PaginationOptionsDto } from '@app/shared/dto';

@ApiTags('dataset')
@Controller('dataset')
export class DatasetController {
  constructor(private readonly datasetService: DatasetService) {}

  @Post()
  async create(@Body() createDatasetDto: CreateDatasetDto) {
    return await this.datasetService.create(createDatasetDto);
  }

  @Get()
  async findAll(@Query() paginationOptions: PaginationOptionsDto) {
    return await this.datasetService.findAll(paginationOptions);
  }

  @Get(':dataset_id')
  async findOne(@Param('dataset_id') dataset_id: string) {
    return await this.datasetService.findOne(dataset_id);
  }

  @Patch(':dataset_id')
  async update(
    @Param('dataset_id') dataset_id: string,
    @Body() updateDatasetDto: UpdateDatasetDto,
  ) {
    return await this.datasetService.update(dataset_id, updateDatasetDto);
  }

  @Delete(':dataset_id')
  async remove(@Param('dataset_id') dataset_id: string) {
    return await this.datasetService.remove(dataset_id);
  }
}
