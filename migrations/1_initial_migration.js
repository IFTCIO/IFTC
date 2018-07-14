var Migrations = artifacts.require("./Migrations.sol");
var IFTCToken = artifacts.require("./IFTCToken.sol");
module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(IFTCToken);
};
