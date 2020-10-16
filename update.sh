set -ex

NFT_UPDATE=${NFT_UPDATE:-0x69504da6B2Cd8320B9a62F3AeD410a298d3E7Ac6}
REGISTRY=${REGISTRY:-"0xa78C17921E7E060c246AC9575B01fF0Fb29BCeaE"}
NFT_ID=${NFT_ID:-0xb3ded259d1112a1fc9d1a945e1c0d44f2da748246c1a25bb69dc2d23734af36e}
ORACLE=${ORACLE:-0x53c6afa03e9b30f6c69389cb63d1e83148022225}
FINGERPRINT=${FINGERPRINT:-"0x5fc3b5d083154f64446147e9044b3d837881e8874dcbfbfead8f3e3327d85b08"}
RESULT=${RESULT:-"0x00000000000000000000000000000001000000000000000000000000000003e8"}

 echo "Updating value "
 seth send $ORACLE "update(uint,bytes32,bytes32)" $NFT_ID $FINGERPRINT $RESULT

echo "Fetching value from Oracle"
seth call $ORACLE "nftData(uint)(uint80,uint128,uint64,uint48)" $NFT_ID

echo "Fetching Value and Risk from NFTFeed"
NFT_ID=$(seth call $NFT_UPDATE 'nftID(address,uint)(bytes32)' $REGISTRY $NFT_ID)
seth call $NFT_UPDATE 'nftValues(bytes32)(uint)' $NFT_ID
seth call $NFT_UPDATE 'risk(bytes32)(uint)' $NFT_ID
seth call $NFT_UPDATE "maturityDate(bytes32)(uint)" $NFT_ID
