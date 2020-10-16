set -ex

NFT_UPDATE=${NFT_UPDATE:-0x0879c09b166880cd674d9c50a1538e98fb88cd0d}
REGISTRY=${REGISTRY:-"0x0879c09b166880cd674d9c50a1538e98fb88cd0d"}
NFT_ID=${NFT_ID:-0x2d122f02dd3a93951ff6d71afb580373cbc08790daa046a61de337ae807fc93f}
ORACLE=${ORACLE:-0x478ac5dff71065db2a587f73655597e0371fd34d}
FINGERPRINT=${FINGERPRINT:-"0xcf00fae73fc7f9d09f8f7cd40b776de96055952b5e061d5bb6c3ddaa12794ad6"}
RESULT=${RESULT:-"0x00000000000000000000000000000001000000000000000000000000000003e8"}

 echo "Updating value "
 seth send $ORACLE "update(uint,bytes32,bytes32)" $NFT_ID $FINGERPRINT $RESULT

echo "Fetching value from Oracle"
seth call $ORACLE "nftData(uint)(uint80,uint128,uint64,uint48)" $NFT_ID

echo "Fetching Value and Risk from NFTFeed"
NFT_ID=$(seth call $NFT_UPDATE 'nftID(address,uint)(bytes32)' $REGISTRY $NFT_ID)
seth call $NFT_UPDATE 'nftValues(bytes32)(uint)' $NFT_ID
seth call $NFT_UPDATE 'risk(bytes32)(uint)' $NFT_ID
