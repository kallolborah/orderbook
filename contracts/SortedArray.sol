// SPDX-License-Identifier: MIT
pragma solidity 0.6.0;

import "@openzeppelin/contracts-ethereum-package/contracts/utils/Arrays.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";

contract SortedArray {

    using SafeMath for uint256;

    uint256[] public _orderbook;

    // insert new order into orderbook
    function insert(uint256 _value) public {

        uint256 placeElement = Arrays.findUpperBound(_orderbook, _value);

        if(placeElement==_orderbook.length){
            //if _value is larger than all _orderbook elements
            _orderbook.push(_value);
        }
        else{
            //else, place value in placeElement in _orderbook and push everything onwards till end of _orderbook
            uint256 replacedValue = _orderbook[placeElement];
            _orderbook[placeElement] = _value;  
            for(uint256 i=placeElement+1; i<_orderbook.length; i++){
                uint256 toReplace = _orderbook[i];
                _orderbook[i] = replacedValue;
                replacedValue = toReplace;
            }
            _orderbook.push(replacedValue);
        }

    }

    // This function is to be used when we need to find the max buy price for a new sell order 
    function removeMax() public returns (uint256) {
        
        uint256 maxValue = _orderbook[SafeMath.sub(_orderbook.length, 1)];
        _orderbook.pop();
        return maxValue;
    }

    // This function is to be used when we need to find the min sell price for a new buy order 
    function removeMin() public returns(uint256){

        uint256 minValue = _orderbook[0];
        for(uint256 i=0; i<_orderbook.length-1; i++){
            _orderbook[i] = _orderbook[SafeMath.add(i, 1)];
        }
        _orderbook.pop();
        return minValue;
    }

    function getOrderbook() public view returns (uint256[] memory) {
        return _orderbook;
    }

    function getMax() public view returns (uint256) {
        return _orderbook[SafeMath.sub(_orderbook.length, 1)];
    }

    function getMin() public view returns (uint256) {
        return _orderbook[0];
    }

}