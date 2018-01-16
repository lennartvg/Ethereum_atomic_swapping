pragma solidity ^0.4.18;

contract CrosschainCoinSwap_Ropsten {
    
    address creator;
    address destination;
    bytes32 hash;
    uint timeOut;
    
    function CrosschainCoinSwap_Ropsten() {
        creator = msg.sender;
        destination = 0xaC7fF44A24F3634d270CC5e5188985fd793ED476;			// Peter's wallet on Ropsten
	hash = 0xba1cef85d1b28d5a2e45367e4c9196b1b148a7c35baf21a839089ef5a864439d; 	// secret = "petnart"
        timeOut = now + 1 hours;
    }

    function () payable {
        // accept funds to be sent to this contract
    }

    function claim(string _secret) public returns(bool) {
       if (hash == sha256(_secret)){
            selfdestruct(destination);
            return true;
       } else {
            return false;
       }
    }

    function refund() public returns(bool) {
        if (msg.sender == creator && now >= timeOut) {
            selfdestruct(creator);
            return true;
        } else {
            return false;
        }
    }
    
}


