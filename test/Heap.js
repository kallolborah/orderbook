const { expect } = require("chai");
const Web3 = require('web3');
const provider = new Web3.providers.HttpProvider('http://localhost:8545')
const web3 = new Web3(provider)

const Heap = artifacts.require('Heap');

contract("Heap", async (accounts) => {

    var heap;

    beforeEach("should add random elements", async () => {     
        heap = await Heap.deployed(); 
        const testData = Array(10) // checking for 10 elements
        .fill()
        .map(() => Math.floor(50 * Math.random())); // numbers from 0-50 (exclusive)

        for (let i = 0; i < testData.length; i++) {
            await heap.insert(testData[i])
            .then(function(){
                console.log("Added element "+testData[i]);
            });
        }
    });

    it("should remove max from heap", async () => {
        await heap.getMax()
        .then(async(result)=>{
            console.log("Max value from heap is "+result);
            await heap.removeMax()
            .then(function(){
                console.log("Removed max heap element");
            });
        });
    });

    it("should remove min from heap", async () => {
        await heap.getMin()
        .then(async(result)=>{
            console.log("Min value from heap is "+result);
            await heap.removeMin()
            .then(function(){
                console.log("Removed min heap element");
            });
        });
    });

});