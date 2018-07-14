var IFTCToken = artifacts.require("IFTCToken");

contract('IFTCToken', function(accounts) {
  it("constructor variables should be correct", function() {
    return IFTCToken.deployed().then(function(instance) {
      assert.equal(instance.name, "Internet FinTech Coin", "The name is not euqal Internet FinTech Coin");
      assert.equal(instance.symbol, "IFTC", "The symbol is not euqal IFTC");
      assert.equal(instance.decimals, 18, "The decimals is not euqal 18");
    })
  });
});
