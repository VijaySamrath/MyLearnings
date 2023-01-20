const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("NftAuction", async function () {

    async function deploy() {
        
  const _startingBid = hre.ethers.utils.parseEther("1");

  const NFTMarketPlace = await ethers.getContractFactory("NFTMarketPlace")
  nftMarketPlace = await NFTMarketPlace.deploy()
  await nftMarketPlace.deployed()
  console.log("nftMarketPlace deployed to address:", nftMarketPlace.address)

  const Nft= await ethers.getContractFactory("Nft");
  nft = await Nft.deploy(nftMarketPlace.address)
  await nft.deployed()
  console.log("nft deployed to address:", nft.address)

  const Auction = await ethers.getContractFactory("Auction");
  auction = await Auction.deploy(nft.address, 0 , _startingBid)
  await auction.deployed()

  console.log("Auction deployed to address:", auction.address)


}
  before("Before", async () => {
        accounts = await ethers.getSigners();

        await deploy();
    })

    
    it("should Token name be", async () => {
        //let TokenName
        try {
            TokenName = await nft.name();
        } catch (error) {
            console.log(error)
        }

        console.log("TokenName: ", TokenName);
        expect(TokenName).to.equal("RAPID");

    })

    it("minting Token & giving allowance", async () => {
      await nft.safeMint(accounts[1].address)
      console.log("Balance of account", await nft.balanceOf(accounts[1].address));

        await nft.connect(accounts[1]).approve(auction.address, 0)
        
        console.log("approved to:", await nft.getApproved (0))
    })

    it("Start Auction", async() => {
        await auction.connect(accounts[1]).startAuction()
        console.log("Started", await auction.started())
    })

    it("bid Auction", async() => {

        await auction.connect(accounts[2]).bid({value:ethers.utils.parseEther("10")})

        // console.log("Highest Bidder", await auction.highestBid())
    })

    it("bid Auction", async() => {

        await auction.connect(accounts[3]).bid({value:ethers.utils.parseEther("12")})

        console.log("Bidder amount", await auction.bids(accounts[2].address))
    })

    it("bid Auction", async() => {

        await auction.connect(accounts[4]).bid({value:ethers.utils.parseEther("15")})

        console.log("Highest Bidder", await auction.highestBid())
    })

    it("Withdraw bid", async() => {

        await auction.connect(accounts[2]).withdraw()
        console.log("Bidder amount", await auction.bids(accounts[2].address))
    })

    it("end auction", async () =>{

        await auction.end()
        console.log("Ended", await auction.ended())
        
    })

})