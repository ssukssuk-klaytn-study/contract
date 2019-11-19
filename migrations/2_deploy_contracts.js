const StandardProjectHub = artifacts.require("StandardProjectHub");

module.exports = function(deployer) {
  deployer.deploy(
    StandardProjectHub,
    "0x26f1B33f7C11219324A6c26A6A628A9d64EC4c92",
    80,
    100,
    100,
    100,
    "bitcoin",
    "BTC"
  );
};
