const { expect } = require("chai");
const Web3 = require("web3");
const provider = new Web3.providers.HttpProvider("http://localhost:8545");
const web3 = new Web3(provider);

const Heap = artifacts.require("Heap");

contract("Heap", async (accounts) => {
  var heap;

  it("should add random elements into buy orderbook", async () => {
    heap = await Heap.deployed();
    const testData = [2,2,2,2,2,2,2,2]

    for (let i = 0; i < testData.length; i++) {
      await heap.insertBuyOrder(testData[i]).then(function () {
        console.log("Added element " + testData[i]);
      });
    }
  });

  it("should remove top from heap", async () => {
    await heap.getOrderbook().then(async (result) => {
      console.log("Heap fetched is " + result);
      await heap.getTop().then(async (result) => {
        console.log("max element is " + result);
        await heap.removeTop().then(async (result) => {
          console.log("Removed max heap element");
          await heap.getOrderbook().then(async (result) => {
            console.log("Heap fetched after min removal is " + result);
          });
        });
      });
    });
  });
});