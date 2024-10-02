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
import { CreateTsInertialDto } from './dto/create-ts-inertial.dto';
import { TsInertialService } from './ts-inertial.service';

// TODO: more secure cors
// TODO: check if possible to set cors global for both websocket and rest api
@WebSocketGateway({ cors: '*' })
export class TsInertialGateway
  implements OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  server;

  constructor(private readonly tsInertialService: TsInertialService) {}

  async handleConnection(client: Socket) {
    console.log(`Client connected: ${client.id}`);
  }

  async handleDisconnect(client: Socket) {
    console.log(`Client disconnected: ${client.id}`);
  }

  @SubscribeMessage('ts-inertial')
  async handleMessage(
    @MessageBody() message: CreateTsInertialDto,
    @ConnectedSocket() client: Socket,
  ): Promise<void> {
    try {
      const tsInertialRecord = await this.tsInertialService.create(message);
      console.log('Created TsInertial Record:', tsInertialRecord);

      // Send back the created record only to the specific client
      client.emit('ts-inertial-response', tsInertialRecord); // Emit only to the client that sent the message
    } catch (error) {
      console.error('Error creating TsInertial Record:', error);

      // Send an error message to the specific client
      client.emit('ts-inertial-error', { message: 'Failed to create record' });
    }
  }
}
