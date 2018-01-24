# solidity_atomic_transactions

**Different types of atomic swaps:**
1. On-chain token swaps - only a *single contract* is needed.
2. On-chain coin/token swaps - also only a *single contract* is needed.
3. Cross-chain coin swaps - *two contracts* are needed (one per blockchain).
4. Cross-chain token swaps - *two contracts* are needed (one per blockchain).
5. Cross-chain coin/token swaps - *two contracts* are needed (one per blockchain).

**Folders (for each of these contracts, the wallet addresses and type of ERC20 contracts can be specified):**
* generalpurpose_contracts: 1 time usage contracts.
* multiswap_contracts_funded: X time usage contracts, where the funds are donated to the swap contract by both parties.
* multiswap_contracts_nonfunded: X time usage contracts, where the swap contract is granted approval by both parties to swap the funds.

**sources:**
* https://github.com/ConsenSys/Token-Factory/tree/master/contracts
* https://github.com/realcodywburns/Tank-Farm/blob/master/contracts/locking/HTLC%28mew%29.sol
* https://github.com/AltCoinExchange/ethatomicswap/blob/master/contracts/AtomicSwap.sol

