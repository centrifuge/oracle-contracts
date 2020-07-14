pragma solidity >=0.5.0 <0.6.0;

import "ds-test/test.sol";
import "./nft_oracle.sol";

contract AttributeOracleTest is DSTest {
    NFTOracle contracts;

    function setUp() public {
        contracts = new NFTOracle(address(1), address(2), 0x5a6f668df54545ee842e111a13c36d6b00000000000000000000000000000000, 1, address(0), 0xe24e7917d4fcaf79095539ac23af9f6d5c80ea8b0d95c9cd860152bff8fdab17, 0x04f4bbcee9e17fb50627e11537551204ea5e00b1ed198492154b040c28704794);
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
