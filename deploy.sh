set -ex

NFT_UPDATE=${NFT_UPDATE:-0x69504da6B2Cd8320B9a62F3AeD410a298d3E7Ac6}
REGISTRY=${REGISTRY:-0xa78C17921E7E060c246AC9575B01fF0Fb29BCeaE}
FINGERPRINT=${FINGERPRINT:-"0x949a96c5d7dd13f6e0ecec4aec9c7cd24cc9b6b4688146256dc565af9a3047f0"}
WARD=${WARD:-"0xf3BceA7494D8f3ac21585CA4b0E52aa175c24C25"}
TOKEN_HOLDERS=[]

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

ORACLE=$(seth send --create out/NFTOracle.bin 'NFTOracle(address,address,bytes32,address,address[])' $NFT_UPDATE $REGISTRY $FINGERPRINT $WARD $TOKEN_HOLDERS)

set +ex
echo "-------------------------------------------------------------------------------"
echo "NFTOracle deployed to: $ORACLE"
echo "-------------------------------------------------------------------------------"
