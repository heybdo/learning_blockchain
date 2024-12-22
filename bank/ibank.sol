// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface ibank {
    
    function withdraw(uint amount, address token) external;
    function deposit(uint amount, address token) external;
    function exchangeRate(address oracle) external view returns (int256);
    function getBalance (address account, address token) external view returns (uint);
}