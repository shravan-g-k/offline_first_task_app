import { drizzle } from "drizzle-orm/singlestore/driver";
import { Pool } from "pg";

const pool = new Pool({
    connectionString : process.env.DATABASE_URL
});

export default drizzle(pool);