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
import { CreateTsHealthDto } from './dto/create-ts-health.dto';
import { TsHealthService } from './ts-health.service';

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

  @SubscribeMessage('ts-health')
  async handleMessage(
    @MessageBody() message: CreateTsHealthDto,
    @ConnectedSocket() client: Socket,
  ): Promise<void> {
    try {
      const tsHealthRecord = await this.tsHealthService.create(message);
      console.log('Created TsHealth Record:', tsHealthRecord);

      // Send back the created record only to the specific client
      client.emit('ts-health-response', tsHealthRecord);
    } catch (error) {
      console.error('Error creating TsHealth Record:', error);

      // Send an error message to the specific client
      client.emit('ts-health-error', { message: 'Failed to create record' });
    }
  }
}
