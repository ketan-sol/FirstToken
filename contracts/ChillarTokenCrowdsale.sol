// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;
import "./Crowdsale.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";

contract ChillarTokenCrowdsale is Crowdsale, Ownable {

    using SafeMath for uint256;
    
    uint256 preICOSupply = 30000000;
    uint256 ICOSupply = 50000000;
    uint256 remainingSupply = 20000000;
    uint256 preICORate = 300000;
    uint256 ICORate = 150000;
    uint256 remainingRate = 750;

    uint256 public AvailableTokens = preICOSupply;

    enum CrowdsaleStages { PreICO, ICO, RemainingSale}
    
    CrowdsaleStages public stage = CrowdsaleStages.PreICO;

    constructor(
        uint256 price,
        address payable purse,
        ERC20 coin
    ) 
     Crowdsale(price, purse, coin) {}    
    /*
    assume 1 ETH == $3000
therefore, 10^18 wei = $3000
therefore, 1 USD is 10^18 /3000, or 0.3 * 10^15 wei
we have a decimals of 18, so we’ll use 10 ^ 18 TKNbits instead of 1 TKN
therefore, if the participant sends the crowdsale (1usd)0.3 * 10^15 wei we should give them 10 ^ 18 TKNbits
therefore the rate is 0.3 * 10^15 wei === 10^18 TKNbits, or 1 wei = 3000 TKNbits
therefore, our rate for 1 usd = 30000000
therefore, our rate for 0.01 usd = 30000000/100 = 300000
therefore, our rate for 0.02 usd = 30000000/200 = 150000

*/


    function getStageRate() public view  returns (uint256) {
        if (stage == CrowdsaleStages.ICO) {
            return ICORate;
        } else if (stage == CrowdsaleStages.RemainingSale) {
            return remainingRate;
        }
        else {
            return preICORate;
        }
    }

    function _processBuy(address beneficiary, uint256 tokenAmount) internal  {
        require( tokenAmount <= AvailableTokens * 10**18, "Request for less quantity");
        AvailableTokens = AvailableTokens - (tokenAmount / 10**18);
        if (AvailableTokens == 0) {
            changeCrowdsaleStage();
        }
        super._deliverTokens(beneficiary, tokenAmount);
    }

    function changeCrowdsaleStage() internal {
        if (stage == CrowdsaleStages.PreICO && AvailableTokens == 0) {
                 stage = CrowdsaleStages.ICO;
            AvailableTokens = ICOSupply;
        } else if (stage == CrowdsaleStages.ICO && AvailableTokens == 0) {
            stage = CrowdsaleStages.RemainingSale;
            AvailableTokens = remainingSupply;
        }
    }
}