// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {  
    address public owner;
    
    // ownership check modifier
    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    /** 
     *@param _initialSupply number of token
     */
   constructor(uint256 _initialSupply) public ERC20("belt", "BJJ") {
       owner = msg.sender;
       // imported function that will create our token 
       _mint(msg.sender, _initialSupply);
   }
}
