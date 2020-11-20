// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "../node_modules/@openzeppelin/contracts/math/SafeMath.sol";

contract TimeLock {
    using SafeMath for uint;

    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() external payable { 
        balances[msg.sender] = balances[msg.sender].add(msg.value); 
        lockTime[msg.sender] = now + 1 weeks;
    }

    function increaseLockTime(uint _millisecondsToIncrease) public {
        lockTime[msg.sender] = lockTime[msg.sender].add(_millisecondsToIncrease);
    }

    function withdraw() public {
        require(balances[msg.sender] > 0,   "Insufficient funds" ); 
        require(now > lockTime[msg.sender], "Lock time not expired");
        
        uint amount           = balances[msg.sender]; 
        balances[msg.sender]  = 0;
        (bool sent, )         = msg.sender.call{value: amount}(""); 
        
        require(sent, "Failed to send Ether");
    }
}
