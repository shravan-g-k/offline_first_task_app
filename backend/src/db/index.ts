import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";

const pool = new Pool({
    connectionString: "postgres://postgresql:test123@localhost:5432/postgres"
});

export const db =  drizzle(pool);