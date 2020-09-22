pragma solidity >=0.5.0 <0.6.0;

contract NFTUpdate {
    bytes32 nftIDs;
    uint value;
    uint riskv;
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function update(bytes32 _nftID, uint _value, uint _risk) public {
        nftIDs = _nftID;
        value = _value;
        riskv = _risk;
    }

    function nftValues(bytes32) public view returns (uint){
        return value;
    }

    function risk(bytes32) public view returns (uint){
        return riskv;
    }

    function nftID(address registry, uint tokenId) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(registry, tokenId));
    }

    function ownerOf(uint256) public view returns (address) {
        return owner;
    }
}
