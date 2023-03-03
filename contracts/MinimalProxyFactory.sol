// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./NFTContract.sol";
import "hardhat/console.sol";

contract MinimalProxyFactory {
    mapping(string => address) proxies;

    function deployClone(
        address _implementationContract,
        string memory _name,
        string memory _symbol,
        string memory _baseURI,
        string memory _nftSlug
    ) external returns (address) {
        require(
            proxies[_nftSlug] == 0x0000000000000000000000000000000000000000,
            "Airdrop already with the same name, use different identifier"
        );

        // convert the address to 20 bytes
        bytes20 implementationContractInBytes = bytes20(
            _implementationContract
        );
        //address to assign a cloned proxy
        address proxy;

        // as stated earlier, the minimal proxy has this bytecode
        // <3d602d80600a3d3981f3363d3d373d3d3d363d73><address of implementation contract><5af43d82803e903d91602b57fd5bf3>

        // <3d602d80600a3d3981f3> == creation code which copies runtime code into memory and deploys it

        // <363d3d373d3d3d363d73> <address of implementation contract> <5af43d82803e903d91602b57fd5bf3> == runtime code that makes a delegatecall to the implentation contract

        assembly {
            /*
            reads the 32 bytes of memory starting at the pointer stored in 0x40
            In solidity, the 0x40 slot in memory is special: it contains the "free memory pointer"
            which points to the end of the currently allocated memory.
            */
            let clone := mload(0x40)
            // store 32 bytes to memory starting at "clone"
            mstore(
                clone,
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )

            /*
              |              20 bytes                |
            0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
                                                      ^
                                                      pointer
            */
            // store 32 bytes to memory starting at "clone" + 20 bytes
            // 0x14 = 20
            mstore(add(clone, 0x14), implementationContractInBytes)

            /*
              |               20 bytes               |                 20 bytes              |
            0x3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe
                                                                                              ^
                                                                                              pointer
            */
            // store 32 bytes to memory starting at "clone" + 40 bytes
            // 0x28 = 40
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )

            /*
            |                 20 bytes                  |          20 bytes          |           15 bytes          |
            0x3d602d80600a3d3981f3363d3d373d3d3d363d73b<implementationContractInBytes>5af43d82803e903d91602b57fd5bf3 == 45 bytes in total
            */

            // create a new contract
            // send 0 Ether
            // code starts at the pointer stored in "clone"
            // code size == 0x37 (55 bytes)
            proxy := create(0, clone, 0x37)
        }

        // Call initialization
        NFTContract(proxy).initialize(_name, _symbol, _baseURI);

        proxies[_nftSlug] = proxy;

        return proxy;
    }

    function getProxies(string memory _nftSlug) public view returns (address) {
        require(
            proxies[_nftSlug] != 0x0000000000000000000000000000000000000000,
            "No airdrop exists with this name"
        );

        return proxies[_nftSlug];
    }
}
