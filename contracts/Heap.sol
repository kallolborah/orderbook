// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

// import "hardhat/console.sol";

contract Heap {

    uint256[] internal _orderbook;

    // Inserts a buy order into buyorderbook and put order with highest price at first position
    function insertBuyOrder(uint256 _value) external {
        //insert buy order
        _orderbook.push(_value);
        uint256 currentIndex = _orderbook.length - 1;
        //push order with highest price to first position
        _bubbleUpForMax(currentIndex);
    }

    // Inserts a sell order into sellorderbook and put order with lowest price at first position
    function insertSellOrder(uint256 _value) external {
        //insert buy order
        _orderbook.push(_value);
        uint256 currentIndex = _orderbook.length - 1;
        //push order with lowest price to first position
        _bubbleUpForMin(currentIndex);
    }

    // Remove, return buy order with the highest price and balance buyorders heap
    //position the highest price buy order after the one removed to first position
    function removeTop() external returns (uint256) {
        require(_orderbook.length > 0, "Orderbook is empty");
        uint256 toReturn = _orderbook[0]; //buy order with highest price
        uint256 lastIndex = _orderbook.length - 1;

        if (lastIndex > 0) {
            //replace first order with last order
            _orderbook[0] = _orderbook[lastIndex];
            //delete last order  //Todo: No Amount/value filled check????
            _orderbook.pop();
            //rebalance buy orders heap to push highest price to first position 
            //startIndex is 0
            _bubbleDownForMax(0);
        } else {
            //if just one order delete it and move on
            _orderbook.pop();
        }
        //return order with highest price
        return toReturn;
    }

    // Remove, return the lowest price sell order and balance sellorders heap
    //position the lowest price sell order after the one removed to first position
    function removeMin() external returns (uint256) {
        require(_orderbook.length > 0, "Orderbook is empty");
        uint256 toReturn = _orderbook[0]; //sell order with lowest price
        uint256 lastIndex = _orderbook.length - 1;

        if (lastIndex > 0) {
            //replace first order with last order
            _orderbook[0] = _orderbook[lastIndex];
             //delete last order //Todo: No Amount/value filled check????
            _orderbook.pop();
             //rebalance sell orders heap to push lowest price to first position
             //startIndex is 0
            _bubbleDownForMin(0);
        } else {
            //if just one order delete it and move on
            _orderbook.pop();
        }
        return toReturn;
    }


    //return allsellorderbook
    function getOrderbook() external view returns (uint256 [] memory) {
        return _orderbook;
    }



    //return buy order with highest price
    function getTop() external view returns (uint256) {
        require(_orderbook.length > 0, "Buy Orderbook is empty");
        return _orderbook[0];
    }


    function _bubbleUpForMax(uint256 currentIndex) private {
        //skip heap balancing for first buy order and orders that are rebalanced to first position;
        while (currentIndex > 0) {
            // get parentIndex using formula's constant
            uint256 parentIndex = (currentIndex - 1) / 2;
            // console.logUint(parentIndex);

            //stop heap balancing if parentOrder price is greater than new/updated-new order price
            if (_orderbook[currentIndex] <= _orderbook[parentIndex]) {
                break;
            }
            //swap order positions till higher/highest price is at first position
            _swapBuyOrder(currentIndex, parentIndex);
            //update current index to parent for buy orders heap-rebalancing
            currentIndex = parentIndex;
        }
    }

    function _bubbleUpForMin(uint256 currentIndex) private {
        //skip heap balancing for first sell order and orders that are rebalanced to first position;
        while (currentIndex > 0) {
             // get parentIndex using formula's constant
            uint256 parentIndex = (currentIndex - 1) / 2;
            // console.logUint(parentIndex);

            //stop heap balancing if parentOrder price is lesser than new/updated-new order price
            if (_orderbook[currentIndex] >= _orderbook[parentIndex]) {
                break;
            }
            //swap order positions till lower/lowest price is at first position
            _swapSellOrder(currentIndex, parentIndex);
             //update current index to parent for sell orders heap-rebalancing
            currentIndex = parentIndex;
        }
    }

    //===== Bubble Down Formula =====
        //startIndex(leftChild) = a * 2 + 1
        //nextIndex(rightChild) = a * 2 + 2
        //since orders are inserted using the logic from Bubble Up
        //a consecutive run through can be done for orders starting with next 2 orders at a calculated position from current/lastchecked order
        //comparing them to current order or last checked order for heap balancing
    
    function _bubbleDownForMax(uint256 currentIndex) private {
        uint256 length = _orderbook.length;
        //run through all orders till heap is balance and stop
        while (true) {
            //start from a calculated order position since position is known from how they are inserted
            uint256 startIndex = currentIndex * 2 + 1; 
            //go to next order position after calculated position
            uint256 nextIndex = currentIndex * 2 + 2; //go to the next one 
            
            //highest order is assumed to be current order or last checked order(for rebalancing)
            uint256 higherOrderPriceIndex = currentIndex;
            
            //compare start and next order prices to largest/current order or last checked order(for rebalancing)
            if (startIndex < length && _orderbook[startIndex] > _orderbook[higherOrderPriceIndex]) {
                higherOrderPriceIndex = startIndex;
            }

            if (nextIndex < length && _orderbook[nextIndex] > _orderbook[higherOrderPriceIndex]) {
                higherOrderPriceIndex = nextIndex;
            }

            //Stop if both start and next order have no price higher than current;
            if (higherOrderPriceIndex == currentIndex) break;
            
            //if any of start or next order has higher price 
            //swap order positions till higher/highest price is at first position
            _swapBuyOrder(currentIndex, higherOrderPriceIndex);

            //update current order to last checked order for heap-rebalancing
            currentIndex = higherOrderPriceIndex;
        }
    }

    function _bubbleDownForMin(uint256 currentIndex) private {
        uint256 length = _orderbook.length;
        //run through all orders till heap is balance and stop
        while (true) {
            //start from a calculated order position since position is known from how they are inserted
            uint256 startIndex = currentIndex * 2 + 1;
            //go to next order position after calculated position
            uint256 nextIndex = currentIndex * 2 + 2;
            //lowest order is assumed to be current order or last checked order(for rebalancing)
            uint256 lowestOrderPriceIndex = currentIndex;

             //compare start and next order prices to lowest/current order or last checked order(for rebalancing)
            if (startIndex < length && _orderbook[startIndex] < _orderbook[lowestOrderPriceIndex]) {
                lowestOrderPriceIndex = startIndex;
            }

            if (nextIndex < length && _orderbook[nextIndex] < _orderbook[lowestOrderPriceIndex]) {
                lowestOrderPriceIndex = nextIndex;
            }
            //Stop if both start and next order have no price lower than current;
            if (lowestOrderPriceIndex == currentIndex) break;

            //if any of start or next order has lower price 
            //swap order positions till lower/lowest price is at first position
            _swapSellOrder(currentIndex, lowestOrderPriceIndex);

            //update current order to last checked order for heap-rebalancing
            currentIndex = lowestOrderPriceIndex;
        }
    }

    //swap buy orders positions and their ref => index mapping
    function _swapBuyOrder(uint256 i, uint256 j) private {
        uint256 temp = _orderbook[i];
        _orderbook[i] = _orderbook[j];
        _orderbook[j] = temp;
    }

    //swap sell orders positions and their ref => index mapping
    function _swapSellOrder(uint256 i, uint256 j) private {
        uint256 temp = _orderbook[i];
        _orderbook[i] = _orderbook[j];
        _orderbook[j] = temp;
    }

}
