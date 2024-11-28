// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./Ibank.sol";
import {BankToken} from "./BankToken.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract TokenizedBank is Ibank {

    BankToken public bankToken;

    constructor (string memory name, string memory symbol) {
        bankToken = new BankToken(name, symbol);

}    
    function deposit(uint amount, address token) external {
         // transfer the users' token to the bank
        // used the transfer from because it allows a third party to initiate the function
        // transferFrom(address from, address to, uint amount)
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        
        // transfer bank token to the user
        // calculate how many tokens the user receives, USD 1 is BT 1
        // int256 mintAmount = IExchangeRateServce().getExchangeRate(token));



    }
    function withdraw(uint amount, address token) external {}
    function exchangeRate(address oracle) external view returns (int256) {
        
    }
    function getBalance (address account, address token) external view returns (uint) {}

}