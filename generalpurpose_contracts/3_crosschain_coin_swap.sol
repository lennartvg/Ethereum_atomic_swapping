pragma solidity ^0.4.18;

contract CrosschainCoinSwap {
    
    address clientA_addr;
    address clientB_addr;
    bytes32 hashed_secret;
    uint timeOut;
    
    function CrosschainCoinSwap(address _clientA_addr, address _clientB_addr, bytes32 _hashed_secret) public {
        clientA_addr = _clientA_addr;
        clientB_addr = _clientB_addr;
		hashed_secret = _hashed_secret;
        timeOut = now + 1 hours;
    }

    function () payable public {
        // accept funds to be sent to this contract
    }

    function claim(string _secret) public returns (bool) {
       if (hashed_secret == sha256(_secret)){
            selfdestruct(clientB_addr);
            return true;
       } else {
            return false;
       }
    }

    function refund() public returns (bool) {
        if (msg.sender == clientA_addr && now >= timeOut) {
            selfdestruct(clientA_addr);
            return true;
        } else {
            return false;
        }
    }
    
}


