var Migrations = artifacts.require("./Migrations.sol");
var Chairs = artifacts.require("./Chairs.sol");

var numberOfPlayers = 3;
var bet = 1000;

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Chairs, numberOfPlayers, bet);
};
