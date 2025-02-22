// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
}

contract BatchTokenDistributor {
    address public owner;

    event TokensDistributed(address indexed token, address[] recipients, uint256 amountPerRecipient);
    event TokensWithdrawn(address indexed token, address indexed to, uint256 amount);
    event BNBWithdrawn(address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // 批量分发代币
    function distributeTokens(address token, address[] calldata recipients, uint256 amountPerRecipient) external onlyOwner {
        require(token != address(0), "Invalid token address");
        require(recipients.length > 0, "No recipients provided");
        require(amountPerRecipient > 0, "Amount must be greater than 0");

        IERC20 tokenContract = IERC20(token);
        uint256 totalAmount = amountPerRecipient * recipients.length;
        
        // 检查余额和授权
        require(tokenContract.balanceOf(msg.sender) >= totalAmount, "Insufficient token balance");
        require(tokenContract.allowance(msg.sender, address(this)) >= totalAmount, "Insufficient allowance");

        // 从发送者转账到合约
        require(tokenContract.transferFrom(msg.sender, address(this), totalAmount), "TransferFrom failed");

        // 批量分发
        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient address");
            require(tokenContract.transfer(recipients[i], amountPerRecipient), "Transfer failed");
        }

        emit TokensDistributed(token, recipients, amountPerRecipient);
    }

    // 提取合约中剩余的代币
    function withdrawTokens(address token, uint256 amount) external onlyOwner {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Amount must be greater than 0");

        IERC20 tokenContract = IERC20(token);
        uint256 contractBalance = tokenContract.balanceOf(address(this));
        require(contractBalance >= amount, "Insufficient contract balance");

        require(tokenContract.transfer(owner, amount), "Withdraw failed");
        emit TokensWithdrawn(token, owner, amount);
    }

    // 提取合约中的BNB（若意外收到）
    function withdrawBNB() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No BNB to withdraw");

        (bool success, ) = owner.call{value: balance}("");
        require(success, "BNB withdraw failed");
        emit BNBWithdrawn(owner, balance);
    }

    // 接收BNB（以防意外转入）
    receive() external payable {}
}