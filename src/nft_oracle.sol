pragma solidity >=0.5.0 <0.6.0;

contract OwnerOfLike {
    function ownerOf(uint256 tokenId) public view returns (address);
}

contract NFTUpdateLike {
    function update(bytes32 nftID, uint value, uint risk) public;
}

contract NFTOracle {
    bytes32 fingerprint;

    // mapping (nftOwners => uint);
    mapping (address => uint) wards;

    // mapping (nftID => loanData);
    mapping (uint => NFTData) public nftData;

    // nft registry that holds the metadata for each nft
    OwnerOfLike ownerOf;

    // nft update that holds the value of NFT's risk and value
    NFTUpdateLike nftUpdate;

    struct NFTData {
        uint80 riskScore;
        uint128 value;
        uint48 timestamp;
    }

    event NFTValueUpdated(uint indexed tokenID);

    constructor (
        address _nftUpdate,
        address _registry,
        bytes32 _fingerprint,
        address[] memory _wards) public {

        fingerprint = _fingerprint;
        ownerOf = OwnerOfLike(_registry);
        nftUpdate = NFTUpdateLike(_nftUpdate);
        uint i;
        for (i=0; i<_wards.length; i++) {
            wards[_wards[i]] = 1;
        }
        wards[msg.sender] = 1;
    }

    function rely(address usr) public auth { wards[usr] = 1; }
    function deny(address usr) public auth { wards[usr] = 0; }
    modifier auth { require(wards[msg.sender] == 1); _; }
    modifier authToken(uint token) {
        require(wards[ownerOf.ownerOf(token)] == 1, "oracle/owner not allowed");
        _;
    }

    function update(uint tokenID, bytes32 _fingerprint, bytes32 _result) public authToken(tokenID) {
        require(fingerprint == _fingerprint, "oracle/fingerprint mismatch");
        (uint80 risk, uint128 value) = getRiskAndValue(_result);
        nftData[tokenID] = NFTData(risk, value, uint48(block.timestamp));

        // pass value to NFT update
        nftUpdate.update(keccak256(abi.encodePacked(address(ownerOf), tokenID)), uint(value), uint(risk));
        emit NFTValueUpdated(tokenID);
    }

    function getRiskAndValue(bytes32 _result) public pure returns (uint80, uint128) {
        bytes memory riskb = sliceFromBytes32(_result, 0, 16);
        bytes memory valueb = sliceFromBytes32(_result, 16, 32);
        return (uint80(toUint128(riskb)), toUint128(valueb));
    }

    function sliceFromBytes32(bytes32 data, uint start, uint end) internal pure returns (bytes memory) {
        bytes memory res = new bytes(end -start);
        for (uint i=0; i< end -start; i++){
            res[i] = data[i+start];
        }
        return res;
    }

    function toUint128(bytes memory _bytes) internal pure returns (uint128) {
        uint128 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x10), 0))
        }

        return tempUint;
    }
}
