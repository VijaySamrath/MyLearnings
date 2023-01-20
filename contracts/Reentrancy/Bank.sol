//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;



contract Bank {
    mapping(address => uint256) public balances;

    function deposit() external payable{
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint bal = balances[msg.sender];
        require (bal > 0, "Balance 0");

        (bool success, ) = msg.sender.call{value: bal}("");
        require(success, "failed to withdraw ether");

        balances[msg.sender] = 0; // to save the Reentrancy Attack we can write this line at line 15 or we can use reentrancy guard from openzepplin 

    }
}