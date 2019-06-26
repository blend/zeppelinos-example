# Making Ethereum Smart Contracts Upgradable

*With ZeppelinOS 2.3 and Truffle 5*

This repo contains the example code for the tutorial on upgradable smart contracts in
[Full Stack Finance: The Blend Engineering Blog](https://medium.com/blend-engineering).
This code aims to demonstrate, via a simple example, the steps that must be taken to deploy
any Truffle project as an upgradable [ZeppelinOS](https://zeppelinos.org/) contract.

The main steps are as follows:
1. Install and set up ZeppelinOS. [[3dc40f]](https://github.com/blend/zeppelinos-example/commit/3dc40f1d7fdd9b1689bda5a98c6a364aa871aa4f)
2. Modify the contract and its base contracts to use initializer instead of constructors. [[eb84c5]](https://github.com/blend/zeppelinos-example/commit/eb84c59506ea38d5e0c0f91a3485917340beea3b)
3. Update the migrations. [[8d4a32]](https://github.com/blend/zeppelinos-example/commit/8d4a32d326a337666e73c90d99f2e62cf3297020)
4. Add a warning comment about the storage layout [[334f42]](https://github.com/blend/zeppelinos-example/commit/334f42eada758cd49af57f6b62321949bbbd535e)
5. Deploy the upgradable contract. (see steps below)

The commits in this repository are designed to mirror the steps taken in the tutorial.

This code is based on the [MetaCoin Truffle Box](https://github.com/truffle-box/metacoin-box)
example project by the Truffle team.

## Getting started

Install dependencies:

```bash
npm install
```

Run the tests—they should pass:

```
npx truffle test
```

## Deployment

The config file `truffle-config.json` can be used to deploy to the Kovan test network
or the Ethereum main network.

The config depends on the following environment variables:
- `MNEMONIC`: Twelve-word secret phrase, which you can get from a wallet provider like MetaMask.
- `INFURA_KEY`: Infura API key, which you can get from https://infura.io/register.

The account unlocked by the wallet must have some Ether to fund the deployment gas costs.
By default, the first account in the wallet is used. See
[`truffle-hdwallet-provider`](https://github.com/trufflesuite/truffle/tree/develop/packages/truffle-hdwallet-provider)
for additional configuration options.

For convenience, we also define the following environment variables:
- `NETWORK`: One of the network names from your Truffle config, e.g. `main`.
- `UPGRADABILITY_OWNER`: An Ethereum address which will have the ability to
  push upgrades to the upgradable contract. Must be unlocked by the Truffle config.

Information about previously deployed contracts is stored in `zos.kovan.json` and
`zos.mainnet.json`. If you want to deploy from scratch, you can delete these files.

### Deploy the logic contract

Start a ZeppelinOS session and verify that we're able to talk to the network:

```bash
npx zos session --network $NETWORK --from $UPGRADABILITY_OWNER --expires 3600
npx zos status
```

If there are no errors, then we can deploy the logic contract:

```bash
npx zos push
```

When finished, information about the deployed contract will be saved to
`zos.$NETWORK.json`. It is **very important** to check this file into version control.

### Deploy the proxy contract

Start a ZeppelinOS session if needed, then run the following:

```bash
npx zos create MetaCoin --init initialize --args $UPGRADABILITY_OWNER
```

The initialzer `args` option will depend on your smart contract. In this case, we're
reusing the `UPGRADABILITY_OWNER` as the contract owner address to be passed into
the `Ownable.sol` initializer. If your initializer takes multiple arguments, they can
be passed in as a comma-separated list, with no spaces in between.

The proxy address will be written to the console output. This is the address that you
should direct your users to.

### Deploy an upgrade

Start a ZeppelinOS session if needed, then deploy a new logic contract:

```bash
npx zos push
```

Update the previously created proxy contract to point to the new logic contract:

```bash
npx zos update MetaCoin
```
