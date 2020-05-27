pragma solidity ^0.5.15;

import "ds-test/test.sol";

import "./ChainlinkOracleContracts.sol";

contract ChainlinkOracleContractsTest is DSTest {
    ChainlinkOracleContracts contracts;

    function setUp() public {
        contracts = new ChainlinkOracleContracts();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
