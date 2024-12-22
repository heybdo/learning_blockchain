// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./ITreasuryService.sol";

contract TreasureService is ITreasuryService {
    
    mapping (address => uint) public balances;
    
    constructor() {}

    receive() external payable {
        balances[msg.sender] += msg.value;
    }

    // @notice Is used to transfer ether from this contract to an address
    // @dev 
    // @param to The address will receive the ether
    // @param amount The amount of ether to be sent (in WEI)
    function send(address to, uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Transfer amount is more than available balance");
        payable(to).transfer(amount);
        balances[msg.sender] - amount;
    }

    function balanceOf(address account) internal view returns (uint) {
        return balances[account];
    }
}