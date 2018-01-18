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

// client A will transfer some <token> to client B
// client B will transfer some ETH to client A
contract OnchainCoinTokenSwap {
    
    address clientA;  // wallet
    address clientB;  // wallet
    address token;  // contract
    ERC20 token_instance;
    uint amountOf_token;
    uint amountOf_ETH;
    uint timeOut;  
 
    function OnchainCoinTokenSwap(address _clientA, address _clientB, address _token, 
            uint _amountOf_token, uint _amountOf_ETH) public {
        clientA = _clientA; 
        clientB = _clientB;
        token = _token;
        token_instance = ERC20(token);
        amountOf_token = _amountOf_token;
        amountOf_ETH = _amountOf_ETH; 
        timeOut = now + 1 hours;
    }
    
    function () payable public {
        // accept ETH to be sent to this contract
    }

    modifier onlyParticipant {
        require(msg.sender == clientA || msg.sender == clientB); 
        _; 
    }
    
    function transferFunds() onlyParticipant public returns (bool) {
        uint token_balance = token_instance.balanceOf(this);
        uint ETH_balance = this.balance / 10**18;
        if (token_balance >= amountOf_token && ETH_balance >= amountOf_ETH && now < timeOut) {
            token_instance.transfer(clientB, token_balance);
            clientA.transfer(ETH_balance * 10**18);
            selfdestruct(clientA);
            return true;
        } else {
            return false;
        }
    }
    
    function refundFunds() onlyParticipant public returns (bool) {
        if (now >= timeOut) {
            uint token_balance = token_instance.balanceOf(this);
            uint ETH_balance = this.balance / 10**18;
            if (token_balance > 0){
                token_instance.transfer(clientA, token_balance);
            }
            if (ETH_balance > 0){
                clientB.transfer(ETH_balance * 10**18);  
            }
            selfdestruct(clientA);
            return true;
        } else {
            return false;
        }
    }

}
