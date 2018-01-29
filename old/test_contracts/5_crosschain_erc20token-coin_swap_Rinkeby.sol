pragma solidity ^0.4.18;

contract ERC20 {
    function totalSupply() constant returns (uint256 supply) {}
    function balanceOf(address _owner) constant returns (uint256 balance) {}
    function transfer(address _to, uint256 _value) returns (bool success) {}
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
    function approve(address _spender, uint256 _value) returns (bool success) {}
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


// the ETH contract
contract CrosschainERC20tokencoinSwap_Rinkeby {
    
    address clientA_addr;
    address clientB_addr;
    bytes32 hash;
    uint timeOut;
    
    function CrosschainERC20tokencoinSwap_Rinkeby() {
        clientA_addr = msg.sender;
        clientB_addr = 0xD09335449618adaedF3Ea0f478D2F3AF09C5B3a3;  // Lennart's wallet on Rinkeby
	hash = 0xba1cef85d1b28d5a2e45367e4c9196b1b148a7c35baf21a839089ef5a864439d;  // secret = "petnart"
        timeOut = now + 1 hours;
    }

    function claim(string _secret) public returns(bool) {
       if (hash == sha256(_secret)){
            selfdestruct(clientB_addr);
            return true;
       } else {
            return false;
       }
    }

    function refund() public returns(bool) {
        if (msg.sender == clientA_addr && now >= timeOut) {
            selfdestruct(clientA_addr);
            return true;
        } else {
            return false;
        }
    }
    
}


