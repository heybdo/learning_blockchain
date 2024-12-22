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
    address _signer = TestsAccounts.getAccount(0);

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'

    function beforeEach() public {
        // <instantiate contract> and add Remix test accounts as per Remix's documentation
        address[] memory accounts = new address[](_totalSigners);
        accounts[0] = _signer;
        multisig = new Multisig(accounts);

        Assert.equal(uint(_totalSigners), uint(_totalSigners), "1 should be equal to 1");

        multisig.createProposal(TestsAccounts.getAccount(2), 
                                10 ether, // amount
                                1, // required signer 1
                                ""
        ); // no call data
    }

    /// #value: 0
    /// #sender: account-0
    function signProposalSuccess() public {
        // check if account is signer
        Assert.equal(TestsAccounts.getAccount(0), _signer, "Signer should be account 0");
        // check if it's in authorised signer
        Assert.equal(multisig.allowedSigners(_signer), true, "Signer should be in allowed signers");
        // check if it's the msg.sender
        Assert.equal(_signer, msg.sender, "Signer should be in allowed signers");
        uint proposalIndex = 0;
        try multisig.sign(proposalIndex)
        {
            Assert.ok(true, "expected method to succeed");
            Assert.ok(multisig.getProposalSignersCount(proposalIndex) > 0, "No array found");
            Assert.equal(multisig.getSigners(proposalIndex)[0],_signer, "signer");
        }
        catch Error (string memory reason) {
            Assert.ok(false, reason);
        }
    }
}