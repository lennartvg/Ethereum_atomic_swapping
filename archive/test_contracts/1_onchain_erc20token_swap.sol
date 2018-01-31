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


// client A will transfer some PCU to client B
// client B will transfer some BT to client A
contract OnchainERC20tokenSwap {
    
    address clientA_addr;       // wallet
    address clientB_addr;       // wallet
    address PCU_addr;           // contract
    address BT_addr;            // contract
    ERC20 PCU_instance;
    ERC20 BT_instance;
    uint amountOf_PCU_ClientBReceives;
    uint amountOf_BT_ClientAReceives;
    bool PCU_IsSufficient;
    bool BT_IsSufficient;
    uint timeOut;  

    function OnchainERC20tokenSwap() {
        clientA_addr = msg.sender; 
        clientB_addr = 0x29a139Ba53f72cfbd40e9d9c7608B8f560551bfe; // Peter's Rinkeby wallet
        PCU_addr = 0x8a357b544c979ee2d40489f09ec6c0363f31186c;
        BT_addr = 0x94d3e52bf866e1f8fcc6fa84e7ebcb3ef947f32d;
        PCU_instance = ERC20(PCU_addr);
        BT_instance = ERC20(BT_addr);
        amountOf_PCU_ClientBReceives = 50;
        amountOf_BT_ClientAReceives = 50;
        PCU_IsSufficient = false;
        BT_IsSufficient = false;
        timeOut = now + 1 hours;
    }

    function clientA_transferFundsIfPossible() public {
        if (msg.sender == clientA_addr && amountOf_PCU_ClientBReceives <= PCU_instance.balanceOf(this)) {
            PCU_IsSufficient = true;
            
            if (BT_IsSufficient == true){
                transferFunds();
            }
        }
    }
    
    function clientB_transferFundsIfPossible() public {
        if (msg.sender == clientB_addr && amountOf_BT_ClientAReceives <= BT_instance.balanceOf(this)) {
            BT_IsSufficient = true;
            
            if (PCU_IsSufficient == true){
                transferFunds();
            }
        }
    }
    
    function transferFunds() internal {
        // uint total_PCU_received = PCU_instance.balanceOf(this);
        // uint total_BT_received = BT_instance.balanceOf(this);
        PCU_instance.transfer(clientB_addr, amountOf_PCU_ClientBReceives);
        BT_instance.transfer(clientA_addr, amountOf_BT_ClientAReceives);
        selfdestruct(clientA_addr);
    }
    
    function refund() public returns(bool) {
        if (now >= timeOut) {
            uint total_PCU_received = PCU_instance.balanceOf(this);
            uint total_BT_received = BT_instance.balanceOf(this);
            if (total_PCU_received > 0){
                PCU_instance.transfer(clientA_addr, total_PCU_received);
            }
            if (total_BT_received > 0){
                BT_instance.transfer(clientB_addr, total_BT_received);   
            }
            selfdestruct(clientA_addr);
            return true;
            // can a return be done after selfdestruct?
        } else {
            return false;
        }
    }

}

