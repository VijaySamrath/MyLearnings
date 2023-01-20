//SPDX-License-Identifier:MIT

pragma solidity ^0.8.4;

interface IERC721 {

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
        )external;

    function transferFrom(
        address from,
        address to,
        uint nftId
        )external;

     function ownerOf(uint256 tokenId) external view returns (address owner);

}

contract Auction {

    IERC721 public immutable nft;
    uint public immutable nftId;
    event Start();
    address payable public immutable seller;
    uint32 public endAt;
    bool public started;
    bool public ended;
     
    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(
        address _nft,
        uint _nftId,
        uint _startingBid

    ){
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function startAuction() external {
        require(msg.sender == nft.ownerOf(nftId), "not seller");
        require(!started, "started");

        started = true;
        endAt = uint32(block.timestamp + 60 );
        nft.transferFrom(nft.ownerOf(nftId), address(this),nftId);

        emit Start();
    }

    function bid() external payable{
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        require(msg.value > highestBid, "value < highest bid");

        if (highestBidder != address(0)){
            bids[highestBidder] += highestBid;
        }
        highestBid = msg.value;
        highestBidder = msg.sender;
    }

    function withdraw() external {
        uint bal = bids[msg.sender] = 0;
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);
    }

    function end() external {
        require(started, "not started");
        // require(block.timestamp >= endAt, "not ended");
        require(!ended, "ended");

        ended = true;

        if(highestBidder != address(0)){
            nft.safeTransferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.safeTransferFrom(address(this), seller, nftId);
        }

    }
}