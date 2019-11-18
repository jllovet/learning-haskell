'use strict';
// From HackerRank JavaScript Simple Array Sum Exercise
const fs = require('fs');

process.stdin.resume();
process.stdin.setEncoding('utf-8');

let inputString = '';
let currentLine = 0;

process.stdin.on('data', inputStdin => {
    inputString += inputStdin;
});

process.stdin.on('end', _ => {
    inputString = inputString.trim().split('\n').map(str => str.trim());

    main();
});

function readLine() {
    return inputString[currentLine++];
}

/*
 * Complete the simpleArraySum function below.
 */
function simpleArraySum(ar) {
    /*
     * The first line contains an integer, n, denoting the size of the array.
     * The second line contains n space-separated
     * integers representing the array's elements.
     */

    // The following are various implementations of the function,
    // the first two using side effects, the third purely functional

    //  forEach implementation
    // const calculateArraySumWithForEach = (ar) => {
    //     let x = 0;
    //     ar.forEach(element => {
    //         x += element;
    //     });
    //     return x;
    // }
    // return calculateArraySumWithForEach(ar);

    // const calculateArraySumWithForLoop = (ar) => {
    //     let x = 0;
    //     for (el of ar) {
    //         x += el;
    //     }
    //     return x;
    // }
    // return calculateArraySumWithForLoop(ar);


    // [a] -> a
    // Purely functional version
    const calculateArraySum = (ar) => {
        if (ar.find(_ => true)) {
            return ar.find(_ => true) + calculateArraySum(ar.slice(1))
        } else {
            return 0;
        }
    }
    return calculateArraySum(ar);
}

function main() {
    const ws = fs.createWriteStream(process.env.OUTPUT_PATH);

    const arCount = parseInt(readLine(), 10);

    const ar = readLine().split(' ').map(arTemp => parseInt(arTemp, 10));

    let result = simpleArraySum(ar);

    ws.write(result + "\n");

    ws.end();
}
