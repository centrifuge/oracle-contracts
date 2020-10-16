set -ex

NFT_UPDATE=${NFT_UPDATE:-0x677B85998F15921982B1548763F01Ac6C265B8Eb}
REGISTRY=${REGISTRY:-0xbea49ad824ece7125bd3e6050fd1aa3eba16e5cd}
FINGERPRINT=${FINGERPRINT:-"0x5fc3b5d083154f64446147e9044b3d837881e8874dcbfbfead8f3e3327d85b08"}
WARDS=[]

dapp update
dapp --use solc:0.5.0 build --extract

# deploy mock contract if not set
if [[ -z "${NFT_UPDATE}" ]]; then
  echo "Deploying NFTUpdate contract"
  NFT_UPDATE=$(seth send --create out/NFTUpdate.bin 'NFTUpdate()')
  set +ex
  echo "-------------------------------------------------------------------------------"
  echo "NFTUpdate deployed to: $NFT_UPDATE"
  echo "-------------------------------------------------------------------------------"
fi

ORACLE=$(seth send --create out/NFTOracle.bin 'NFTOracle(address,address,bytes32,address[])' $NFT_UPDATE $REGISTRY $FINGERPRINT $WARDS)

set +ex
echo "-------------------------------------------------------------------------------"
echo "NFTOracle deployed to: $ORACLE"
echo "-------------------------------------------------------------------------------"
