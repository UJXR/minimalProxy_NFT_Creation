const hre = require("hardhat");

async function main() {


    const proxy1 = await hre.ethers.getContractAt(
        "NFTContract",
        "0xe31FBBA27Ad67A064412D3e95d5Fd42FcdBf3354"
    );

    const proxy2 = await hre.ethers.getContractAt(
        "NFTContract",
        "0x6dcB831E66C16CA629d95f62b17a1140Cda51200"
    );

    console.log("Proxy 1 total supply is  == ", await proxy1.totalSupply());
    console.log("Proxy 2 total supply is == ", await proxy2.totalSupply());


}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});