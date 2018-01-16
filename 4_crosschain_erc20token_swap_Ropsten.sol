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


// the PNC contract
contract CrosschainERC20tokencoinSwap_Ropsten {
    
    address clientA_addr;
    address clientB_addr;
    address PCU_addr;  // contract
    ERC20 PCU_instance;
    bytes32 hash;
    uint timeOut;
    
    function CrosschainERC20tokencoinSwap_Ropsten() {
        clientA_addr = msg.sender;
        clientB_addr = 0xaC7fF44A24F3634d270CC5e5188985fd793ED476;  // Peter's wallet on Ropsten
        PCU_addr = 0x8a357b544c979ee2d40489f09ec6c0363f31186c;
        PCU_instance = ERC20(PCU_addr);
        hash = 0xba1cef85d1b28d5a2e45367e4c9196b1b148a7c35baf21a839089ef5a864439d;  // secret = "petnart"
        timeOut = now + 1 hours;
    }

    function claim(string _secret) public returns(bool) {
       if (hash == sha256(_secret)){
            uint total_PCU_received = PCU_instance.balanceOf(this);
            PCU_instance.transfer(clientB_addr, total_PCU_received);
            selfdestruct(clientB_addr);
            return true;
       } else {
            return false;
       }
    }

    function refund() public returns(bool) {
        if (msg.sender == clientA_addr && now >= timeOut) {
            uint total_PCU_received = PCU_instance.balanceOf(this);
            PCU_instance.transfer(clientA_addr, total_PCU_received);
            selfdestruct(clientA_addr);
            return true;
        } else {
            return false;
        }
    }
    
}


