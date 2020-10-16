set -ex

#NFT_UPDATE=${NFT_UPDATE:-0x677B85998F15921982B1548763F01Ac6C265B8Eb}
FINGERPRINT=${FINGERPRINT:-"0xcf00fae73fc7f9d09f8f7cd40b776de96055952b5e061d5bb6c3ddaa12794ad6"}
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

REGISTRY=${REGISTRY:-$NFT_UPDATE}
ORACLE=$(seth send --create out/NFTOracle.bin 'NFTOracle(address,address,bytes32,address[])' $NFT_UPDATE $REGISTRY $FINGERPRINT $WARDS)

set +ex
echo "-------------------------------------------------------------------------------"
echo "NFTOracle deployed to: $ORACLE"
echo "-------------------------------------------------------------------------------"
