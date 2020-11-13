// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

///@notice Contract is started on 9th of November.
///@notice private sale from 9th to 19th of November
///@notice Presale from 19th to 29th of November

contract Crowdsale is ERC20 {

    uint deployTime;                                  /* save deployment time*/
    uint public privateSaleTimeLimit = 1605441600;   ///@notice 15/11/2020 at 12pm
    uint public preSaleTimeLimit = 1605873600;       ///@notice 20/11/2020 at 12pm
    uint public publicSaleTimeLimit = 1606305600;    ///@notice 25/11/2020 at 12pm
    uint public rate = 0.00023 ether;
    uint public publicSale;

    constructor(uint _totalSupply) public ERC20("BruteToken", "BrT")  {
        deployTime = block.timestamp;
        _mint(address(this),_totalSupply);
        
   }

    mapping(address => uint) private balance;
    mapping(address => mapping(address => uint)) private allowances;
    
    mapping(address => bool) public privateSaleWhitelist;
    mapping(address => bool) public preSaleWhitelist;
    
    /*enum IcoState {PrivateSale, PreSale, PublicSale, Finished}
    
    IcoState state;
*/
    
    
    
    ///@dev  behaviour on receiving ether. Will autoatically act in function of session in progress
    
    receive() external payable {
      if(block.timestamp > deployTime && block.timestamp < privateSaleTimeLimit ) {
          privateSale(msg.value);
      }
      if(block.timestamp > privateSaleTimeLimit  && block.timestamp < preSaleTimeLimit ) {
          preSale(msg.value);
      }
      if(block.timestamp > preSaleTimeLimit && block.timestamp < publicSaleTimeLimit ) {
          publicSale(msg.value);
      }
      
    }
    
        function time() external  view returns(uint){
        return block.timestamp;
    }
    
    ///@dev behaviour of crowdsale during privateSale
    function privateSale(uint _amount) internal {
        require( msg.value >= 25 ether && msg.value <= 600 ether, "not the right amount");
        uint256 tokensToSent = _amount * rate * (14/10);
        address(this).transfer(msg.sender, tokensToSent);
        //distribute(_amount, (14/10));
    }
    
    // function distribute(uint256 _amount, uint _discount) internal {
        
    //     uint256 tokensToSent =_amount * rate * _discount;
    //     address(this).transfer(msg.sender, tokensToSent);
    // }
    
    function preSale(uint _amount) internal {
        require(msg.value >= 12 ether && msg.value <= 5000 ether, "not the right amount");
        uint tokensToReceive = rate  * _amount * (120/100);
    }
    
    function publicSale(uint _amount) internal {
        require(msg.value >= 3 ether && msg.value <= 29 ether, "not the right amount");
        uint tokensToReceive = rate * _amount;
    }
}
