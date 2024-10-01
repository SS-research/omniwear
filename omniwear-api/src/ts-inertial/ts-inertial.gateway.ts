import {
  MessageBody,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { TsInertialDto } from './dto/ts-inertial.dto';

// TODO: more secure cors
// TODO: check if possible to set cors global for both websocket and rest api
@WebSocketGateway({ cors: '*' })
export class TsInertialGateway {
  @WebSocketServer()
  server;

  @SubscribeMessage('ts-inertial')
  handleMessage(@MessageBody() message: TsInertialDto): void {
    console.log(message);
  }
}
