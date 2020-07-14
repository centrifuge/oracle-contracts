pragma solidity >=0.5.0 <0.6.0;

import "./chainlink/src/v0.5/ChainlinkClient.sol";

contract TokenDataLike {
    function data(uint nftID) public view returns (address, uint, bytes32, uint64);
}

contract NFTOracle is ChainlinkClient {
    uint256 oraclePayment;
    bytes32 jobID;
    bytes32 attributeKey;
    bytes32 fingerprint;

    // mapping (nftID => loanData);
    mapping (uint => NFTData) public nftData;

    // mapping (requestId => nftID)
    mapping (bytes32 => uint) requests;

    // nft registry that holds the metadata for each nft
    TokenDataLike tokenData;

    struct NFTData {
        uint nftID;
        uint128 riskScore;
        uint128 value;
        uint48 timestamp;
    }

    event NFTValueRequested(uint indexed nftID);
    event NFTValueFetched(uint indexed nftID);

    constructor (
        address _link,
        address _oracle,
        bytes32 _jobID,
        uint256 _oraclePayment,
        address _registry,
        bytes32 _attributeKey,
        bytes32 _fingerprint) public {

        if(_link == address(0)) {
            setPublicChainlinkToken();
        } else {
            setChainlinkToken(_link);
        }
        setChainlinkOracle(_oracle);
        oraclePayment = _oraclePayment;
        jobID = _jobID;
        attributeKey = _attributeKey;
        fingerprint = _fingerprint;
        tokenData = TokenDataLike(_registry);
    }

    function fetchNFTData(uint _nftID) internal {
        (, , bytes32 documentID, ) = tokenData.data(_nftID);
        require(documentID != 0 , "not a valid document ID");
        Chainlink.Request memory req = buildChainlinkRequest(jobID, address(this), this.fulfill.selector);
        req.add("method", "read");
        req.addBytes("documentID", bytes32ToBytes(documentID));
        req.addBytes("attribute", bytes32ToBytes(attributeKey));
        req.addBytes("fingerprint", bytes32ToBytes(fingerprint));
        bytes32 requestID = sendChainlinkRequest(req, oraclePayment);
        requests[requestID] = _nftID;
        emit NFTValueRequested(_nftID);
    }

    function bytes32ToBytes(bytes32 _bytes32) internal pure returns (bytes memory){
        bytes memory bytesArray = new bytes(32);
        for (uint256 i; i < 32; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return bytesArray;
    }

    function fulfill(bytes32 _requestID, bytes32 _result) public recordChainlinkFulfillment(_requestID) {
        require(requests[_requestID] > 0, "oracle/request doesn't exists");
        uint256 nftID = requests[_requestID];
        delete requests[_requestID];
        (uint128 risk, uint128 value) = getRiskAndValue(_result);
        nftData[nftID] = NFTData(nftID, risk, value, uint48(block.timestamp));
        emit NFTValueFetched(nftID);
    }

    function getRiskAndValue(bytes32 _result) internal pure returns (uint128, uint128) {
        bytes memory riskb = sliceFromBytes32(_result, 0, 16);
        bytes memory valueb = sliceFromBytes32(_result, 16, 32);
        return (abi.decode(riskb, (uint128)), abi.decode(valueb, (uint128)));
    }

    function sliceFromBytes32(bytes32 data, uint start, uint length) internal pure returns (bytes memory) {
        require(length<=32, "length cannot be more than 32");
        bytes memory res = new bytes(length);
        for (uint i=0; i<length; i++){
            res[i] = data[i+start];
        }
        return res;
    }

    function onTokenTransfer(address, uint256 _amount, bytes memory _data) public {
        require(msg.sender == chainlinkTokenAddress(), "Only LINK can call");
        require(_amount == oraclePayment, "Not enough LINK");
        (uint nftID) = abi.decode(_data, (uint));
        fetchNFTData(nftID);
    }
}
