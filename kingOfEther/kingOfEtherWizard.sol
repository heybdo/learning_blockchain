// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract KingOfEther {
    address payable public king;
    address payable public wizard;
    uint constant commission = 10;
    uint public wizardCommission;
    uint public wizardFees;
    uint public throneAmount;
    uint constant INTMAX = 500 ether;

    event NewKing(address indexed oldKing, address indexed newKing, uint throneAmount);

    constructor () {
        wizard = payable(msg.sender);
        king = wizard;
        throneAmount = 500 wei;
    }

    function becomeKing () payable external {
        // requires the right amount to become the king;
        require(msg.value == throneAmount, "Not the right amount to become the King");
        // defining value the wizard receives
        wizardCommission = msg.value * commission/100;
        // transfer wizard's fees to the pot
        wizardFees = wizardFees + wizardCommission;
        // transfer the amount to the king, as right now the value sits in the contract, minus the commission
        king.transfer(msg.value - wizardCommission);
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

    function withdrawFees () payable external {
        // requires to be onlyWizard accessing this function
        require(msg.sender == wizard, "Not wizard, can't access the function");
        // requires the amount to be withdrawn to be less than or equal to the existing pot
        require(msg.value <= wizardFees, "Trying to withdrawn less than what's available");
        // transfer the amount to the wizard
        wizard.transfer(msg.value);
        // reduce the wizardFees pot with the amount withdrawn
        wizardFees = wizardFees - msg.value;
    }

    function checkFees() external view returns (uint) {
        // requires to be onlyWizard accessing this function
        require(msg.sender == wizard, "Not wizard, can't access the function");
        return wizardFees;
    }
}  