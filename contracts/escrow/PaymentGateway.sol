//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/escrow/Escrow.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title Payment gateway using OpenZeppelin Escrow
 * @author Will Shahda
 */
contract PaymentGateway is Ownable {
    using SafeMath for uint256;

    Escrow escrow;
    address payable wallet;
    
    /**
     * @param _wallet receives funds from the payment gateway
     */
    constructor(address payable _wallet) public {
       escrow = new Escrow();
       wallet = _wallet;
    }

    // function addwallet(address payable _wallet) public {
    //     wallet = _wallet;
    //     escrow = new Escrow();
    // }

    /**
     * Receives payments from customers
     */
    function sendPayment() external payable {
        escrow.deposit{value:msg.value}(wallet);
    }

    /**
     * Withdraw funds to wallet
     */
    function withdraw() external onlyOwner {
        escrow.withdraw(wallet);
    }

    /**
     * Checks balance available to withdraw
     * @return the balance
     */
    function balance() external view onlyOwner returns (uint256) {
        return escrow.depositsOf(wallet);
    }

    /**
     * Update address of the wallet
     * @param _wallet address owner need to update  
     */

    function UpdateWallet(address payable _wallet) public onlyOwner {
        wallet = _wallet;
    }
    
}