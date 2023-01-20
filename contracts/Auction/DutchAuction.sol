//SPDX-License-Identifier:MIT

pragma solidity ^0.8.4;

contract DutchAuction {
    uint256 public immutable startPrice = 5 ether;
    uint256 public immutable endPrice = 2 ether;

    uint256 public immutable startAt;
    uint256 public immutable endsAt;

    uint256 public immutable discountRate = 0.01 ether;

    address public donor;

    uint256 public finalPrice;

    constructor() {
        startAt = block.timestamp;
        endsAt = block.timestamp + 300 minutes;
    }  

    function price() public view returns(uint256) {
        if (endsAt < block.timestamp) {
            return endPrice;
        }

        uint256 minuteElapsed = (block.timestamp - startAt) / 60;

        return startPrice - (minuteElapsed * discountRate); 
    }

    function receiveMoney() public payable {
        require(block.timestamp < endsAt, "auction Expired");
        require(donor == address(0), "already donated");
        require(msg.value >= price(), "Not enough ethers sent");

        donor = msg.sender;
        finalPrice = price();
    }


}