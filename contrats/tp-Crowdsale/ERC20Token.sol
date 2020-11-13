
// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {   
    
   constructor(uint256 initialSupply) public ERC20("zozocoin", "ZOZ") {
       _mint(msg.sender, initialSupply);
   }
}
