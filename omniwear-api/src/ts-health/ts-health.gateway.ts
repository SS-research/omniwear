import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Socket } from 'socket.io';
import { TsHealthService } from './ts-health.service';
import { CreateManyTsHealthDto } from './dto/create-many-ts-health.dto';
import { UsePipes, ValidationPipe } from '@nestjs/common';

// TODO: more secure CORS
// TODO: check if possible to set CORS global for both WebSocket and REST API
@WebSocketGateway({ cors: '*' })
export class TsHealthGateway
  implements OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  server;

  constructor(private readonly tsHealthService: TsHealthService) {}

  async handleConnection(client: Socket) {
    console.log(`Client connected: ${client.id}`);
  }

  async handleDisconnect(client: Socket) {
    console.log(`Client disconnected: ${client.id}`);
  }

  @UsePipes(new ValidationPipe())
  @SubscribeMessage('ts-health')
  async handleMessage(
    @MessageBody() message: CreateManyTsHealthDto,
    @ConnectedSocket() client: Socket,
  ): Promise<void> {
    try {
      const tsHealthRecord = await this.tsHealthService.createMany(message);
      console.log('Created TsHealth Records:', tsHealthRecord);

      // Send back the created record only to the specific client
      client.emit('ts-health-response', tsHealthRecord);
    } catch (error) {
      console.error('Error creating TsHealth Record:', error);

      // Send an error message to the specific client
      client.emit('ts-health-error', { message: 'Failed to create record' });
    }
  }
}
