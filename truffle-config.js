const HDWalletProvider = require('truffle-hdwallet-provider');

module.exports = {
  networks: {
    kovan: {
      provider: () => new HDWalletProvider(
        process.env.MNEMONIC,
        `https://kovan.infura.io/${process.env.INFURA_KEY}`,
      ),
      network_id: 42,
      gas: 5000000,
      gasPrice: 2000000000,
    },
  },
};
