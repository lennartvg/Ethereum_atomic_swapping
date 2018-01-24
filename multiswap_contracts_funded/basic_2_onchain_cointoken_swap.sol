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
    
    struct SwapInstance {
        address clientA;  // wallet
        address clientB;  // wallet
        address token;  // contract
        ERC20 token_instance;
        uint amountOf_token;
        uint amountOf_ETH;
        uint timeOut; 
    }
    
    mapping (uint => SwapInstance) swaps;
 
    function OnchainCoinTokenSwap() public {
        // constructor
    }
    
    function () payable public {
        // accept ETH to be sent to this contract
    }

    function initiateNewSwap(uint _swapID, address _clientA, address _clientB, address _token, uint _amountOf_token, uint _amountOf_ETH) public {
        
        swaps[_swapID] = SwapInstance({clientA:_clientA, clientB:_clientB, token:_token, token_instance:ERC20(_token), 
        amountOf_token:_amountOf_token, amountOf_ETH:_amountOf_ETH, timeOut:(now + 1 hours)});
    }
    
    function transferFunds(uint _swapID) public returns (bool) {
        SwapInstance memory s = swaps[_swapID];
        if (msg.sender == s.clientA || msg.sender == s.clientB) {
            uint token_balance = s.token_instance.balanceOf(this);
            uint ETH_balance = this.balance / 10**18;
            
            if (token_balance >= s.amountOf_token && ETH_balance >= s.amountOf_ETH && now < s.timeOut) {
			    s.token_instance.transfer(s.clientB, token_balance);
                s.clientA.transfer(ETH_balance * 10**18);
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
            uint token_balance = s.token_instance.balanceOf(this);
            uint ETH_balance = this.balance / 10**18;
        
            if (token_balance > 0){
                s.token_instance.transfer(s.clientA, token_balance);
            }
            if (ETH_balance > 0){
                s.clientB.transfer(ETH_balance * 10**18);
            }
            return true;
        } else {
            return false;
        }
    }

}
