type CreateTsHealthDto = {
    ts_health_id?: string;
    session_id: string; 
    start_timestamp: Date; 
    end_timestamp: Date; 
    category: string; 
    unit: string; 
    value: string; 
}

type UpdateTsHealthDto = Partial<CreateTsHealthDto>;

type TTsHealth = CreateTsHealthDto & {
    created_at: Date; 
    updated_at: Date;
}

export type {
    CreateTsHealthDto,
    UpdateTsHealthDto,
    TTsHealth
}
