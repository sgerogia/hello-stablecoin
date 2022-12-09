#! /usr/bin/make

# Replace with your own values, before executing the 'test-client' target
ENV_VARS = NATWEST_SANDBOX_CLIENT_ID=<YOUR_ID> NATWEST_SANDBOX_CLIENT_SECRET=<YOUR_SECRET> NATWEST_SANDBOX_CUSTOMER_USERNAME=<PAYER_CUST_ID@SANDBOX_DOMAIN> NATWEST_SANDBOX_REDIRECT_URL=<YOUR_HTTP(S)_URL>

build-contract:
	cd chain && npx hardhat compile

test-contract:
	cd chain && npx hardhat test

generate-abi: build-contract
	cd tpp-client && cat ../chain/artifacts/contracts/ProvableGBP.sol/ProvableGBP.json \
   		| jq '.abi' \
   		| abigen --abi - \
		  --type ProvableGBP \
		  --pkg contract \
		  --out contract/provable_gbp.go \
		  --bin ../chain/artifacts/contracts/ProvableGBP.bin

test-client:
	cd tpp-client && $(ENV_VARS) go test ./...

build-client: generate-abi
	cd tpp-client && go build -o tpp ./cmd && chmod +x ./tpp