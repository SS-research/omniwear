-- CreateTable
CREATE TABLE "Partecipant" (
    "partecipant_id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "Session" (
    "session_id" TEXT NOT NULL PRIMARY KEY,
    "partecipant_id" TEXT NOT NULL,
    "start_timestamp" DATETIME NOT NULL,
    "end_timestamp" DATETIME NOT NULL,
    "smartphone_model" TEXT NOT NULL,
    "smartphone_os_version" TEXT NOT NULL,
    "smartwatch_model" TEXT NOT NULL,
    "smartwatch_os_version" TEXT NOT NULL,
    CONSTRAINT "Session_partecipant_id_fkey" FOREIGN KEY ("partecipant_id") REFERENCES "Partecipant" ("partecipant_id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "TSHealth" (
    "ts_health_id" TEXT NOT NULL PRIMARY KEY,
    "session_id" TEXT NOT NULL,
    "start_timestamp" DATETIME NOT NULL,
    "end_timestamp" DATETIME NOT NULL,
    "category" TEXT NOT NULL,
    "unit" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    CONSTRAINT "TSHealth_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "Session" ("session_id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "TSInertial" (
    "ts_inertial_id" TEXT NOT NULL PRIMARY KEY,
    "session_id" TEXT NOT NULL,
    "timestamp" DATETIME NOT NULL,
    "smartphone_accelerometer_ts" DATETIME NOT NULL,
    "smartphone_accelerometer_x" REAL NOT NULL,
    "smartphone_accelerometer_y" REAL NOT NULL,
    "smartphone_accelerometer_z" REAL NOT NULL,
    "smartphone_gyroscope_ts" DATETIME NOT NULL,
    "smartphone_gyroscope_x" REAL NOT NULL,
    "smartphone_gyroscope_y" REAL NOT NULL,
    "smartphone_gyroscope_z" REAL NOT NULL,
    "smartphone_magnometer_ts" DATETIME NOT NULL,
    "smartphone_magnometer_x" REAL NOT NULL,
    "smartphone_magnometer_y" REAL NOT NULL,
    "smartphone_magnometer_z" REAL NOT NULL,
    CONSTRAINT "TSInertial_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "Session" ("session_id") ON DELETE CASCADE ON UPDATE CASCADE
);
