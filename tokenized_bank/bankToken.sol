// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BankToken is ERC20 {
    
    constructor (string memory name_, string memory symbol_) ERC20(name_, symbol_) {}
}