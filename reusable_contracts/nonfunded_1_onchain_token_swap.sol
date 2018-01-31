pragma solidity ^0.4.18;

import './erc20_interface.sol';

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
    
    mapping (bytes20 => SwapInstance) swaps;
 
    function OnchainTokenSwap_Multiple() public {
        // constructor
    }

    function () public payable {
        revert();  // do not accept ETH to be sent to this contract
    }

    function initiateNewSwap(bytes20 _swapID, address _clientA, address _clientB, address _token1, 
        address _token2, uint _amountOf_token1, uint _amountOf_token2) public {
        
        swaps[_swapID] = SwapInstance({clientA:msg.sender, clientB:_clientB, token1:_token1, token2:_token2,
            token1_instance:ERC20(_token1), token2_instance:ERC20(_token2), amountOf_token1:_amountOf_token1, amountOf_token2: _amountOf_token2,
            timeOut:(now + 1 hours)});
    }
    
    function validateSwapInstance(bytes20 _swapID, address _clientA, address _clientB, address _token1, 
        address _token2, uint _amountOf_token1, uint _amountOf_token2) public constant returns (bool) {
        SwapInstance memory s = swaps[_swapID];
        
        if (_clientA == s.clientA && _clientB == s.clientB && _token1 == s.token1 && _token2 == s.token2
        && _amountOf_token1 == s.amountOf_token1 && _amountOf_token2 == s.amountOf_token2) {
            return true;
        } else {
            return false;
        }
    }
    
    function claim(bytes20 _swapID) public returns (bool) {
        SwapInstance memory s = swaps[_swapID];
        // require(bool condition): abort execution and revert state changes if condition is false
        if (msg.sender == s.clientB) {
    		require(s.token1_instance.transferFrom(s.clientA, s.clientB, s.amountOf_token1));
    		require(s.token2_instance.transferFrom(s.clientB, s.clientA, s.amountOf_token2));
    		return true;
        } else {
            return false;
        }
    }
}
