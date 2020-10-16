all    :; dapp --use solc:0.5.0 build
clean  :; dapp --use solc:0.5.0 clean
test   :; dapp --use solc:0.5.0 test
deploy :; ./deploy.sh
update  :; ./update.sh
.PHONY : deploy update
