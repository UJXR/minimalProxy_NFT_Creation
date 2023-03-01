const hre = require("hardhat");

async function main() {

    // load the clone
    const proxy = await hre.ethers.getContractAt(
        "NFTContract",
        "0x56650E32f2E35C15EdBd9C0915557e7eE5b8cA1e"
    );

    console.log("Proxy is initialized == ", await proxy.isInitialized()); // get initialized boolean == true
    console.log("Proxy name is == ", await proxy.name()); // get initialized boolean == true
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});