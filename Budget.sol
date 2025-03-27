// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ItemizedBudget {
    
    event FundsReceived(address sender, uint256 amount);
    event TokenReceived(address sender, address token, uint256 amount);

    
    receive() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }

    
    fallback() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }

    
    function receiveToken(address _tokenAddress, uint256 _amount) external {
        emit TokenReceived(msg.sender, _tokenAddress, _amount);
    }

    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

}
