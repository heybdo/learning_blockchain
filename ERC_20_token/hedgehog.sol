// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Hedgehog {

// creating a mapping between the address and the balances

string private _name;
string private _symbol;
mapping (address => uint) private balances;
uint public totalSupply = 0;
uint public constant initialBalance = 10000000;

constructor(string memory tokenName, string memory tokenSymbol) {
    
    _name = tokenName;
    _symbol = tokenSymbol;

    // add the initial balance to total supply
    totalSupply += initialBalance;
    // when the contract is created, the creator will receive 1k tokens
    balances [msg.sender] = initialBalance;
}



// return the balance of the given account
function balanceOf(address _account) view public returns (uint _amount) {
    return balances[_account];
}


// transfer the tokens to other address
function transfer(address _recipient, uint _amount) public {
    // requires that it has enough balance to transfer to another
    require(balances[msg.sender] >= _amount, "Insufficient balance");
    // remove amount from who's sending it
    balances [msg.sender] -= _amount;
    // add amount to whom we are sending it
    balances [_recipient] += _amount;
} 


// return the symbol of the contract

function symbol() view public returns (string memory) {
    return _symbol;
}

function name() view public returns (string memory) {
    return _name;
}

function decimals() public view virtual returns (uint8) {
  return 4;
}

}