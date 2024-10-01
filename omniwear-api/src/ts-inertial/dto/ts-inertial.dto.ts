import { IsString, IsDate, IsNumber } from 'class-validator';

export class TsInertialDto {
  @IsString()
  session_id: string;

  @IsDate()
  timestamp: Date;

  @IsDate()
  smartphone_accelerometer_ts: Date;

  @IsNumber()
  smartphone_accelerometer_x: number;

  @IsNumber()
  smartphone_accelerometer_y: number;

  @IsNumber()
  smartphone_accelerometer_z: number;

  @IsDate()
  smartphone_gyroscope_ts: Date;

  @IsNumber()
  smartphone_gyroscope_x: number;

  @IsNumber()
  smartphone_gyroscope_y: number;

  @IsNumber()
  smartphone_gyroscope_z: number;

  @IsDate()
  smartphone_magnometer_ts: Date;

  @IsNumber()
  smartphone_magnometer_x: number;

  @IsNumber()
  smartphone_magnometer_y: number;

  @IsNumber()
  smartphone_magnometer_z: number;
}
