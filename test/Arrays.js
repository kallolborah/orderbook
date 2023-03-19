const { expect } = require("chai");
const Web3 = require('web3');
const provider = new Web3.providers.HttpProvider('http://localhost:8545')
const web3 = new Web3(provider)

const SortedArray = artifacts.require('SortedArray');

contract("Array", async (accounts) => {

    var array;

    it("should add random elements", async () => {    
        array = await SortedArray.deployed(); 
        const testData = Array(10) // checking for 10 elements
        .fill()
        .map(() => Math.floor(50 * Math.random())); // numbers from 0-50 (exclusive)

        for (let i = 0; i < testData.length; i++) {
            await array.insert(testData[i])
            .then(function(){
                console.log("Added element "+testData[i]);
            });
        }
    });

    it("should display sorted array", async()=>{
        await array.getOrderbook()
        .then(async(result)=>{
            console.log("Array fetched is "+result);
        })
    })

    it("should remove max and min from array", async () => {
        await array.removeMax()
        .then(async(result)=>{
            console.log("Removed max element "+result);
            await array.removeMin()
            .then(function(result){
                console.log("Removed min element "+result);
            });
        });
    });

});