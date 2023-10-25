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

// Test 1
//  Test average calculation ie mean
test('Average should be 3.0 ', () => {
    expect(statToTest.mean()).toBeCloseTo(3.0);

});

// Test 2
// Test mode ie most common value
const testArray2 = [1, 2, 2, 2, 3, 4];
const statToTest2 = new stats.ArrayStats(testArray2, numberOfDecimals);

test('Mode should be 2 ', () => {
    expect(statToTest2.mode()).toEqual([2]);
});

// Test 3
// Test median ie middlemost element is sorted array
const testArray3 = [1, 2, 2, 3, 4];
const statToTest3 = new stats.ArrayStats(testArray3, numberOfDecimals);

test('Median should be 2 ', () => {
    expect(statToTest3.median()).toBe(2);
});

// Test 4
// Test median ie average of two middlemost elements in sorted array, even elements in array
const testArray4 = [1, 2, 2, 3, 3, 4];
const statToTest4 = new stats.ArrayStats(testArray4, numberOfDecimals);

test('Median should be 2.5 ', () => {
    expect(statToTest4.median()).toBe(2.5);
});

// Test 5
// Test mode ie most common value, there are several values
const testArray5 = [1, 2, 2, 3, 3, 4];
const statToTest5 = new stats.ArrayStats(testArray5, numberOfDecimals);

test('Mode should be 2 and 3 ', () => {
    expect(statToTest5.mode()).toEqual([2, 3]);
});

// Test 6
// Test variation of population
const testArray6 = [1, 2, 2, 3, 3, 4];
const statToTest6 = new stats.ArrayStats(testArray6, numberOfDecimals);

test('Variation of population should be 0.9 ', () => {
    expect(statToTest6.populationVariance()).toBeCloseTo(0.9, 2);
});

// Test 7
// Test standard deviation of population
test('Standard deviation should be 1', () => {
    expect(statToTest6.populationStdDev()).toBeCloseTo(1, 1);
});

// Test 8
// Test minimum value of an array
test('Minimum value should be 1', () => {
    expect(statToTest6.min()).toBe(1);
});

// Test 9
// Test maximum value of an array
test('Maximum value should be 4', () => {
    expect(statToTest6.max()).toBe(4);
});
