# distribute-token
一个用于批量分发ERC-20代币的Web工具，支持BSC测试网。

## 功能
- 连接MetaMask钱包，显示“已连接”状态
- 输入代币合约地址并显示余额
- 上传Excel文件，显示待分发地址（每行一个）
- 批量分发代币到指定地址

## 使用方法
1. 打开 `distribute-token.html` 在浏览器中
2. 点击“连接钱包”，连接MetaMask并切换到BSC测试网
3. 输入ERC-20代币合约地址
4. 上传包含“BSC钱包地址”列的Excel文件
5. 输入每地址分发数量，点击“批量分发代币”

## 依赖
- ethers.js v5.7.2
- xlsx.js v0.17.4

## 合约
- 批量BNB分发合约地址: `0x0Ff66Ba9f80c46e6d956d083837be3dc6AE5fF25`
- 批量其他代币分发合约地址: `0xC3B77d9A07E703e019c560dc77E7Fc14704D0B78`
