// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DutchNft is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 public immutable startPrice = 5 ether;
    uint256 public immutable endPrice = 2 ether;

    uint256 public immutable startAt;
    uint256 public immutable endsAt;

    uint256 public immutable discountRate = 0.01 ether;

    uint public duration = 300 minutes;
    uint public immutable MAX_SUPPLY = 3;


    constructor() ERC721("DutchToken", "DTK") {
        startAt = block.timestamp;
        endsAt = block.timestamp + duration;
    }


    function Nftprice() public view returns(uint256) {
        if (endsAt < block.timestamp) {
            return endPrice;
        }

        uint256 minuteElapsed = (block.timestamp - startAt) / 60;

        return startPrice - (minuteElapsed * discountRate); 
    }

    function safeMint(address to) public payable  {
        require(msg.value >= Nftprice(), "Not Enough ether sent");
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId < MAX_SUPPLY, "no more items left");
        _tokenIdCounter.increment();
        _safeMint(to, tokenId + 1);
    }

    function withdraw() public onlyOwner{
       payable(owner()).transfer(address(this).balance);

    }
}