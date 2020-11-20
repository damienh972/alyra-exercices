
/************************************************** 
*      TEST THE FAMOUS ERC-20 SMART-CONTRACT      *
***************************************************/


const { BN } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const ERC20 = artifacts.require('ERC20Token');
 
contract('ERC20', function (accounts) {
 const _name = 'ALYRA';
 const _symbol = 'ALY';
 const _totalSupply = new BN(1000);
 const _decimals = new BN(18);
 const contractOwner = accounts[0];
 const account1 = accounts[1];
 const spender = accounts[2];
 const amount = new BN(10);
 const decreasedAmount = new BN(5);

  beforeEach(async function () {
    this.ERC20Instance = await ERC20.new(_totalSupply); 
    await this.ERC20Instance.transfer(account1, amount);
  });

  it('Has a name', async function () {
    expect(await this.ERC20Instance.name()).to.equal(_name);
  });

  it('Has a symbol', async function () {
    expect(await this.ERC20Instance.symbol()).to.equal(_symbol);
  });

  it('Has a decimal value', async function () {
    expect(await this.ERC20Instance.decimals()).to.be.bignumber.equal(_decimals);
  });

  it('Check the balance of contract owner', async function (){
    let balanceContractOwner = await this.ERC20Instance.balanceOf(contractOwner);
    let totalSupply = await this.ERC20Instance.totalSupply();
    expect(balanceContractOwner).to.be.bignumber.equal(totalSupply.sub(amount));
  });

  it('Check transfer of 10 token from account 1 to spender', async function (){
    // Balances check
    let balanceAccount1BeforeTransfer = await this.ERC20Instance.balanceOf(account1); 
    let balanceSpenderBeforeTransfer = await this.ERC20Instance.balanceOf(spender);
    // Account 1 tranfer 10 tokens to spender  
    await this.ERC20Instance.transfer(spender, amount, {from: account1}); // if no "from" specified, default value is contractOwner 
    // Balances check
    let balanceAccount1AfterTransfer = await this.ERC20Instance.balanceOf(account1);
    let balanceSpenderAfterTransfer = await this.ERC20Instance.balanceOf(spender);
    
    expect(balanceAccount1AfterTransfer).to.be.bignumber.equal(balanceAccount1BeforeTransfer.sub(amount));
    expect(balanceSpenderAfterTransfer).to.be.bignumber.equal(balanceSpenderBeforeTransfer.add(amount));
  });

  it('Check allowance from account1 to spender', async function () {
    // Approve first and allow spender an amount to spend
    await this.ERC20Instance.approve(spender, amount, {from: account1});
    // Then retrieve account1 allowance to spender
    let SpenderAllowance = await this.ERC20Instance.allowance(account1, spender);
    expect(SpenderAllowance).to.be.bignumber.equal(amount);
  });

  it('Check if allowance has been increased', async function () {
    // Approve
    await this.ERC20Instance.approve(spender, amount, {from: account1});
    let SpenderAllowanceBeforeIncrease = await this.ERC20Instance.allowance(spender, account1);
    // Increase for 10 tokens
    await this.ERC20Instance.increaseAllowance(account1, amount, {from: spender});
    let SpenderAllowanceAfterIncrease = await this.ERC20Instance.allowance(spender, account1);
    expect(SpenderAllowanceAfterIncrease).to.be.bignumber.equal(SpenderAllowanceBeforeIncrease.add(amount));
  });

  it('Check if allowance has been decreased', async function () {
    // Approve
    await this.ERC20Instance.approve(account1, amount, {from: spender});
    let SpenderAllowanceBeforeDecrease = await this.ERC20Instance.allowance(spender, account1);
    // Decrease for 5 tokens
    await this.ERC20Instance.decreaseAllowance(account1, decreasedAmount, {from: spender});
    let allowanceSpenderAfterDecrease = await this.ERC20Instance.allowance(spender, account1);
    expect(allowanceSpenderAfterDecrease).to.be.bignumber.equal(SpenderAllowanceBeforeDecrease.sub(decreasedAmount));
  });

  it('Check transfer made by spender from contract owner to account 1', async function () {

  let balanceContractOwnerBeforeTransfer = await this.ERC20Instance.balanceOf(contractOwner); 
  let balanceAccount1BeforeTransfer = await this.ERC20Instance.balanceOf(account1);

  await this.ERC20Instance.approve(spender, amount, {from: contractOwner});
  await this.ERC20Instance.transferFrom(contractOwner, account1, amount, {from: spender});

  let balanceContractOwnerAfterTransfer = await this.ERC20Instance.balanceOf(contractOwner);
  let balanceAccount1AfterTransfer = await this.ERC20Instance.balanceOf(account1);

  expect(balanceContractOwnerAfterTransfer).to.be.bignumber.equal(balanceContractOwnerBeforeTransfer.sub(amount));
  expect(balanceAccount1AfterTransfer).to.be.bignumber.equal(balanceAccount1BeforeTransfer.add(amount));
  });
});
