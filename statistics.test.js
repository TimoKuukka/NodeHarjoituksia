// UNIT TEST FOR MODULE: statistics.js
// ====================================

// LOAD LIBRARIES AND MODULES
// --------------------------
const stats = require('./statistics.js');

// Define array and number of decimals for tests

const testArray = [1, 2, 3, 6];
const numberOfDecimals = 1;

// Create an object for statistical calculations
const statToTest = new stats.ArrayStats(testArray, numberOfDecimals);

//  Test average calculation ie mean
test('Average should be 3.0 ', () => {
    expect(statToTest.mean()).toBeCloseTo(3.0);

});

// Test mode ie most common value
const testArray2 = [1, 2, 2, 2, 3, 4];
const statToTest2 = new stats.ArrayStats(testArray2, numberOfDecimals);

test('Mode should be 2 ', () => {
    expect(statToTest2.mode()).toEqual([2]);
});

// Test median ie middlemost element is sorted array
const testArray3 = [1, 2, 2, 3, 4];
const statToTest3 = new stats.ArrayStats(testArray3, numberOfDecimals);

test('Median should be 2 ', () => {
    expect(statToTest3.median()).toBe(2);
});

// Test median ie average of two middlemost elements in sorted array, even elements in array
const testArray4 = [1, 2, 2, 3, 3, 4];
const statToTest4 = new stats.ArrayStats(testArray4, numberOfDecimals);

test('Median should be 2.5 ', () => {
    expect(statToTest4.median()).toBe(2.5);
});
