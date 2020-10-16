set -ex

NFT_UPDATE=${NFT_UPDATE:-0xf58a62b13fe069e95205debc639993b3034acb85}
REGISTRY=${REGISTRY:-"0xf58a62b13fe069e95205debc639993b3034acb85"}
NFT_ID=${NFT_ID:-0x2d122f02dd3a93951ff6d71afb580373cbc08790daa046a61de337ae807fc93f}
ORACLE=${ORACLE:-0x2038ca0b488a7cf6ae7c1264b40a918cd3af4af6}
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
