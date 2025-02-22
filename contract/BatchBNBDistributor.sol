// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BatchDistributor {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // 批量分发BNB
    function distributeBNB(address[] calldata recipients, uint256 amount) external payable onlyOwner {
        require(msg.value >= amount * recipients.length, "Insufficient BNB sent");
        for (uint256 i = 0; i < recipients.length; i++) {
            (bool success, ) = recipients[i].call{value: amount}("");
            require(success, "Transfer failed");
        }
    }

    // 提取合约中的BNB（以防误操作）
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner).transfer(balance);
    }

    // 接收BNB
    receive() external payable {}
}