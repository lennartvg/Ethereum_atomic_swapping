# solidity_atomic_transactions

**Folders (these contracts are compatible with all ERC-20 tokens):**
* generalpurpose_contracts: contracts that are only used for a single swap.
* reusable_contracts: contracts that can be used multiple times (only implemented case 1).

**Different types of atomic swaps:**
1. On-chain token swaps - only a *single contract* is needed.
2. On-chain coin/token swaps - also only a *single contract* is needed.
3. Cross-chain coin swaps - *two contracts* are needed (one per blockchain).
4. Cross-chain token swaps - *two contracts* are needed (one per blockchain).
5. Cross-chain coin/token swaps - *two contracts* are needed (one per blockchain).

**Inspired by:**
* https://github.com/ConsenSys/Token-Factory/tree/master/contracts
* https://github.com/realcodywburns/Tank-Farm/blob/master/contracts/locking/HTLC%28mew%29.sol
* https://github.com/AltCoinExchange/ethatomicswap/blob/master/contracts/AtomicSwap.sol

