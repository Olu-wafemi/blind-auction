-include .env

build:; forge build

deploy-sepolia:
	forge script script/Blindauction.s.sol:DeployBlindAuction --rpc-url $(SEPOLIA_RPC) --private-key  $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv