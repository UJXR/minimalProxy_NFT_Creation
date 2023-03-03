const hre = require("hardhat");

async function main() {
    const ImplementationContract = await hre.ethers.getContractFactory(
        "NFTContract"
    );
    // deploy the implementation contract
    const implementationContract = await ImplementationContract.deploy();
    await implementationContract.deployed();

    console.log("Implementation contract ", implementationContract.address);

    const MinimalProxyFactory = await hre.ethers.getContractFactory(
        "MinimalProxyFactory"
    );
    // deploy the minimal factory contract
    const minimalProxyFactory = await MinimalProxyFactory.deploy();
    await minimalProxyFactory.deployed();

    console.log("Minimal proxy factory contract ", minimalProxyFactory.address);


    // call the deploy clone function on the minimal factory contract and pass parameters
    const deployCloneContract = await minimalProxyFactory.deployClone(
        implementationContract.address, "UJTEST1", "UJ1", "https://www.google.com/search?q=google+images&rlz=1C5CHFA_enIN1037IN1037&source=lnms&tbm=isch&sa=X&ved=2ahUKEwjvsqf8rb39AhUwxDgGHeX8DykQ_AUoAXoECAEQAw&biw=1440&bih=820&dpr=2#imgrc=z3cK42rFNryY7M", "INTRACT_UJ1"
    );

    const deployCloneContract2 = await minimalProxyFactory.deployClone(
        implementationContract.address, "UJTEST2", "UJ2", "https://www.google.com/search?q=google+images&rlz=1C5CHFA_enIN1037IN1037&source=lnms&tbm=isch&sa=X&ved=2ahUKEwjvsqf8rb39AhUwxDgGHeX8DykQ_AUoAXoECAEQAw&biw=1440&bih=820&dpr=2#imgrc=z3cK42rFNryY7M", "INTRACT_UJ2"
    );

    await deployCloneContract.wait();
    await deployCloneContract2.wait();


    // get deployed proxy address
    var ProxyAddress1 = await minimalProxyFactory.getProxies("INTRACT_UJ1");
    var ProxyAddress2 = await minimalProxyFactory.getProxies("INTRACT_UJ2");


    console.log("Proxy contract 1 ", ProxyAddress1);
    console.log("Proxy contract 2", ProxyAddress2);


    // load the clone
    const proxy1 = await hre.ethers.getContractAt(
        "NFTContract",
        ProxyAddress1
    );

    const proxy2 = await hre.ethers.getContractAt(
        "NFTContract",
        ProxyAddress2
    );

    console.log("Proxy 1 is initialized == ", await proxy1.isInitialized());
    console.log("Proxy 2 is initialized == ", await proxy2.isInitialized());

    console.log("Proxy 1 name is  == ", await proxy1.name());
    console.log("Proxy 2 name is == ", await proxy2.name());

    console.log("Proxy 1 symbol is  == ", await proxy1.symbol());
    console.log("Proxy 2 symbol is == ", await proxy2.symbol());

    await proxy1.mintNFT();
    await proxy1.mintNFT();
    await proxy1.mintNFT();
    await proxy1.mintNFT();


    await proxy2.mintNFT();
    await proxy2.mintNFT();

    console.log("Proxy 1 total supply is  == ", await proxy1.totalSupply());
    console.log("Proxy 2 total supply is == ", await proxy2.totalSupply());


}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});