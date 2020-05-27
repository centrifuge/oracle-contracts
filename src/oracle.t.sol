pragma solidity >=0.5.0 <0.6.0;

import "ds-test/test.sol";
import "./oracle.sol";

contract OracleTest is DSTest {
    Oracle contracts;

    function setUp() public {
        contracts = new Oracle(address(0), address(0), '5a6f668df54545ee842e111a13c36d6b', 1);
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
