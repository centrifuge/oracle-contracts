pragma solidity >=0.5.0 <0.6.0;

contract NFTUpdate {
    bytes32 nftID;
    uint value;
    uint risk;

    function update(bytes32 _nftID, uint _value, uint _risk) public{
        nftID = _nftID;
        value = _value;
        risk = _risk;
    }

    function nftData() public view returns (bytes32, uint, uint){
        return (nftID, value, risk);
    }
}
