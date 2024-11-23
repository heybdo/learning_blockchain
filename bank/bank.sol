// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./ibank.sol";

// import ERC20 token interface so the bank knows 
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Bank is ibank {
    
    // mapping the users' address the token's address (all of them available) and then map it to the amount
    mapping(address => mapping (address => uint)) private accountBalances;


    constructor () {}
    function withdraw(uint amount, address token) external {


    }
    
    function deposit(uint amount, address token) external {
        // transfer the users' token to the bank
        // used the transfer from because it allows a third party to initiate the function
        // transferFrom(address from, address to, uint amount)
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        // update the users' balance 
        (accountBalances[msg.sender])[token] += amount;

    }
    
    function approvePayment(uint amount, address token) external {
        // transfer the funds back to the user
        IERC20(token).transfer(address(this), amount);
        // update the users' balance 
        (accountBalances[msg.sender])[token] -= amount;
    }
    
    function exchangeRate(address tokenA, address tokenB) external view {

    }
    
    function exchange(address tokenA, address tokenB, uint amount) external {

    }

    function getBalance (address account, address token) external view returns (uint) {
        return (accountBalances[account])[token];
    }

}