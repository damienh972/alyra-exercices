// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;

// import of erc721 standart contract and a counter for ids of tokens
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Counters.sol";

contract NFT is ERC721 {
   using Counters for Counters.Counter;
   Counters.Counter private tokenIds;

    // initialise NFT standart token
   constructor() public ERC721("collectible", "COL") {}

    /** 
     *@param _player address of nft owner
     *@param _tokenURI uri of nft
     */
   function addItem(address _player, string memory _tokenURI) public returns (uint256) {  
       tokenIds.increment();
       uint256 newItemId = tokenIds.current();
       _mint(_player, newItemId);
       _setTokenURI(newItemId, _tokenURI);
       return newItemId;
   }
}