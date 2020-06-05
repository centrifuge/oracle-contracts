pragma solidity >=0.5.0 <0.6.0;

import "./chainlink/src/v0.5/ChainlinkClient.sol";

contract AttributeOracle is ChainlinkClient {
    uint256 oraclePayment;
    bytes32 jobID;
    mapping (bytes32 => mapping(bytes32 => bytes32)) public values;
    mapping (bytes32 => Request) requests;

    struct Request {
        bytes32 documentID;
        bytes32 attributeKey;
    }

    constructor (address _link, address _oracle, bytes32 _jobID, uint256 _oraclePayment) public {
        if(_link == address(0)) {
            setPublicChainlinkToken();
        } else {
            setChainlinkToken(_link);
        }
        setChainlinkOracle(_oracle);
        oraclePayment = _oraclePayment;
        jobID = _jobID;
    }

    function fetchAttribute(bytes32 _documentID, bytes32 _attributeKey) public {
        Chainlink.Request memory req = buildChainlinkRequest(jobID, address(this), this.fulfill.selector);
        req.add("method", "read");
        req.addBytes("documentID", bytes32ToBytes(_documentID));
        req.addBytes("attribute", bytes32ToBytes(_attributeKey));
        bytes32 requestID = sendChainlinkRequest(req, oraclePayment);
        requests[requestID] = Request(_documentID, _attributeKey);
    }

    function bytes32ToBytes(bytes32 _bytes32) internal pure returns (bytes memory){
        bytes memory bytesArray = new bytes(32);
        for (uint256 i; i < 32; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return bytesArray;
    }

    function fulfill(bytes32 _requestID, bytes32 _result) public recordChainlinkFulfillment(_requestID) {
        require(requests[_requestID].documentID > 0, "oracle/request doesn't exists");
        Request memory request = requests[_requestID];
        delete requests[_requestID];
        values[request.documentID][request.attributeKey] = _result;
    }
}
