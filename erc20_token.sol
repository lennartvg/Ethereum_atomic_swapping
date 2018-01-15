pragma solidity ^0.4.19;

import './erc20_interface.sol';

contract TokenImplementation is ERC20 {

    string public name;
    // uint8 public decimals;
    string public symbol;
    uint256 public totalSupply = 1000000;
    
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    
    function TokenImplementation() {
        name = "BasicToken";
        // decimals = 3;
        symbol = "BT";
        balances[msg.sender] = totalSupply; 
    }
    
    function () payable {
    }
    
    // function () {
    //     //if ether is sent to this address, send it back.
    //     throw;
    // }
    
    function totalSupply() constant returns (uint256 supply) {
        return totalSupply;
    }
    
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) returns (bool success) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { 
            return false; 
        }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { 
            return false; 
        }
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

}

