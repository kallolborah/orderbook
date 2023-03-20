const { expect } = require("chai");
const Web3 = require('web3');
const provider = new Web3.providers.HttpProvider('http://localhost:8545')
const web3 = new Web3(provider)

const Heap = artifacts.require('Heap');

contract("Heap", async (accounts) => {

    var heap;

    it("should add random elements into sell orderbook", async () => {     
        heap = await Heap.deployed(); 
        const testData = Array(50) // checking for 10 elements
        .fill()
        .map(() => Math.floor(50 * Math.random())); // numbers from 0-50 (exclusive)

        for (let i = 0; i < testData.length; i++) {
            await heap.insertSellOrders(testData[i])
            .then(function(){
                console.log("Added element "+testData[i]);
            });
        }
    });

    it("should remove min from heap", async () => {
        await heap.getOrderbook()
        .then(async(result)=>{
            console.log("Heap fetched is "+result);
            await heap.getTop()
            .then(async(result)=>{
                console.log("Min element is "+result);
                await heap.removeMin()
                .then(async(result)=>{
                    console.log("Removed min heap element");
                    await heap.getOrderbook()
                    .then(async(result)=>{
                        console.log("Heap fetched after min removal is "+result);
                    })
                });
            });
        });
    });
    
});