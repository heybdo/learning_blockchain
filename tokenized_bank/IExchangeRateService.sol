// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface IExchangeRateService {
    
    function getExchangeRate (address token) external view returns (int256);
    function setOracle (address[] calldata token, address[] calldata oracle) external;

}