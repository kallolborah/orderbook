
const heap = artifacts.require('Heap');
const array = artifacts.require('Array');

module.exports = function(deployer, network, accounts) {

    deployer.deploy(heap);
    deployer.deploy(array);

}