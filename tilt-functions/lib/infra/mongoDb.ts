import * as mongoose from "mongoose";

export async function connect() {
  const mongoDbConnectionStringEnvironmentVariable =
    "COSMOS_DB_CONNECTION_STRING";

  const mongoDbNameEnvironmentVariable = "COSMOS_DB_NAME";

  if (!mongoDbConnectionStringEnvironmentVariable) {
    throw new Error(
      `A connection to MongoDB cannot established because the connection string is missing in environment variable ${mongoDbConnectionStringEnvironmentVariable}.`
    );
  }

  if (!mongoDbNameEnvironmentVariable) {
    throw new Error(
      `A connection to MongoDB cannot established because the db name is missing in environment variable ${mongoDbNameEnvironmentVariable}.`
    );
  }

  return mongoose.connect(
    process.env[mongoDbConnectionStringEnvironmentVariable],
    {
      dbName: process.env[mongoDbNameEnvironmentVariable],
      useNewUrlParser: true,
      useUnifiedTopology: true,
      useFindAndModify: false,
    }
  );
}
