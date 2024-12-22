// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// @title A contract requires multiple signers to execute transactions
// @author Tone, Simanito, BdO
// @notice You can send ether only if some of the signers approve
// @dev This contract does not allow code exucetion. Only ether transfers
// @custom:educational This is an educational contract

contract Multisig {

    mapping (address => bool) public allowedSigners;
    uint totalSigners = 0;

    modifier proposalExists(uint index) {
        // verify that the proposal exists
        require(proposals.length >= index, "Proposal doesn't exist");
        _;
    }

    struct Transaction {
        // which address receives the amount
        address to;
        // how much amount to transfer
        uint amount;
        // to define if it's already executed or not;
        bool executed;
        // to be able to call the other contract
        bytes callData;
    }

    struct Proposal {
        uint8 requiredSigners;
        address[] signers;
        Transaction transaction;
    }

    Proposal[] public proposals;

    constructor (address[] memory _allowedSigners) payable {
        for (uint i = 0; i < _allowedSigners.length; i++) {
            // adds the address to the mapping and true as the bool   
            allowedSigners[_allowedSigners[i]] = true;
        }

        totalSigners = _allowedSigners.length;

    }


    // @notice Adds a signature to a proposal
    // @dev pushes the signer address to the signers array in the proposal
    // @param index represents the proposal to be signed

    function sign(uint index) external proposalExists (index) {
        // verify the address can sign it
        require(allowedSigners[msg.sender], "Unauthorized signer");
        // verify the address hasn't yet signed
        for (uint i = 0; i < proposals[index].signers.length; i++) {
            if (proposals[index].signers[i] == msg.sender) {
                revert("Proposal already signed by signer");
            } 
        }
        // Adicionar msg.sender ao "signers". Passou a verificação, assinou
        proposals[index].signers.push(msg.sender);
    }

    function createProposal(address to, uint amount, uint8 requiredSigners, bytes calldata callData) external payable {
        // require the number of required signers to not exceed the nr of total signers
        require(requiredSigners <= totalSigners, "Nr of required signers can't exceed the number of total allowed signers");
        // require at least one signer for proposal's creation
        require(requiredSigners > 0, "At least one signer is required");
        // translating the callData into an amount to check if it has something and if it does, the call data field was filled with something, and checks if the amount is different than zero
        require(callData.length + amount > 0, "Proposal should do something. Amount, calldata or both");
        require(to != address(0), "No transfers allowed to the address zero");
        Transaction memory newTransaction = Transaction(to, amount, false, callData);
        Proposal memory newProposal = Proposal(requiredSigners, new address[](0), newTransaction);
        proposals.push(newProposal);
    }

    function getSigners(uint index) public view returns (address[] memory){
        return proposals[index].signers;
    }


    // @notice tries to execute a transaction inside a proposal
    // @dev uses address.transfer()
    // @param references the proposal to be signed
    function executeProposal(uint index) proposalExists (index) external {
        // verify the proposal has the required number of signatures
        require(proposals[index].signers.length >= proposals[index].requiredSigners, "Not enough signers");
        // verify if the contract has funds
        require(address(this).balance >= proposals[index].transaction.amount, "Not enough balance");
        // verify the proposal hasn't been executed yet
        require(proposals[index].transaction.executed == false, "Proposal already executed");
        // transfer the ether
        address payable _to = payable(proposals[index].transaction.to);
        uint _amount = proposals[index].transaction.amount;
        bytes memory _callData = proposals[index].transaction.callData;
        uint _calldataLength = _callData.length;
        // comparison is to 0 since bytes are an array
        if (_callData.length == 0) { _to.transfer(_amount); }
            else {
                bool result;
                assembly {
                    let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
                    let d := add(_callData, 32) // First 32 bytes are the padded length of data, so exclude that
                    result := call(
                        gas(),
                        _to,
                        _amount,
                        d,
                        _calldataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
                        x,
                        0                  // Output is ignored, therefore the output size is zero
                    )
                }
            }

        proposals[index].transaction.executed = true;
    }

    function receiveFunds() external payable {}

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    // GETTERS
    
    function getProposalTo(uint index) external view returns (address) {
        return proposals[index].transaction.to;
    }
    
    function getProposalAmount(uint index) external view returns (uint amount) {
        return proposals[index].transaction.amount;
    }

    function getProposalsLength() external view returns (uint) {
        return proposals.length;
    }

    function getProposalCallData(uint index) external view returns (bytes memory) {
        return proposals[index].transaction.callData;
    }


    function getProposalExecuted(uint index) external view returns (bool) {
        return proposals[index].transaction.executed;
    }

    function getProposalSignersCount(uint index) external view returns (uint) {
        return proposals[index].signers.length;
    }

    function getProposalSigners(uint index) external view returns (address[] memory) {
        return proposals[index].signers;
    }

 }