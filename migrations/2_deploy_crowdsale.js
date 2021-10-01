const ChillarToken = artifacts.require("ChillarToken");
const ChillarTokenCrowsale = artifacts.require("ChillarTokenCrowdsale");

const _name = 'Chillar Token'
const  _symbol = "CHR";
const _decimals = 18;
module.exports = function  (deployer)  {
  deployer.deploy(ChillarToken, 100000000);
  


// coin = basic erc20 token address/deployment address
//purse = testnet metamask
  deployer.deploy(ChillarTokenCrowsale,30000000,purse,coin);
  
};
