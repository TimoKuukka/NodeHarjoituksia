// LIBRARIES
const Pool = require('pg').Pool

// Create a new pool for the PostgreSQL connections
const pool = new Pool({
    user: 'postgres',   // In production allways create a new user for the app with limited rights
    password: 'Q2werty', 
    host: 'localhost',  // The host name for the database
    database: 'smarthome',
    port: 5432,
});

// Create a query using traditional way

//  Define embedded SQL
let sqlClause = 'SELECT * FROM public.hourly_price'

//  Define the query returning an error message or resultset
const query1 = pool.query(sqlClause, (error, results) => {
    if (error) {
        throw error
    }
    console.log(results.rows)
});

// Modern way using function with async/await
const query2 = async () => {
let resultset = await pool.query(sqlClause);
return resultset};

// Results will be ready when promise is fulfilled
query2()
.then((resultset) => console.log(resultset.rows[0]));
