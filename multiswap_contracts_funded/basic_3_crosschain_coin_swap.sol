pragma solidity ^0.4.18;

contract CrosschainCoinSwap {
    
    address clientA;  // wallet
    address clientB;  // wallet
    bytes32 hashed_secret;
    uint timeOut;
    
    function CrosschainCoinSwap(address _clientA, address _clientB, bytes32 _hashed_secret) public {
        clientA = _clientA;
        clientB = _clientB;
        hashed_secret = _hashed_secret;
        timeOut = now + 1 hours;
    }

    function () payable public {
        // accept ETH to be sent to this contract
    }

    function claim(string _secret) public returns (bool) {
       if (hashed_secret == sha256(_secret)){
            selfdestruct(clientB);
            return true;
       } else {
            return false;
       }
    }

    function refund() public returns (bool) {
        if (msg.sender == clientA && now >= timeOut) {
            selfdestruct(clientA);
            return true;
        } else {
            return false;
        }
    }
    
}

