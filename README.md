# DEVS TOKEN

My fourth assignment: an ERC-20 token built with Solidity and Foundry.

| Setting | Value |
| --- | --- |
| Name | DEVS TOKEN |
| Symbol | DEVS |
| Initial supply | 1,000,000 tokens |
| Decimals | 18 |
| Network | Ethereum Sepolia |

The deployer receives the initial supply and owns the contract. Only the owner can mint more tokens or pause and unpause the contract. Holders can burn their tokens. Transfers, minting, and burning are blocked while paused. The initial supply is not a maximum supply.

The constructor takes the supply in whole tokens. `mint`, `transfer`, and `burn` take amounts in base units: one token is `10 ** 18` units.

## Files

- `src/DevsToken.sol` — token contract
- `test/DevsToken.t.sol` — Foundry tests
- `script/DeployDevsToken.s.sol` — deployment script
- `evidence/` — build and test output, plus screenshots when captured

## Build and test

Install [Foundry](https://getfoundry.sh/), then:

```sh
git clone --recurse-submodules https://github.com/Bookofharry/devs-token.git
cd devs-token
forge build
forge test -vv
```

The dependencies are pinned to OpenZeppelin Contracts v5.7.0 and forge-std v1.17.0. Solidity version: 0.8.28.

Tests cover the initial supply, metadata, transfers, minting permissions, pause/unpause, burning, allowances, ownership transfer, and invalid transfers. A fuzz test checks that transfers preserve the total supply.

## Deploy

Set `SEPOLIA_RPC_URL` and `PRIVATE_KEY` locally. The deployer needs Sepolia test ETH.

```sh
forge script script/DeployDevsToken.s.sol:DeployDevsToken --rpc-url sepolia --broadcast --gas-estimate-multiplier 800
```

The script is restricted to Sepolia and local chain ID 31337. It creates DEVS TOKEN with the name, symbol, and initial supply shown above.

Foundry saves the transaction in `broadcast/DeployDevsToken.s.sol/11155111/run-latest.json`. Check the receipt before reporting a successful deployment. Do not commit private keys or `.env` files.

## Assignment walkthroughs

- https://youtu.be/sTA-5AjY77w
- https://youtu.be/8DtvUzHmm10

## Submission status

Deployed successfully on Ethereum Sepolia.

- Contract: `0x08c2d0E81A04E71a77253FE115C4E8fe3f6d210D`
- Transaction: `0x9772154e6b6480956bb4810f5e910cb04529ccb0ab0228bd7528d0d7b5bb96b9`
- [View deployment](https://sepolia.etherscan.io/tx/0x9772154e6b6480956bb4810f5e910cb04529ccb0ab0228bd7528d0d7b5bb96b9)

The first deployment attempt ran out of gas. The successful retry used a higher gas limit after checking the RPC estimate. Public receipt and contract details are in `evidence/sepolia-deployment.json`.

The final Google Doc still needs to be uploaded and shared with anyone who has its link.
