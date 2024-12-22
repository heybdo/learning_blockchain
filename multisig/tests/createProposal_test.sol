// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../Multisig.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {

    Multisig multisig;
    uint8 constant _totalSigners = 1;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'

    function beforeEach() public {
        // <instantiate contract> and add Remix test accounts as per Remix's documentation
        address[] memory accounts = new address[](_totalSigners);
        accounts[0] = TestsAccounts.getAccount(_totalSigners);
        multisig = new Multisig(accounts);

        Assert.equal(uint(_totalSigners), uint(_totalSigners), "1 should be equal to 1");
    }

    function createTransferEtherProposalSuccess() public {
        uint amount = 10 ether;
        
        multisig.createProposal(TestsAccounts.getAccount(2), 
                                amount, // amount
                                1, // required signer 1
                                ""
        ); // no call data

        Assert.ok(multisig.getProposalsLength() == 1, "Proposal was not created");
        Assert.equal(multisig.getProposalTo(0), TestsAccounts.getAccount(2), "Unexpected proposal");
        Assert.equal(multisig.getProposalAmount(0), amount, "Unexpected proposal");
        Assert.equal(multisig.getProposalCallData(0).length, 0, "Expected no call data");
        Assert.equal(multisig.getProposalExecuted(0), false, "Expected proposal to be yet be signed");
        Assert.equal(multisig.getProposalSignersCount(0), 0, "Expected no signers");

    }

    function createTransferEtherProposalFailureNoSigners() public {
        uint amount = 10 ether;
        try
            multisig.createProposal(TestsAccounts.getAccount(2), 
                                amount, // amount
                                0, // required signer 0
                                ""  // no call data
                                )
            { // v what happens if try is successful (NOT THE intention of the test)
                Assert.ok(false, "method execution should fail");
            }
            // v what happens if try is unsuccessful (intention of the test), also testing if the error message is what's expected
            catch Error (string memory reason){
                Assert.equal(reason, "At least one signer is required", "failed ");
        }
    }


    function createTransferEtherProposalFailureTooManySigners() public {
        uint amount = 10 ether;
        try
            multisig.createProposal(TestsAccounts.getAccount(2), 
                                amount, // amount
                                _totalSigners + 1, // required signer 1
                                ""  // no call data
                                )
            { // v what happens if try is successful (NOT THE intention of the test)
                Assert.ok(false, "method execution should fail");
            }
            // v what happens if try is unsuccessful (intention of the test), also testing if the error message is what's expected
            catch Error (string memory reason){
                Assert.equal(reason, "Nr of required signers can't exceed the number of total allowed signers", "failed ");
        }
    }

    function createTransferEtherProposalFailureNoAmountNoCallData() public {
        try
            multisig.createProposal(TestsAccounts.getAccount(2), 
                                0, // amount
                                _totalSigners, // required signer 1
                                ""  // no call data
                                )
            { // v what happens if try is successful (NOT THE intention of the test)
                Assert.ok(false, "method execution should fail");
            }
            // v what happens if try is unsuccessful (intention of the test), also testing if the error message is what's expected
            catch Error (string memory reason){
                Assert.equal(reason, "Proposal should do something. Amount, calldata or both", "failed ");
        }
    }

    function createTransferEtherProposalFailureAddressZero() public {
        uint amount = 100 ether;
        try
            multisig.createProposal(address(0), 
                                amount, // amount
                                _totalSigners, // required signer 1
                                ""  // no call data
                                )
            { // v what happens if try is successful (NOT THE intention of the test)
                Assert.ok(false, "method execution should fail");
            }
            // v what happens if try is unsuccessful (intention of the test), also testing if the error message is what's expected
            catch Error (string memory reason){
                Assert.equal(reason, "No transfers allowed to the address zero", "failed ");
        }
    }
}