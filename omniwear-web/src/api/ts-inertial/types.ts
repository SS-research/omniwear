type CreateTsInertialDto = {
    ts_inertial_id?: string;
    session_id: string; 
    timestamp: Date; 
    smartphone_accelerometer_timestamp?: Date; 
    smartphone_accelerometer_x?: number; 
    smartphone_accelerometer_y?: number; 
    smartphone_accelerometer_z?: number; 
    smartphone_gyroscope_timestamp?: Date; 
    smartphone_gyroscope_x?: number; 
    smartphone_gyroscope_y?: number; 
    smartphone_gyroscope_z?: number; 
    smartphone_magnometer_timestamp?: Date; 
    smartphone_magnometer_x?: number; 
    smartphone_magnometer_y?: number; 
    smartphone_magnometer_z?: number; 
}

type UpdateTsInertialDto = Partial<CreateTsInertialDto>;

type TTsInertial = CreateTsInertialDto & {
    created_at: Date; 
    updated_at: Date;
}

export type {
    CreateTsInertialDto,
    UpdateTsInertialDto,
    TTsInertial
}
