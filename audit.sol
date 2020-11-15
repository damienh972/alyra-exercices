                                                                                                //          Audit result

pragma solidity ^0.5.12;                                                                        
                                                                                                //-1 missing import of SafeMath
contract Crowdsale {
   using SafeMath for uint256;          
 
   address public owner; // the owner of the contract
   address public escrow; // wallet to collect raised ETH
   uint256 public savedBalance = 0; // Total amount raised in ETH
   mapping (address => uint256) public balances; // Balances in incoming Ether
 
   // Initialization
   function Crowdsale(address _escrow) public{                                                  //-2 better use constructor function instead
       owner = tx.origin;                                                                       //-3 SECURITY_ISSUE, use msg.sender instead of tx.origin
       // add address of the specific contract
       escrow = _escrow;
   }
  
   // function to receive ETH
   function() public {                                                                          //-4 SECURITY_ISSUE, functions to receive payments must me receive or fallback "payable" function
       balances[msg.sender] = balances[msg.sender].add(msg.value);                                                  
       savedBalance = savedBalance.add(msg.value);
       escrow.send(msg.value);                                                                  //-5 better use: (bool success, ) = someAddress.call{value: 55}("");
   }                                                                                            // if(!success) {
                                                                                                //      manage error
   // refund investisor                                                                         // } to manage exeptions errors, and optimize gaz fees
   function withdrawPayments() public{
       address payee = msg.sender;
       uint256 payment = balances[payee];
 
       payee.send(payment);                                                                     //-6 same as -5
 
       savedBalance = savedBalance.sub(payment);
       balances[payee] = 0;
   }
}