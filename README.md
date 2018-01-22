# solidity_atomic_transactions

**Different types of atomic swaps:**
* For case 1 (atomic on-chain token swaps); only a *single contract* is needed.
* For case 2 (atomic on-chain coin/token swaps); also only a *single contract* is needed.
* For case 3 (atomic cross-chain coin swaps); *two contracts* are needed (one per blockchain).
* For case 4 (atomic cross-chain token swaps); *two contracts* are needed (one per blockchain).
* For case 5 (atomic cross-chain coin/token swaps); *two contracts* are needed (one per blockchain).

**Folders:**
* General purpose contracts (1 time usage contracts usable for any type of ERC20 tokens).
* Multi swap contracts (X time usage contracts usable for any type of ERC20 tokens, where the funds need to be donated to the swap contract first).
* Multi swap contracts extended (X time usage contracts usable for any type of ERC20 tokens, where the contract is granted approval by both clients to swap the funds via them).

**sources:**
* https://github.com/ConsenSys/Token-Factory/tree/master/contracts
* https://github.com/realcodywburns/Tank-Farm/blob/master/contracts/locking/HTLC%28mew%29.sol
* https://github.com/AltCoinExchange/ethatomicswap/blob/master/contracts/AtomicSwap.sol

