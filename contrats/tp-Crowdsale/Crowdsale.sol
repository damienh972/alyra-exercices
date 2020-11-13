// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;

import "./ERC20Token.sol";

///@notice Contract is started on 9th of November.
///@notice private sale from 9th to 19th of November
///@notice Presale from 19th to 29th of November


contract Crowdsale {

    uint deployTime;                                  /* save deployment time*/
    uint public privateSaleTimeLimit = 1605441600;   ///@notice 15/11/2020 at 12pm
    uint public preSaleTimeLimit = 1605873600;       ///@notice 20/11/2020 at 12pm
    uint public publicSaleTimeLimit = 1606305600;    ///@notice 25/11/2020 at 12pm
    
    uint public rate = 100;
    uint EthersReceived;                  // how many ethers received by the contract, from sales functions
    uint softCap = 2000;                  //Minimum target
    uint tokensToBeSold = 5000000;        //tokensToBeSold   
    bool CrowdsaleSuccesful;              //If Minimum target is met
    ERC20Token public token;
    
    event PrivateSale(uint, uint);
    event PreSale(uint, uint);
    event PublicSale(uint, uint);

    constructor(uint _totalSupply) public  {
        deployTime = block.timestamp;
        token = new ERC20Token(_totalSupply);
   }


    mapping(address => bool) public privateSaleWhitelist;
    mapping(address => bool) public preSaleWhitelist;
    mapping(address => uint) moneySent;
    mapping(address => uint) tokensToReceive;
    
    
    ///@dev  behaviour on receiving ether. Will automatically act in function of session in progress
    
    receive() external payable {
        require(block.timestamp < publicSaleTimeLimit, "Sale is over");
        
        if(block.timestamp > deployTime && block.timestamp < privateSaleTimeLimit ) {
          privateSale(msg.value, msg.sender);
        }
        if(block.timestamp > privateSaleTimeLimit  && block.timestamp < preSaleTimeLimit ) {
          preSale(msg.value, msg.sender);
        }
        if(block.timestamp > preSaleTimeLimit && block.timestamp < publicSaleTimeLimit ) {
          publicSale(msg.value, msg.sender);
        }
      
    }
    
    
    ///@dev behaviour of crowdsale during privateSale
    function privateSale(uint _amount, address _caller) internal {
        require(moneySent[_caller] + _amount >= 25 ether && moneySent[_caller] + _amount <= 600 ether, "not the right amount");
        require(tokensToBeSold - _amount > 4000000, "limit reached");
        uint _tokensToReceive = rate  * _amount;
        
        moneySent[_caller] += _amount;
        tokensToReceive[_caller] += _tokensToReceive;
        EthersReceived += _amount;
        tokensToBeSold -= _tokensToReceive;
        emit PrivateSale(_amount, _tokensToReceive);
    }
    
    function preSale(uint _amount, address _caller) internal {
        require(moneySent[_caller] + _amount >= 12 ether && moneySent[_caller] + _amount <= 5000 ether, "not the right amount");
        require(tokensToBeSold - _amount > 1000000, "limit reached");
        uint _tokensToReceive = rate  * _amount;
        
        moneySent[_caller] = _amount;
        tokensToReceive[_caller] = _tokensToReceive;
        EthersReceived += _amount;
        tokensToBeSold -= _tokensToReceive;
        emit PreSale(_amount, _tokensToReceive);
    }
    
    function publicSale(uint _amount, address _caller) internal {
        require(moneySent[_caller] + _amount >= 3 ether && moneySent[_caller] + _amount <= 29 ether, "mini 3 ethers, maxi 29 ethers");
        require(tokensToBeSold - _amount > 0, "all tokens already sold");
        uint _tokensToReceive = rate  * _amount;
        
        moneySent[_caller] = _amount;
        tokensToReceive[_caller] = _tokensToReceive;
        EthersReceived += _amount;
        tokensToBeSold -= _tokensToReceive;
        emit PublicSale(_amount, _tokensToReceive);
    }
    
    function withdraw() external {
        require(block.timestamp > publicSaleTimeLimit);
        
        if(EthersReceived > softCap){
            CrowdsaleSuccesful = true;
        }
        if(CrowdsaleSuccesful == true){
        token.transfer(msg.sender, tokensToReceive[msg.sender]);
        }
        if(CrowdsaleSuccesful == false){
        address(this).transfer(moneySent[msg.sender]);
        }
    }
}
