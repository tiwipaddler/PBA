// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ItemizedBudget {
    
    event FundsReceived(address sender, uint256 amount);

    receive() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }

    fallback() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
} 
