/*
  Warnings:

  - You are about to drop the column `smartphone_accelerometer_ts` on the `TSInertial` table. All the data in the column will be lost.
  - You are about to drop the column `smartphone_gyroscope_ts` on the `TSInertial` table. All the data in the column will be lost.
  - You are about to drop the column `smartphone_magnometer_ts` on the `TSInertial` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_TSInertial" (
    "ts_inertial_id" TEXT NOT NULL PRIMARY KEY,
    "session_id" TEXT NOT NULL,
    "timestamp" DATETIME NOT NULL,
    "smartphone_accelerometer_timestamp" DATETIME,
    "smartphone_accelerometer_x" REAL,
    "smartphone_accelerometer_y" REAL,
    "smartphone_accelerometer_z" REAL,
    "smartphone_gyroscope_timestamp" DATETIME,
    "smartphone_gyroscope_x" REAL,
    "smartphone_gyroscope_y" REAL,
    "smartphone_gyroscope_z" REAL,
    "smartphone_magnometer_timestamp" DATETIME,
    "smartphone_magnometer_x" REAL,
    "smartphone_magnometer_y" REAL,
    "smartphone_magnometer_z" REAL,
    CONSTRAINT "TSInertial_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "Session" ("session_id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_TSInertial" ("session_id", "smartphone_accelerometer_x", "smartphone_accelerometer_y", "smartphone_accelerometer_z", "smartphone_gyroscope_x", "smartphone_gyroscope_y", "smartphone_gyroscope_z", "smartphone_magnometer_x", "smartphone_magnometer_y", "smartphone_magnometer_z", "timestamp", "ts_inertial_id") SELECT "session_id", "smartphone_accelerometer_x", "smartphone_accelerometer_y", "smartphone_accelerometer_z", "smartphone_gyroscope_x", "smartphone_gyroscope_y", "smartphone_gyroscope_z", "smartphone_magnometer_x", "smartphone_magnometer_y", "smartphone_magnometer_z", "timestamp", "ts_inertial_id" FROM "TSInertial";
DROP TABLE "TSInertial";
ALTER TABLE "new_TSInertial" RENAME TO "TSInertial";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
