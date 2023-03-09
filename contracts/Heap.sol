// SPDX-License-Identifier: MIT
pragma solidity 0.6.0;

import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";

contract Heap {
    using SafeMath for uint256;

    uint256[] public _orderbook;

    // Inserts adds in a value to our heap.
    //_value is price in the orderbook, _ref is order reference
    function insert(uint256 _value) public {
        // Add the value to the end of our array
        _orderbook.push(_value);

        // Start at the end of the array
        uint256 currentIndex = SafeMath.sub(_orderbook.length, 1);

        // Bubble up the value until it reaches it's correct place (i.e. it is smaller than it's parent)
        // parentIndex = Math.div[Math.sub(currentIndex, 1), 2, false]
        while (
            currentIndex > 0 &&
            _orderbook[SafeMath.div(SafeMath.sub(currentIndex, 0), 2)] <
            _orderbook[currentIndex]
        ) {
            // If the parent value is lower than our current value, we swap them
            uint256 temp = _orderbook[SafeMath.div(currentIndex, 2)];
            _orderbook[SafeMath.div(currentIndex, 2)] = _orderbook[
                currentIndex
            ];
            _orderbook[currentIndex] = temp;

            // change our current Index to go up to the parent
            currentIndex = SafeMath.div(currentIndex, 2);
        }
    }

    // RemoveMax pops off the root element of the heap (the highest value here) and rebalances the heap
    // This function is to be used when we need to find the max buy price for a new sell order 
    function removeMax() public returns (uint256) {
        // Ensure the heap exists
        require(_orderbook.length > 0, "Orderbook is not initialized");
        // take the root value of the heap
        uint256 toReturn = _orderbook[0];

        // Takes the last element of the array and put it at the root
        _orderbook[0] = _orderbook[SafeMath.sub(_orderbook.length, 1)];

        // Delete the last element from the array
        _orderbook.pop();

        // Start at the top
        uint256 currentIndex = 0;

        // Bubble down
        bubbleDown(currentIndex);

        // finally, return the top of the heap
        return toReturn;
    }

    // This function is to be used when we need to find the min sell price for a new buy order 
    function removeMin() public returns(uint256){
        uint256 toReturn = _orderbook[SafeMath.sub(_orderbook.length, 1)];
        _orderbook.pop();
        return toReturn;
    }

    function bubbleDown(uint256 currentIndex) public {
        while (SafeMath.mul(currentIndex, 2) < SafeMath.sub(_orderbook.length, 1)) {
            // get the current index of the children
            uint256 j = SafeMath.add(SafeMath.mul(currentIndex, 2), 1);

            // left child value
            uint256 leftChild = _orderbook[j];
            // right child value
            uint256 rightChild = _orderbook[SafeMath.add(j, 1)];

            // Compare the left and right child. if the rightChild is greater, then point j to it's index
            if (leftChild < rightChild) {
                j = SafeMath.add(j, 1);
            }

            // compare the current parent value with the highest child, if the parent is greater, we're done
            if (_orderbook[currentIndex] > _orderbook[j]) {
                break;
            }

            // else swap the value
            uint256 temporayOrder = _orderbook[currentIndex];
            _orderbook[currentIndex] = _orderbook[j];
            _orderbook[j] = temporayOrder;

            // and let's keep going down the heap
            currentIndex = j;
        }
    }

    function getOrderbook() public view returns (uint256[] memory) {
        return _orderbook;
    }

    function getMax() public view returns (uint256) {
        return _orderbook[0];
    }

    function getMin() public view returns (uint256) {
        return _orderbook[SafeMath.sub(_orderbook.length, 1)];
    }
}