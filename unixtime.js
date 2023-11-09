//  A MODULE TO MAKE TIME CONVERSIONS FROM FMI DATA

/**
 * Converts FMI "unix" epoc to ISO timestamp with time zone
 * @summary Multiplies FMI Epoc by 1000 and converts to ISO timestamp
 * @param {int} fmiEpoc - Timestamp from FMI data called unix epoc
 * @return {string} - ISO formatted timestamp with time zone
 */


const fmi2isoTimestamp = (fmiEpoc) => {
    let unixEpoc = 1000 * fmiEpoc;
    let isoTimestamp = new Date(unixEpoc);
    return isoTimestamp;
}


module.exports = {
    fmi2isoTimestamp
}
