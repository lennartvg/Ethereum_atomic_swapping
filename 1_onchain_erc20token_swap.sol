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

contract OnchainERC20tokenSwap {
    
    address clientA_addr;    // wallet
    address clientB_addr;    // wallet
    address PCU_addr;        // contract
    address BT_addr;         // contract
    ERC20 PCU_instance;
    ERC20 BT_instance;
    uint amountOf_BT_ClientAReceives;
    uint amountOf_PCU_ClientBReceives;
    
    bool PCU_IsSufficient;
    bool BT_IsSufficient;
     
    function OnchainERC20tokenSwap() {
        clientA_addr = msg.sender; 
        clientB_addr = 0x29a139Ba53f72cfbd40e9d9c7608B8f560551bfe; // Peter's Rinkeby wallet
        PCU_addr = 0x8a357b544c979ee2d40489f09ec6c0363f31186c;
        BT_addr = 0x94d3e52bf866e1f8fcc6fa84e7ebcb3ef947f32d;
        
        PCU_instance = ERC20(PCU_addr);
        BT_instance = ERC20(BT_addr);
        amountOf_BT_ClientAReceives = 50;
        amountOf_PCU_ClientBReceives = 50;
        
        PCU_IsSufficient = false;
        BT_IsSufficient = false;
    }

    // accept funds to be sent to this contract
    // function () payable {
    // }
    
    function isThereEnoughPCU() {
        if (msg.sender == clientA_addr && amountOf_PCU_ClientBReceives <= PCU_instance.balanceOf(this)) {
            PCU_IsSufficient = true;
            
            if (BT_IsSufficient == true){
                transferFunds();
            }
        }
    }
    
    function isThereEnoughBT() {
        if (msg.sender == clientB_addr && amountOf_BT_ClientAReceives <= BT_instance.balanceOf(this)) {
            BT_IsSufficient = true;
            
            if (PCU_IsSufficient == true){
                transferFunds();
            }
        }
    }
    
    function transferFunds() {
        PCU_instance.transfer(clientB_addr, amountOf_PCU_ClientBReceives);
        BT_instance.transfer(clientA_addr, amountOf_BT_ClientAReceives);
        // selfdestruct(clientA_addr);
    }
    
    
    
    // function returnClientA_PCUFunds() {
    //     PCU_instance.transfer(clientA_addr, 200);
    // }

}



