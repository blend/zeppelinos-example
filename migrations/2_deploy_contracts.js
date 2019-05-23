const MetaCoin = artifacts.require("MetaCoin");

module.exports = function(deployer, network, [rootAccount]) {
  deployer.then(async () => {
    if (['development', 'test'].indexOf(network) === -1) {
      console.log(
        'Skipping deployment of MetaCoin, which should be deployed with zos.'
      );
      return;
    }
    await deployer.deploy(MetaCoin);
    const instance = await MetaCoin.deployed();
    await instance.initialize(rootAccount);
  });
};
