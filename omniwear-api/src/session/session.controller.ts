import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { SessionService } from './session.service';
import { CreateSessionDto } from './dto/create-session.dto';
import { UpdateSessionDto } from './dto/update-session.dto';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('session')
@Controller('session')
export class SessionController {
  constructor(private readonly sessionService: SessionService) {}

  @Post()
  async create(@Body() createSessionDto: CreateSessionDto) {
    return this.sessionService.create(createSessionDto);
  }

  @Get()
  async findAll() {
    return await this.sessionService.findAll();
  }

  @Get(':session_id')
  async findOne(@Param('session_id') session_id: string) {
    return await this.sessionService.findOne(session_id);
  }

  @Patch(':session_id')
  async update(
    @Param('session_id') session_id: string,
    @Body() updateSessionDto: UpdateSessionDto,
  ) {
    return await this.sessionService.update(session_id, updateSessionDto);
  }

  @Delete(':session_id')
  async remove(@Param('session_id') session_id: string) {
    return await this.sessionService.remove(session_id);
  }
}
