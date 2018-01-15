pragma solidity ^0.4.19;

contract CrosschainCoinSwap_Rink {
    
    address creator;
    address destination;
    bytes32 hash;
    uint timeOut;
     
    // here peter is the creator
    function CrosschainCoinSwap_Rink() {
        hash = 0xba1cef85d1b28d5a2e45367e4c9196b1b148a7c35baf21a839089ef5a864439d;
        creator = msg.sender;
        destination = 0xD09335449618adaedF3Ea0f478D2F3AF09C5B3a3;
        timeOut = now + 1 hours;
    }

    // accept funds to be sent to this contract
    function () payable {
    }

    function claim(string _secret) public returns(bool result) {
       if (hash == sha256(_secret)){
            selfdestruct(destination);
            return true;
       } else {
            return false;
       }
    }

    // if the time-out has expired, the creator can reclaim the funds and destroy the contract
    function refund() public returns(bool result) {
        if (msg.sender == creator && now >= timeOut) {
            selfdestruct(creator);
            return true;
        } else {
            return false;
        }
    }
    
}


