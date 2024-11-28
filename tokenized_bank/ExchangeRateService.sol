// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
import "./IExchangeRateService.sol";
import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract ExchangeRateService is IExchangeRateService  {

    constructor () {}

    // table with token to oracle
    mapping (address token => address oracle) public oracles;
    
    function getExchangeRate(address token) external view returns (int256) {
        require(oracles[token] != address(0), "Token not accepted");
        // ask the oracle how much is the exchange rate
        (, int256 answer,,,) = AggregatorV3Interface(oracles[token]).latestRoundData();
        return answer;
        // make sure the exchange rate received is up to date



    }

    function setOracle (address[] calldata token, address[] calldata oracle) external {
        require(token.length == oracle.length, "Invalid parameters, lengths not match");
        for (uint i = 0; i <= token.length; i++) {
            oracles[token[i]] = oracle[i];
    }

}

}