
// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {  
    address public owner;
    
    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }
    
   constructor(uint256 initialSupply) public ERC20("zozocoin", "ZOZ") {
       owner = msg.sender;
       _mint(msg.sender, initialSupply);
   }
   
   function mint(uint256 _amount) public onlyOwner {
       _mint(msg.sender,_amount);
   }
}
