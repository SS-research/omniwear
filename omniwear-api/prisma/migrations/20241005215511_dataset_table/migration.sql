/*
  Warnings:

  - Added the required column `dataset_id` to the `Session` table without a default value. This is not possible if the table is not empty.

*/
-- CreateTable
CREATE TABLE "Dataset" (
    "dataset_id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "inertial_collection_frequency" REAL NOT NULL,
    "inertial_collection_duration_seconds" INTEGER NOT NULL,
    "inertial_sleep_duration_seconds" INTEGER NOT NULL,
    "health_features" TEXT NOT NULL,
    "health_reading_frequency" INTEGER NOT NULL,
    "health_reading_interval" INTEGER NOT NULL
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Session" (
    "session_id" TEXT NOT NULL PRIMARY KEY,
    "partecipant_id" TEXT NOT NULL,
    "dataset_id" TEXT NOT NULL,
    "start_timestamp" DATETIME NOT NULL,
    "end_timestamp" DATETIME NOT NULL,
    "smartphone_model" TEXT NOT NULL,
    "smartphone_os_version" TEXT NOT NULL,
    "smartwatch_model" TEXT NOT NULL,
    "smartwatch_os_version" TEXT NOT NULL,
    CONSTRAINT "Session_dataset_id_fkey" FOREIGN KEY ("dataset_id") REFERENCES "Dataset" ("dataset_id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Session_partecipant_id_fkey" FOREIGN KEY ("partecipant_id") REFERENCES "Partecipant" ("partecipant_id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_Session" ("end_timestamp", "partecipant_id", "session_id", "smartphone_model", "smartphone_os_version", "smartwatch_model", "smartwatch_os_version", "start_timestamp") SELECT "end_timestamp", "partecipant_id", "session_id", "smartphone_model", "smartphone_os_version", "smartwatch_model", "smartwatch_os_version", "start_timestamp" FROM "Session";
DROP TABLE "Session";
ALTER TABLE "new_Session" RENAME TO "Session";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
