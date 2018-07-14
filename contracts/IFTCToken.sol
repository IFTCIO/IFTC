pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol';

contract IFTCToken is StandardBurnableToken {
  string public constant name = "Internet FinTech Coin";
  string public constant symbol = "IFTC";
  uint public constant decimals = 18;

  constructor() public {
    totalSupply_ = 1.2 * 10 ** 9 * 1 ether;
    balances[msg.sender] = totalSupply_;
  }
}
