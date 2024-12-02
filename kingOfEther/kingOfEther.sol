// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract KingOfEther {
    address payable public king;
    uint public throneAmount;
    uint constant INTMAX = 500 ether;

    event NewKing(address indexed oldKing, address indexed newKing, uint throneAmount);

    constructor () {
        king = payable(msg.sender);
        throneAmount = 500 wei;
    }

    function becomeKing () payable external {
        // requires the right amount to become the king;
        require(msg.value == throneAmount, "Not the right amount to become the King");
        // transfer the amount to the king, as right now the value sits in the contract
        king.transfer(msg.value);
        // emit the event
        emit NewKing(king, msg.sender, throneAmount);
        // electing the new king
        king = payable(msg.sender);
        if (throneAmount * 2 >= INTMAX) {
            throneAmount = 500 wei;
        } else {
            throneAmount = throneAmount * 2;
        }
    }
}  