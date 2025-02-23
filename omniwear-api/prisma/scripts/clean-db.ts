import { PrismaClient, Prisma } from '@prisma/client';

const prisma = new PrismaClient();

async function cleanDatabase() {
  try {
    console.log('Starting to clean the database...');

    // Extract model names dynamically from Prisma's DMMF (Data Model Meta Format)
    const models = Prisma.dmmf.datamodel.models
      .map((model) => model.name)
      .filter((modelName) => modelName !== '_prisma_migrations'); // Exclude migration table

    // Iterate over model names and delete all records
    for (const modelName of models) {
      // Dynamically access the model from Prisma client, and cast it properly
      const modelDelegate = (prisma as any)[modelName];

      if (modelDelegate?.deleteMany) {
        await modelDelegate.deleteMany(); // Delete all rows from the model
        console.log(`Deleted all rows from ${modelName}`);
      }
    }

    console.log('Database cleaned successfully.');
  } catch (error) {
    console.error('Error cleaning the database:', error);
  } finally {
    await prisma.$disconnect();
  }
}

cleanDatabase();
