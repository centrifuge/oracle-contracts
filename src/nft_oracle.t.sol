pragma solidity >=0.5.0 <0.6.0;

import "ds-test/test.sol";
import "./nft_oracle.sol";

contract AttributeOracleTest is DSTest {
    NFTOracle contracts;

    function setUp() public {
        address[] memory wards = new address[](1);
        wards[0] = address(3);
        contracts = new NFTOracle(address(1), address(2), 0x5a6f668df54545ee842e111a13c36d6b00000000000000000000000000000000, wards);
    }

    function test_risk_value() public {
        bytes32 result = 0x00000000000000000000000000000001000000000000000000000000000003e8;
        (uint80 risk, uint128 value) = contracts.getRiskAndValue(result);
        assertTrue(risk==1);
        assertTrue(value==1000);
    }
}
