// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract NFTImplementationContract is ERC721, Ownable, Initializable {
    bool public isInitialized;

    constructor() ERC721("Test1", "TST1") {}

    //initializer function that will be called once, during deployment.

    function initialize() public initializer {
        isInitialized = true;
        // console.log("Deploying a NFTImplementationContract");
    }
}
