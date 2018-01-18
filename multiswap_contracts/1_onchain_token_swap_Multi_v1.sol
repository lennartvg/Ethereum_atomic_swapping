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
        swaps[current_swapID].clientA = _clientA;
        swaps[current_swapID].clientB = _clientB;
        swaps[current_swapID].token1 = _token1;
        swaps[current_swapID].token2 = _token2;
        swaps[current_swapID].token1_instance = ERC20(_token1);
        swaps[current_swapID].token2_instance = ERC20(_token2);
        swaps[current_swapID].amountOf_token1 = _amountOf_token1;
        swaps[current_swapID].amountOf_token2 = _amountOf_token2;
        swaps[current_swapID].timeOut = now + 1 hours;
        current_swapID += 1;
        return (current_swapID - 1);
    }
    
    function transferFunds(uint256 _swapID) public constant returns (bool) {
        if (msg.sender == swaps[_swapID].clientA || msg.sender == swaps[_swapID].clientB) {
            uint token1_balance = swaps[_swapID].token1_instance.balanceOf(this);
            uint token2_balance = swaps[_swapID].token2_instance.balanceOf(this);
            
            if (token2_balance >= swaps[_swapID].amountOf_token2 && token1_balance >= swaps[_swapID].amountOf_token1 && now < swaps[_swapID].timeOut) {
			    swaps[_swapID].token1_instance.transfer(swaps[_swapID].clientB, token1_balance);
                swaps[_swapID].token2_instance.transfer(swaps[_swapID].clientA, token2_balance);
                return true;
            } else {
                return false;
            }    
        } else {
            return false;
        }

    }
    
    function refundFunds(uint256 _swapID) public constant returns (bool) {
        if ((msg.sender == swaps[_swapID].clientA || msg.sender == swaps[_swapID].clientB) && now >= swaps[_swapID].timeOut) {
            uint token1_balance = swaps[_swapID].token1_instance.balanceOf(this);
            uint token2_balance = swaps[_swapID].token2_instance.balanceOf(this);
        
            if (token1_balance > 0){
                swaps[_swapID].token1_instance.transfer(swaps[_swapID].clientA, token1_balance);
            }
            if (token2_balance > 0){
                swaps[_swapID].token2_instance.transfer(swaps[_swapID].clientB, token2_balance);   
            }
            return true;
        } else {
            return false;
        }
    }

}
