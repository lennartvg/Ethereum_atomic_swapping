pragma solidity ^0.4.18;

contract CrosschainCoinSwap {
    
    struct SwapInstance {
        address clientA;  // wallet
        address clientB;  // wallet
        bytes32 hashed_secret;
        uint timeOut; 
    }
    
    mapping (uint => SwapInstance) swaps;
    
    function CrosschainCoinSwap() public {
        // constructor
    }

    function () payable public {
        // accept ETH to be sent to this contract
    }
    
    function initiateNewSwap(uint _swapID, address _clientA, address _clientB, bytes32 _hashed_secret) public {
        swaps[_swapID] = SwapInstance({clientA:_clientA, clientB:_clientB, hashed_secret:_hashed_secret, timeOut:(now + 1 hours)});
    }

    function claim(uint _swapID, string _secret) public returns (bool) {
        SwapInstance memory s = swaps[_swapID];
        if (s.hashed_secret == sha256(_secret)){
            s.clientB.transfer(this.balance);
            return true;
        } else {
            return false;
        }
    }

    function refund(uint _swapID) public returns (bool) {
        SwapInstance memory s = swaps[_swapID];
        if (msg.sender == s.clientA && now >= s.timeOut) {
            s.clientA.transfer(this.balance);
            return true;
        } else {
            return false;
        }
    }
    
}
