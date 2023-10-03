// Desc: This file contains the code to log the data fetch operation to a file
const fs = require('fs');

const timestamp = new Date();
const isoTimeStamp = timestamp.toISOString();
let operation = 'Data Fetch operation';
let status = 'processed successfully';
let entry = operation + ' ' + status + ' @ ' + isoTimeStamp + '\n';

console.log(entry);

fs.appendFile('dataOperations.log', entry, (err) => {
    if (err) {
        console.log(err);
    }
})