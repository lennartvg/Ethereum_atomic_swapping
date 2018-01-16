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

contract OnchainERC20tokencoinSwap {
    
    address clientA_addr;    // wallet
    address clientB_addr;    // wallet
    address PCU_addr;        // contract

    ERC20 PCU_instance;
    uint amountOf_ETH_ClientAReceives;
    uint amountOf_PCU_ClientBReceives;
    
    bool PCU_IsSufficient;
    bool ETH_IsSufficient;
     
    // client A sends client B some PCU
    // client B sends client A some ETH
    function OnchainERC20tokencoinSwap() {
        clientA_addr = msg.sender; 
        clientB_addr = 0x29a139Ba53f72cfbd40e9d9c7608B8f560551bfe; // Peter's Rinkeby wallet
        PCU_addr = 0x8a357b544c979ee2d40489f09ec6c0363f31186c;

        PCU_instance = ERC20(PCU_addr);

        amountOf_ETH_ClientAReceives = 1;
        amountOf_PCU_ClientBReceives = 50;
        
        PCU_IsSufficient = false;
        ETH_IsSufficient = false;
    }

    // // accept funds to be sent to this contract
    function () payable {
    }
    
    function isThereEnoughPCU() public {
        if (msg.sender == clientA_addr && amountOf_PCU_ClientBReceives <= PCU_instance.balanceOf(this)) {
            PCU_IsSufficient = true;
            
            if (ETH_IsSufficient == true){
                transferFunds();
            }
        }
    }
    
    function isThereEnoughETH() public {
        if (msg.sender == clientB_addr && amountOf_ETH_ClientAReceives <= this.balance) {
            ETH_IsSufficient = true;
            
            if (PCU_IsSufficient == true){
                transferFunds();
            }
        }
    }
    
    function transferFunds() internal {
        PCU_instance.transfer(clientB_addr, amountOf_PCU_ClientBReceives);
        clientA_addr.transfer(amountOf_ETH_ClientAReceives * 10**18);
        // selfdestruct(clientA_addr);
    }
    
    
    
    // function returnClientA_PCUFunds() {
    //     PCU_instance.transfer(clientA_addr, 200);
    // }

}



