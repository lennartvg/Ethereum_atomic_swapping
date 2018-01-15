pragma solidity ^0.4.19;

contract crosschainCoin {
    
    address creator;
    address destination;
    
    bytes32 hash;
    uint timeOut;
     
    function crosschainCoin() {
        hash = 0x1234;
        destination = 0x1234;
        timeOut = now + 1 hours;
        creator = msg.sender; 
    }

    // accept funds to be sent to this contract
    function () payable {
    }

    function claim(string _hash) public returns(bool result) {
       if (hash == sha256(_hash)){
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


