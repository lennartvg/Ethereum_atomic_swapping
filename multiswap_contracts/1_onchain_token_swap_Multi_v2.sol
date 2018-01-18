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
    
    uint256 current_swapID;
    mapping (uint256 => SwapInstance) swaps;
 
    function OnchainTokenSwap_Multiple() {
        current_swapID = 0;
    }

    function () public payable {
        revert();  // do not accept ETH to be sent to this contract
    }

    function initiateNewSwap(address _clientA, address _clientB, address _token1, 
            address _token2, uint _amountOf_token1, uint _amountOf_token2) public constant returns (uint256) {
        var swap = swaps[current_swapID];
        swap.clientA = _clientA;
        swap.clientB = _clientB;
        swap.token1 = _token1;
        swap.token2 = _token2;
        swap.token1_instance = ERC20(_token1);
        swap.token2_instance = ERC20(_token2);
        swap.amountOf_token1 = _amountOf_token1;
        swap.amountOf_token2 = _amountOf_token2;
        swap.timeOut = now + 1 hours;
        current_swapID += 1;
        return (current_swapID - 1);
    }
    
    function transferFunds(uint256 _swapID) public constant returns (bool) {
        var swap = swaps[_swapID];
        if (msg.sender == swap.clientA || msg.sender == swap.clientB) {
            uint token1_balance = swap.token1_instance.balanceOf(this);
            uint token2_balance = swap.token2_instance.balanceOf(this);
            
            if (token2_balance >= swap.amountOf_token2 && token1_balance >= swap.amountOf_token1 && now < swap.timeOut) {
			    swap.token1_instance.transfer(swap.clientB, token1_balance);
                swap.token2_instance.transfer(swap.clientA, token2_balance);
                return true;
            } else {
                return false;
            }    
        } else {
            return false;
        }

    }
    
    function refundFunds(uint256 _swapID) public constant returns (bool) {
        var swap = swaps[_swapID];
        if ((msg.sender == swap.clientA || msg.sender == swap.clientB) && now >= swap.timeOut) {
            uint token1_balance = swap.token1_instance.balanceOf(this);
            uint token2_balance = swap.token2_instance.balanceOf(this);
        
            if (token1_balance > 0){
                swap.token1_instance.transfer(swap.clientA, token1_balance);
            }
            if (token2_balance > 0){
                swap.token2_instance.transfer(swap.clientB, token2_balance);   
            }
            return true;
        } else {
            return false;
        }
    }

}
