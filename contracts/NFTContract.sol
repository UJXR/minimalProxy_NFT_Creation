// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract NFTContract is ERC721, Ownable, ReentrancyGuard, Initializable {
    bytes32 public root;
    uint256 public mintedTillNow = 0;

    bool public isInitialized;
    string public _name;
    string public _symbol;
    string public _baseImage;

    event Mint(uint256 indexed tokenId, address indexed minter);

    constructor() ERC721("", "") {}

    function initialize(
        string memory name,
        string memory symbol,
        string memory baseImage
    ) public initializer {
        isInitialized = true;
        _name = name;
        _symbol = symbol;
        _baseImage = baseImage;
    }

    function mintNFT() external nonReentrant {
        uint256 tokenId = totalSupply() + 1;
        // console.logBytes(_proof[0]);

        _safeMint(msg.sender, tokenId);

        emit Mint(tokenId, msg.sender);

        mintedTillNow++;
    }

    function tokenExists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    function totalSupply() public view returns (uint256) {
        return mintedTillNow;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        _requireMinted(_tokenId);

        //Gives the token metadata according to NFT campaigns
        return
            bytes(_baseImage).length > 0
                ? string(abi.encodePacked(_baseImage))
                : "";
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
}
