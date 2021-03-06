# Single swap contracts

Each of these swap contracts can be used for a single atomic swap between two parties. When deploying a contract, constructor arguments need to be specified, to indicate which wallet addresses are used, which tokens are swapped (if applicable), and how much funds are swapped between the parties. These contracts are compatible with all ERC-20 tokens.

**Etherscan swap contract addresses (including verified source code):**

There was an inconsistency between the contracts on the Rinkeby and the Ropsten blockchain. Those on the Rinkeby blockchain did not selfdestruct(), the ones on the Ropsten blockchain did. Therefore, the Ropsten contracts do not have verified source code visible.

* 1_onchain_token_swap.sol: https://rinkeby.etherscan.io/address/0x97ad5fabd976ec4ef7116bad90bae71e3572dcee
* 2_onchain_cointoken_swap.sol: https://rinkeby.etherscan.io/address/0x7ee6506f301275fafe19f979f24d9923ed6581d3
* 3_crosschain_coin_swap.sol: https://rinkeby.etherscan.io/address/0xbe5c173722767e42454e3aaedc390b45426042b4
https://ropsten.etherscan.io/address/0x7399f545b5657aaa1bff644eec4db8a269621727
* 4_crosschain_token_swap.sol: https://rinkeby.etherscan.io/address/0xe999b852877c8f907f7797550b5a079907817f35
https://ropsten.etherscan.io/address/0x0af09efca0e0e9c614199df218da198f6c69502b

**Wallets used in these swaps:**
* Rinkeby client A: https://rinkeby.etherscan.io/address/0xd09335449618adaedf3ea0f478d2f3af09c5b3a3
* Rinkeby client B: https://rinkeby.etherscan.io/address/0xEDd332738b85aD3456272684d52BD88e9FAcEfFA
* Ropsten client A: https://ropsten.etherscan.io/address/0x8659F2711cB1b1c968DE123f52020F0b337836f8
* Ropsten client B: https://ropsten.etherscan.io/address/0x9D11Fce4130f47B0E76a39dd83Ff49fa15fa6005

**Tokens used in these swaps:**
* Rinkeby - PetnartCoin Unlimited (PCU): https://rinkeby.etherscan.io/token/0x8a357b544c979ee2d40489f09ec6c0363f31186c?a=0x97ad5fabd976ec4ef7116bad90bae71e3572dcee
* Rinkeby - BasicToken (BT): https://rinkeby.etherscan.io/token/0x94d3e52bf866e1f8fcc6fa84e7ebcb3ef947f32d?a=0x97ad5fabd976ec4ef7116bad90bae71e3572dcee

