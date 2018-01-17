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
    
    address clientA;  // wallet
    address clientB;  // wallet
    address token1;  // contract
    address token2;  // contract
    ERC20 token1_instance;
    ERC20 token2_instance;
    uint amountOf_token1;
    uint amountOf_token2;
    bool token1_HasSufficientBalance;
    bool token2_HasSufficientBalance;
    uint timeOut;  
 
<<<<<<< HEAD
    function OnchainERC20tokenSwap(address _clientA, address _clientB, address _token1, 
            address _token2, uint _amountOf_token1, uint _amountOf_token2) public {
        clientA = _clientA; 
        clientB = _clientB;
        token1 = _token1;
        token2 = _token2;
        token1_instance = ERC20(token1);
        token2_instance = ERC20(token2);
=======
    function OnchainERC20tokenSwap(address _clientA_addr, address _clientB_addr, address _token1_addr, 
            address _token2_addr, uint _amountOf_token1, uint _amountOf_token2) public {
        clientA_addr = _clientA_addr; 
        clientB_addr = _clientB_addr;
        token1_addr = _token1_addr;
        token2_addr = _token2_addr;
        token1_instance = ERC20(token1_addr);
        token2_instance = ERC20(token2_addr);
>>>>>>> 593b1371a0259f4787b29a231ab7548df683f789
        amountOf_token1 = _amountOf_token1;
        amountOf_token2 = _amountOf_token2;
        token1_HasSufficientBalance = false;
        token2_HasSufficientBalance = false;
        timeOut = now + 1 hours;
    }

    modifier onlyParticipant {
<<<<<<< HEAD
        require(msg.sender == clientA || msg.sender == clientB); 
=======
        require(msg.sender == clientA_addr || msg.sender == clientB_addr); 
>>>>>>> 593b1371a0259f4787b29a231ab7548df683f789
        _; 
    }
    
    function transferFundsIfPossible() onlyParticipant public returns (bool) {
<<<<<<< HEAD
        uint token1_balance = token1_instance.balanceOf(this);
        uint token2_balance = token2_instance.balanceOf(this);
        if (token2_balance >= amountOf_token2 && token1_balance >= amountOf_token1) {
            transferFunds(token1_balance, token2_balance);
            return true;
        } else {
            return false;
=======
        uint token1_balance;
        uint token2_balance;
        bool token1_balanceIsSet = false;
        if (!token1_HasSufficientBalance) {
            token1_balance = token1_instance.balanceOf(this);
            token1_balanceIsSet = true;
            if (amountOf_token1 <= token1_balance) {
                token1_HasSufficientBalance = true;
                
                if(token2_HasSufficientBalance) {
                    transferFunds(token1_balance, token2_instance.balanceOf(this));
                    return true;
                }
            }
>>>>>>> 593b1371a0259f4787b29a231ab7548df683f789
        }
        if (!token2_HasSufficientBalance) {
            token2_balance = token2_instance.balanceOf(this);
            if (amountOf_token2 <= token2_balance) {
                token2_HasSufficientBalance = true;
                
                if (token1_HasSufficientBalance) {
                    if (token1_balanceIsSet) {
                        transferFunds(token1_balance, token2_balance);
                    } else {
                        transferFunds(token1_instance.balanceOf(this), token2_balance);
                    }
                    return true;
                }
            }
        }
        return false;
    }
    
    function transferFunds(uint _token1_balance, uint _token2_balance) internal {
        token1_instance.transfer(clientB, _token1_balance);
        token2_instance.transfer(clientA, _token2_balance);
        selfdestruct(clientA);
    }
    
    function refund() public returns (bool) {
        if (now >= timeOut) {
            uint token1_balance = token1_instance.balanceOf(this);
            uint token2_balance = token2_instance.balanceOf(this);
            if (token1_balance > 0){
                token1_instance.transfer(clientA, token1_balance);
            }
            if (token2_balance > 0){
                token2_instance.transfer(clientB, token2_balance);   
            }
            selfdestruct(clientA);
            return true;
        } else {
            return false;
        }
    }
<<<<<<< HEAD
}
=======

}
>>>>>>> 593b1371a0259f4787b29a231ab7548df683f789
