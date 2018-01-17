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


// client A will transfer some token1 to client B
// client B will transfer some token2 to client A
contract OnchainERC20tokenSwap {
    
    address clientA_addr;  // wallet
    address clientB_addr;  // wallet
    address token1_addr;  // contract
    address token2_addr;  // contract
    ERC20 token1_instance;
    ERC20 token2_instance;
    uint amountOf_token1_ClientBReceives;
    uint amountOf_token2_ClientAReceives;
    bool token1_IsSufficient;
    bool token2_IsSufficient;
    uint timeOut;  

    function OnchainERC20tokenSwap(address _clientB_addr, address _token1_addr, address _token2_addr) {
        clientA_addr = msg.sender; 
        clientB_addr = _clientB_addr;
        token1_addr = _token1_addr;
        token2_addr = _token2_addr;
        token1_instance = ERC20(token1_addr);
        token2_instance = ERC20(token2_addr);
        amountOf_token1_ClientBReceives = 50;
        amountOf_token2_ClientAReceives = 50;
        token1_IsSufficient = false;
        token2_IsSufficient = false;
        timeOut = now + 1 hours;
    }

    function clientA_transferFundsIfPossible() public {
        uint token1_balance = token1_instance.balanceOf(this);
        if (msg.sender == clientA_addr && amountOf_token1_ClientBReceives <= token1_balance) {
            token1_IsSufficient = true;
            
            if (token2_IsSufficient == true){
                transferFunds(token1_balance, token2_instance.balanceOf(this));
            }
        }
    }
    
    function clientB_transferFundsIfPossible() public {
        uint token2_balance = token2_instance.balanceOf(this);
        if (msg.sender == clientB_addr && amountOf_token2_ClientAReceives <= token2_balance) {
            token2_IsSufficient = true;
        
            if (token1_IsSufficient == true){
                transferFunds(token1_instance.balanceOf(this), token2_balance);
            }
        }
    }
    
    function transferFunds(uint _token1_balance, uint _token2_balance) internal {
        token1_instance.transfer(clientB_addr, _token1_balance);
        token2_instance.transfer(clientA_addr, _token2_balance);
        selfdestruct(clientA_addr);
    }
    
    function refund() public returns(bool) {
        if (now >= timeOut) {
            uint token1_balance = token1_instance.balanceOf(this);
            uint token2_balance = token2_instance.balanceOf(this);
            if (token1_balance > 0){
                token1_instance.transfer(clientA_addr, token1_balance);
            }
            if (token2_balance > 0){
                token2_instance.transfer(clientB_addr, token2_balance);   
            }
            selfdestruct(clientA_addr);
            return true;
        } else {
            return false;
        }
    }

    function () public payable {
        revert();
    }

}
