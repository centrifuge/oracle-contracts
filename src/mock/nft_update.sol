pragma solidity >=0.5.0 <0.6.0;

contract NFTUpdate {
    bytes32 nftIDs;
    uint value;
    uint riskv;
    address owner;
    uint md;

    constructor() public {
        owner = msg.sender;
    }

    function update(bytes32 _nftID, uint _value, uint _risk) public {
        nftIDs = _nftID;
        value = _value;
        riskv = _risk;
    }

    function file(bytes32 name, bytes32 _nftID, uint _date) public {
        require(name=="maturityDate", "invalid name");
        require(_nftID == nftIDs, "invalid nftID");
        md = _date;
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

    function data(uint tokenID) public view returns (address, uint, bytes32, uint64) {
        return (address(0), tokenID, nftIDs, uint64(md));
    }

    function maturityDate(bytes32 tokenID) public view returns (uint) {
        return md;
    }
}
