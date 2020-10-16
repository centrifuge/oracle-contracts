set -ex

NFT_UPDATE=${NFT_UPDATE:-0x677B85998F15921982B1548763F01Ac6C265B8Eb}
REGISTRY=${REGISTRY:-"0xbea49ad824ece7125bd3e6050fd1aa3eba16e5cd"}
NFT_ID=${NFT_ID:-0xe328d5775b71de785855cb75fe5bb859b65f1fc246e8ded96be1385494f2f29a}
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
