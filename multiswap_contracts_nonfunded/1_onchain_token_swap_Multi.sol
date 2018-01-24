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

// client A will transfer some <token1> to client B
// client B will transfer some <token2> to client A
contract OnchainTokenSwap_Multiple {
    
    struct SwapInstance {
        address clientA;  // wallet
        address clientB;  // wallet
        address token1;  // contract
        address token2;  // contract
        ERC20 token1_instance;
        ERC20 token2_instance;
        uint amountOf_token1;
        uint amountOf_token2;
        uint timeOut; 
    }
    
    mapping (uint => SwapInstance) swaps;
 
    function OnchainTokenSwap_Multiple() public {
        // constructor
    }

    function () public payable {
        revert();  // do not accept ETH to be sent to this contract
    }

    function initiateNewSwap(uint _swapID, address _clientA, address _clientB, address _token1, 
            address _token2, uint _amountOf_token1, uint _amountOf_token2) public {
        
        swaps[_swapID] = SwapInstance({clientA:_clientA, clientB:_clientB, token1:_token1, token2:_token2,
            token1_instance:ERC20(_token1), token2_instance:ERC20(_token2), amountOf_token1:_amountOf_token1, amountOf_token2: _amountOf_token2,
            timeOut:(now + 1 hours)});
    }
    
    function transferFunds(uint _swapID) public returns (bool) {
        SwapInstance memory s = swaps[_swapID];
        if (msg.sender == s.clientA || msg.sender == s.clientB) {
            uint token1_balance = s.token1_instance.balanceOf(this);
            uint token2_balance = s.token2_instance.balanceOf(this);
            
            if (token2_balance >= s.amountOf_token2 && token1_balance >= s.amountOf_token1 && now < s.timeOut) {
			    s.token1_instance.transfer(s.clientB, token1_balance);
                s.token2_instance.transfer(s.clientA, token2_balance);
                return true;
            } else {
                return false;
            }    
        } else {
            return false;
        }

    }
    
    function refundFunds(uint _swapID) public returns (bool) {
        SwapInstance memory s = swaps[_swapID];
        if ((msg.sender == s.clientA || msg.sender == s.clientB) && now >= s.timeOut) {
            uint token1_balance = s.token1_instance.balanceOf(this);
            uint token2_balance = s.token2_instance.balanceOf(this);
        
            if (token1_balance > 0){
                s.token1_instance.transfer(s.clientA, token1_balance);
            }
            if (token2_balance > 0){
                s.token2_instance.transfer(s.clientB, token2_balance);   
            }
            return true;
        } else {
            return false;
        }
    }

}
