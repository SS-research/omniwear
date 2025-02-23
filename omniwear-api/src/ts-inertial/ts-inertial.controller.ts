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
import { TsInertialService } from './ts-inertial.service';
import { CreateTsInertialDto } from './dto/create-ts-inertial.dto';
import { UpdateTsInertialDto } from './dto/update-ts-inertial.dto';
import { ApiTags } from '@nestjs/swagger';
import { PaginationOptionsDto } from '@app/shared/dto';
import { CreateManyTsInertialDto } from './dto/create-many-ts-inertial.dto';

@ApiTags('ts-inertial')
@Controller('ts-inertial')
export class TsInertialController {
  constructor(private readonly tsInertialService: TsInertialService) {}

  @Post()
  async create(@Body() createTsInertialDto: CreateTsInertialDto) {
    return await this.tsInertialService.create(createTsInertialDto);
  }

  @Post('/bulk')
  async createBulk(@Body() createManyTsInertialDto: CreateManyTsInertialDto) {
    return await this.tsInertialService.createMany(createManyTsInertialDto);
  }

  @Get()
  async findAll(@Query() paginationOptions: PaginationOptionsDto) {
    return await this.tsInertialService.findAll(paginationOptions);
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

  @Get('dataset/:dataset_id')
  async findByDatasetId(
    @Param('dataset_id') dataset_id: string,
    @Query() paginationOptions: PaginationOptionsDto,
  ) {
    return await this.tsInertialService.findByDatasetId(
      dataset_id,
      paginationOptions,
    );
  }
}
