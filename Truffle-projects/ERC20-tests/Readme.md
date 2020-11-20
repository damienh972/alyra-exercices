# ERC20-tests


## Using tests with "chai"

Test the standart `ERC20Token` smart-contract using JS:

- Functions
    - [x] `name`
    - [x] `symbol`
    - [x] `decimals`
    - [x] `totalSupply`
    - [x] `balanceOf`
    - [x] `transfer`
    - [x] `approve`
    - [x] `alowance`
    - [x] `transferFrom`
    - [x] `increaseAllowance`
    - [x] `decreaseAllowance`
- Events
    - [ ] `Transfer`
    - [ ] `Approval`


# Get started

1. Clone the repo  


2. `npm install` or `yarn`  


3. Open or install ganache https://www.trufflesuite.com/ganache  


4. connect ganache on metamask using port `8545`     


5. In your terminal at folder's root : `truffle test` 





# Usage

- Launch your local *Ganache* and make sure it runs on port `7545`.
- Launch all the tests like so:
```
truffle test --network develop
```