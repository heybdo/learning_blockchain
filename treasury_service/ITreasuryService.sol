// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// @title Public infrastructure treasure contract
// @author Tone, Simanito, bdo
// @notice Can be used by anyone to store and move funds in the blockchain
// @dev This contract does not allow code exucetion. Only ether transfers
// @custom:educational This is an educational contract

interface ITreasuryService {
    receive() external payable;
    function send(address to, uint amount) external;
    }