// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ItemizedBudget {
    address public owner;
    
    // Struct to hold budget for each category
    struct BudgetCategory {
        uint256 totalAmount;
        uint256 spentAmount;
    }

    
    mapping(string => BudgetCategory) public budgetCategories;
    
    
    event DonationReceived(string category, uint256 amount, address donor);
    event FundsTransferred(string category, uint256 amount, address to);

    
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;

        // Initialize budget categories with zero funds
        budgetCategories["transport"] = BudgetCategory(0, 0);
        budgetCategories["food"] = BudgetCategory(0, 0);
        budgetCategories["healthcare"] = BudgetCategory(0, 0);
        budgetCategories["school"] = BudgetCategory(0, 0);
        budgetCategories["groceries"] = BudgetCategory(0, 0);
    }

   
    function donate(string memory category) external payable {
        require(msg.value > 0, "Donation must be greater than 0");
        
        // Check 
        require(
            keccak256(abi.encodePacked(category)) == keccak256(abi.encodePacked("transport")) || 
            keccak256(abi.encodePacked(category)) == keccak256(abi.encodePacked("food")) || 
            keccak256(abi.encodePacked(category)) == keccak256(abi.encodePacked("healthcare")) || 
            keccak256(abi.encodePacked(category)) == keccak256(abi.encodePacked("school")) || 
            keccak256(abi.encodePacked(category)) == keccak256(abi.encodePacked("groceries")),
            "Invalid category"
        );

        
        budgetCategories[category].totalAmount += msg.value;
        
        emit DonationReceived(category, msg.value, msg.sender);
    }

   
    function transferFunds(string memory category, uint256 amount, address payable to) external onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        require(budgetCategories[category].totalAmount >= amount, "Insufficient funds in category");

        // Update the category's total amount and spent amount
        budgetCategories[category].totalAmount -= amount;
        budgetCategories[category].spentAmount += amount;

        // Transfer the funds to the specified verfied address
        to.transfer(amount);
        
        emit FundsTransferred(category, amount, to);
    }

    function getCategoryBalance(string memory category) external view returns (uint256 total, uint256 spent) {
        BudgetCategory memory categoryInfo = budgetCategories[category];
        return (categoryInfo.totalAmount, categoryInfo.spentAmount);
    }

    function withdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance in contract");
        payable(owner).transfer(amount);
    }
}
