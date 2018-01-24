# solidity_atomic_transactions

**Different types of atomic swaps:**
1. On-chain token swaps - only a *single contract* is needed.
2. On-chain coin/token swaps - also only a *single contract* is needed.
3. Cross-chain coin swaps - *two contracts* are needed (one per blockchain).
4. Cross-chain token swaps - *two contracts* are needed (one per blockchain).
5. Cross-chain coin/token swaps - *two contracts* are needed (one per blockchain).

**Folders:**
* General purpose contracts (1 time usage contracts usable for any type of ERC20 tokens).
* Multi swap contracts (X time usage contracts usable for any type of ERC20 tokens, where the funds need to be donated to the swap contract first).
* Multi swap contracts extended (X time usage contracts usable for any type of ERC20 tokens, where the contract is granted approval by both clients to swap the funds via them).

**sources:**
* https://github.com/ConsenSys/Token-Factory/tree/master/contracts
* https://github.com/realcodywburns/Tank-Farm/blob/master/contracts/locking/HTLC%28mew%29.sol
* https://github.com/AltCoinExchange/ethatomicswap/blob/master/contracts/AtomicSwap.sol

