/*
  Warnings:

  - Added the required column `inertial_features` to the `Dataset` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Dataset" (
    "dataset_id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "inertial_features" TEXT NOT NULL,
    "inertial_collection_frequency" REAL NOT NULL,
    "inertial_collection_duration_seconds" INTEGER NOT NULL,
    "inertial_sleep_duration_seconds" INTEGER NOT NULL,
    "health_features" TEXT NOT NULL,
    "health_reading_frequency" INTEGER NOT NULL,
    "health_reading_interval" INTEGER NOT NULL
);
INSERT INTO "new_Dataset" ("created_at", "dataset_id", "health_features", "health_reading_frequency", "health_reading_interval", "inertial_collection_duration_seconds", "inertial_collection_frequency", "inertial_sleep_duration_seconds", "updated_at") SELECT "created_at", "dataset_id", "health_features", "health_reading_frequency", "health_reading_interval", "inertial_collection_duration_seconds", "inertial_collection_frequency", "inertial_sleep_duration_seconds", "updated_at" FROM "Dataset";
DROP TABLE "Dataset";
ALTER TABLE "new_Dataset" RENAME TO "Dataset";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
