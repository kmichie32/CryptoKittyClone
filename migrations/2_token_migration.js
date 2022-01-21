const Token = artifacts.require("kittyContract");

module.exports = function (deployer) {
  deployer.deploy(Token);
};
