pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/crowdsale/Crowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol';

contract IFTCCrowdsale is Crowdsale, WhitelistedCrowdsale, TimedCrowdsale {
  using SafeMath for uint256;

  mapping(address => uint256) public balances;
  // Total of approved tokens
  uint256 public tokensAmount;
  // Total of claim tokens
  uint256 public returnTokensAmount;

  event ReturnToken(
    address indexed purchaser,
    address indexed beneficiary,
    uint256 value,
    uint256 amount
  );

  constructor(address _wallet, ERC20 _token, uint256 _tokensAmount, uint256 _openingTime, uint256 _closingTime) Crowdsale(1, _wallet, _token) TimedCrowdsale(_openingTime, _closingTime) public {
    tokensAmount = _tokensAmount;
  }

    /**
   * @dev Reverts if out of time range.
   */
  modifier onlyWhileClosed {
      require(block.timestamp >= closingTime);
      _;
  }

  /**
  * @dev Distribute tokens
  * @param _beneficiary Distribute address
  */
  function claim(address _beneficiary) public onlyWhileClosed isWhitelisted(_beneficiary) {
    uint256 price = balances[_beneficiary];
    require(price > 0);
    balances[_beneficiary] = 0;
    uint256 tokens = _calculateTokenAmount(price);
    returnTokensAmount = returnTokensAmount.add(tokens);
    _deliverTokens(_beneficiary, tokens);
    emit ReturnToken(msg.sender, _beneficiary, price, tokens);
  }

  // Initialize balances
  function initBalances() public returns (bool) onlyOwner {
      return token.transferFrom(wallet, address(this), tokensAmount);
  }

  function getTokens(
    address _beneficiary
  )
    public view
    returns (uint256)
  {
      return _getTokenAmount(balances[_beneficiary]);
  }

  function _processPurchase(
    address _beneficiary,
    uint256 _tokenAmount
  )
    internal
  {
    balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
  }

  function _getTokenAmount(
    uint256 _weiAmount
  )
    internal view
    returns (uint256)
  {
    return _weiAmount;
  }

  function _calculateTokenAmount(
    uint256 _weiAmount
  )
    public view
    returns (uint256)
  {
      return _weiAmount.mul(tokensAmount).div(weiRaised);
  }

    /**
   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _preValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  )
    internal
  {
    require(_weiAmount >= 0.01 ether);
    super._preValidatePurchase(_beneficiary, _weiAmount);
  }
}