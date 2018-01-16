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
// client B will transfer some ETH to client A
contract OnchainERC20tokencoinSwap {
    
    address clientA_addr;       // wallet
    address clientB_addr;       // wallet
    address PCU_addr;           // contract
    ERC20 PCU_instance;
    uint amountOf_PCU_ClientBReceives;
    uint amountOf_ETH_ClientAReceives;
    bool PCU_IsSufficient;
    bool ETH_IsSufficient;
    uint timeOut;
     
    function OnchainERC20tokencoinSwap() {
        clientA_addr = msg.sender; 
        clientB_addr = 0x29a139Ba53f72cfbd40e9d9c7608B8f560551bfe; // Peter's Rinkeby wallet
        PCU_addr = 0x8a357b544c979ee2d40489f09ec6c0363f31186c;
        PCU_instance = ERC20(PCU_addr);
        amountOf_PCU_ClientBReceives = 50;
        amountOf_ETH_ClientAReceives = 1;
        PCU_IsSufficient = false;
        ETH_IsSufficient = false;
    }

    function () payable public {
        // accept funds to be sent to this contract
    }
    
    function clientA_transferFundsIfPossible() public {
        if (msg.sender == clientA_addr && amountOf_PCU_ClientBReceives <= PCU_instance.balanceOf(this)) {
            PCU_IsSufficient = true;
            
            if (ETH_IsSufficient == true){
                transferFunds();
            }
        }
    }
    
    function clientB_transferFundsIfPossible() public {
        if (msg.sender == clientB_addr && amountOf_ETH_ClientAReceives <= (this.balance / 10**18)) {
            ETH_IsSufficient = true;
            
            if (PCU_IsSufficient == true){
                transferFunds();
            }
        }
    }
    
    function transferFunds() internal {
        PCU_instance.transfer(clientB_addr, amountOf_PCU_ClientBReceives);
        clientA_addr.transfer(amountOf_ETH_ClientAReceives * 10**18);
        selfdestruct(clientA_addr);
    }
    
    function refund() public returns(bool) {
        if (now >= timeOut) {
            uint total_PCU_received = PCU_instance.balanceOf(this);
            uint total_WEI_received = this.balance;
            if (total_PCU_received > 0){
                PCU_instance.transfer(clientA_addr, total_PCU_received);
            }
            if (total_WEI_received > 0){
                clientA_addr.transfer(total_WEI_received);   
            }
            selfdestruct(clientA_addr);
            return true;
        } else {
            return false;
        }
    }

}



