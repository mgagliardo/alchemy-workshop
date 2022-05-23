// scripts/deploy.js

const hre = require("hardhat");

async function main() {
  // We get the contract to deploy.
  const BuyMeACoffeeModified = await hre.ethers.getContractFactory(
    "BuyMeACoffeeModified"
  );
  const buyMeACoffeeModified = await BuyMeACoffeeModified.deploy();

  await buyMeACoffeeModified.deployed();

  console.log(
    "BuyMeACoffeeModified deployed to:",
    buyMeACoffeeModified.address
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
