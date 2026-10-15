# Harry Token

My fourth assignment: an ERC-20 token built with Solidity and Foundry.

| Setting | Value |
| --- | --- |
| Name | Harry Token |
| Symbol | HARRY |
| Initial supply | 1,000,000 tokens |
| Decimals | 18 |
| Network | Ethereum Sepolia |

The deployer receives the initial supply and owns the contract. Only the owner can mint more tokens or pause and unpause the contract. Holders can burn their tokens. Transfers, minting, and burning are blocked while paused. The initial supply is not a maximum supply.

The constructor takes the supply in whole tokens. `mint`, `transfer`, and `burn` take amounts in base units: one token is `10 ** 18` units.

## Files

- `src/HarryToken.sol` — token contract
- `test/HarryToken.t.sol` — Foundry tests
- `script/DeployHarryToken.s.sol` — deployment script
- `evidence/` — build and test output, plus screenshots when captured

## Build and test

Install [Foundry](https://getfoundry.sh/), then:

```sh
git clone --recurse-submodules https://github.com/Bookofharry/harry-token.git
cd harry-token
forge build
forge test -vv
```

The dependencies are pinned to OpenZeppelin Contracts v5.7.0 and forge-std v1.17.0. Solidity version: 0.8.28.

Tests cover the initial supply, metadata, transfers, minting permissions, pause/unpause, burning, allowances, ownership transfer, and invalid transfers. A fuzz test checks that transfers preserve the total supply.

## Deploy

Set `SEPOLIA_RPC_URL` and `PRIVATE_KEY` locally. The deployer needs Sepolia test ETH.

```sh
forge script script/DeployHarryToken.s.sol:DeployHarryToken --rpc-url sepolia --broadcast
```

The script is restricted to Sepolia and local chain ID 31337. It creates Harry Token with the name, symbol, and initial supply shown above.

Foundry saves the transaction in `broadcast/DeployHarryToken.s.sol/11155111/run-latest.json`. Check the receipt before reporting a successful deployment. Do not commit private keys or `.env` files.

## Assignment walkthroughs

- https://youtu.be/sTA-5AjY77w
- https://youtu.be/8DtvUzHmm10

## Submission status

Sepolia deployment and the final Google Doc are pending. No deployment transaction hash is available yet.
