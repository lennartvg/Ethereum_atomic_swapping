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

contract CrosschainTokenSwap {
    
    address clientA;  // wallet
    address clientB;  // wallet
    address token;  // contract
    ERC20 token_instance;
    bytes32 hashed_secret;
    uint timeOut;
    
    function CrosschainTokenSwap(address _clientA, address _clientB, address _token, bytes32 _hashed_secret) public {
        clientA = _clientA;
        clientB = _clientB;
        token = _token;
        token_instance = ERC20(token);
        hashed_secret = _hashed_secret;
        timeOut = now + 1 hours;
    }

    function () public payable {
        revert();  // do not accept ETH to be sent to this contract
    }

    function claim(string _secret) public returns (bool) {
       if (hashed_secret == sha256(_secret) && now < timeOut){
            uint token_balance = token_instance.balanceOf(this);
            token_instance.transfer(clientB, token_balance);
            selfdestruct(clientA);
            return true;
       } else {
            return false;
       }
    }

    function refund() public returns (bool) {
        if (msg.sender == clientA && now >= timeOut) {
            uint token_balance = token_instance.balanceOf(this);
            token_instance.transfer(clientA, token_balance);
            selfdestruct(clientA);
            return true;
        } else {
            return false;
        }
    }
    
}


