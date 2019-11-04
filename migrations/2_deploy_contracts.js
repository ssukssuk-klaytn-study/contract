const StandardProject = artifacts.require("StandardProject");

module.exports = function(deployer) {
  deployer.deploy(
    StandardProject,
    "0x26f1B33f7C11219324A6c26A6A628A9d64EC4c92",
    80,
    100,
    100,
    100,
    "bitcoin",
    "BTC"
  );
};
