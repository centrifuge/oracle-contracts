pragma solidity >=0.5.0 <0.6.0;

import "ds-test/test.sol";
import "./attribute_oracle.sol";

contract AttributeOracleTest is DSTest {
    AttributeOracle contracts;

    function setUp() public {
        contracts = new AttributeOracle(address(0), address(0), 0x5a6f668df54545ee842e111a13c36d6b00000000000000000000000000000000, 1);
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
