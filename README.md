# Single-chain and Cross-chain Atomic Swaps for Ethereum

**Folders:**
* singleswap_contracts: contracts that are used for a single swap.
* reusable_contracts: contracts that can be used multiple times (only implemented case 1).

**Different types of atomic swaps:**
1. Single-chain token swaps - only one contract is needed.
2. Single-chain coin/token swaps - only one contract is needed.
3. Cross-chain coin swaps - two contracts (HTLC) are needed (one per blockchain).
4. Cross-chain token swaps - two contracts (HTLC) are needed (one per blockchain).
5. Cross-chain coin/token swaps - two contracts (HTLC) are needed (one per blockchain).

**Sources:**
* https://github.com/ConsenSys/Token-Factory/tree/master/contracts
* https://github.com/realcodywburns/Tank-Farm/blob/master/contracts/locking/HTLC%28mew%29.sol
* https://github.com/AltCoinExchange/ethatomicswap/blob/master/contracts/AtomicSwap.sol

**Tools used:**
* https://remix.ethereum.org/
* https://etherscan.io/
* https://wallet.ethereum.org/
* https://solidity.readthedocs.io/en/develop/
