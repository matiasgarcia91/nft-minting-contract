const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // Mint and wait for it to be mined
  let txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
  console.log("Minted NFT #1");

  let txn2 = await nftContract.makeAnEpicNFT();
  await txn.wait();
  console.log("Minted NFT #2");
  let txn3 = await nftContract.makeAnEpicNFT();
  await txn.wait();
  console.log("Minted NFT #3");
  let txn4 = await nftContract.makeAnEpicNFT();
  await txn.wait();
  console.log("Minted NFT #4");
  let txn5 = await nftContract.makeAnEpicNFT();
  await txn.wait();
  console.log("Minted NFT #5");
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (e) {
    console.log(e);
    process.exit(1);
  }
};

runMain();
