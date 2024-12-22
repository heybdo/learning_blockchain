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

    function checkDeployment() public {
        Assert.ok(multisig.allowedSigners(TestsAccounts.getAccount(1)) == true, "AllowedSigner should be true");
    }

    function checkDeploymentUnsuccess() public {
        Assert.ok(multisig.allowedSigners(TestsAccounts.getAccount(2)) == false, "AllowedSigner should be false");
    }
}