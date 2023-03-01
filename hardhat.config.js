require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades');

const keys = require("./constants.js");


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: `https://eth-goerli.g.alchemy.com/v2/${keys.GOERLI_ALCHEMY_KEY}`,
      accounts: [keys.PRIVATE_KEY]
    },
    mumbai: {
      url: ` https://polygon-mumbai.g.alchemy.com/v2/${keys.MUMBAI_ALCHEMY_KEY}`,
      accounts: [keys.PRIVATE_KEY]
    },

    polygon: {
      url: `  https://polygon-mainnet.g.alchemy.com/v2/${keys.POLYGON_ALCHEMY_KEY}`,
      accounts: [keys.PRIVATE_KEY]
    },

  },

  // Just change it to keys.ETHERSCAN_KEY when you want to verify the goerli contracts
  etherscan: {
    apiKey: keys.ETHERSCAN_KEY
  },




};
