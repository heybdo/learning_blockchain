pragma solidity ^0.8.20;

import "./erc20.sol";

contract allReady is ERC20 {

    uint public constant initialBalance = 100000;

    constructor (string memory name_, string memory symbol_) ERC20 (name_, symbol_) {
        _mint(msg.sender, initialBalance);
    }
}