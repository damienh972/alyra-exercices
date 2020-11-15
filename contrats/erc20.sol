// SPDX-License-Identifier: MIT
pragma solidity >=0.6.11;
// Open source contract usefull for transfer security (prevent overflow and reentrancy attack).
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";

    contract ERC20 {
    
    using SafeMath for uint;
    
    string public name;
    string public symbol;
    uint private _totalSupply;
    uint public decimals;

    // Events useful for retrieving information about erc20 functions
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint amount);
    
    
    mapping(address => uint) private balance;
    mapping(address => mapping(address => uint)) private allowances;

    /** 
     *@param _name name of the token
     *@param _symbol symbol of the token (ex:ABC)
     *@param  _initialSupply number of token
     */
    constructor(string memory _name, string memory _symbol, uint _initialSupply) public {
        name = _name;
        symbol = _symbol;
        decimals = 18;
        totalSupply = _initialSupply*10**decimals; // Allows you to divide a token into 10 ** decimal units
        balance[msg.sender] = totalSupply;
        
    }
    
    // getters
    function totalSupply() public view returns (uint) {
        return totalSupply;
    }
    
    /** 
     *@param _tokenOwner address to be entered to consult the token balance
     */
    function balanceOf(address _tokenOwner) public view returns (uint) {
        return balance[_tokenOwner];
    }
    
     /** 
     *@param _to address to send tokens
     *@param _amount amount of token to send
     */
    function transfer(address _to, uint _amount) public returns(bool success) {
        balance[msg.sender] = balance[msg.sender].sub(_amount);
        balance[_to] = balance[_to].add(_amount);
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }
    
    /** 
     *@param _spender address to give token allowance
     *@param _amount amount of token given for allowance
     */
    function approve(address _spender, uint _amount) external returns (bool success) {
        require(_amount <= balance[msg.sender], "Not enough balance");
        allowances[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender,_amount);
        return true;
    }
    
    /** 
     *@param tokenOwner address of token owner
     *@param spender address of allowed spender
     */
    function allowance(address tokenOwner, address spender) view external returns (uint remaining) {
        return allowances[tokenOwner][spender];
    }
    
    /** 
     *@param _from sending address 
     *@param _to reception address
     *@param  _amount number of token
     */
    function transferFrom(address _from, address _to, uint _amount) external returns (bool success) {
        require(allowances[_from][msg.sender] >= _amount, "Insuffisant remaining");
        require(balance[_from] > _amount, "Not enough funds");
        require(_to != address(0), "Invalid address");
        allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);
        balance[_from] = balance[_from].sub(_amount);
        balance[_to] = balance[_to].add(_amount);
        return true;
    }
}
