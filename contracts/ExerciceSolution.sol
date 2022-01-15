pragma solidity >=0.6.0;

import "./ERC20Claimable.sol";
import "./ERC20Solution.sol";

contract ExerciceSolution {
    
    mapping(address => uint256) public custodyTracker;
    ERC20Claimable claimableERC20;
    ERC20Solution solutionERC20;

    constructor(ERC20Claimable _claimableToken, ERC20Solution _solutionERC20) public {
        claimableERC20 = _claimableToken;
        solutionERC20 = _solutionERC20;
	}

    function claimTokensOnBehalf() external {
        claimableERC20.claimTokens();
        uint256 amount = claimableERC20.distributedAmount();
        custodyTracker[msg.sender] += amount;
        solutionERC20.mint(msg.sender, amount);
    }

	function tokensInCustody(address callerAddress) external returns (uint256){
        return custodyTracker[callerAddress];
    }
    
    function withdrawTokens(uint256 amountToWithdraw) public returns (uint256) {
        require(custodyTracker[msg.sender] > 0, "Empty Custody");
        require(amountToWithdraw <= custodyTracker[msg.sender], "Please send more tokens in custody");
        
        claimableERC20.transfer(msg.sender, amountToWithdraw);
        
        custodyTracker[msg.sender] = custodyTracker[msg.sender] - amountToWithdraw;
        solutionERC20.burn(msg.sender, amountToWithdraw);
        return amountToWithdraw;
    }

	function depositTokens(uint256 amountToWithdraw) external returns (uint256){ 
        require(amountToWithdraw > 0, "Empty amount to deposit");
        uint256 allowance = claimableERC20.allowance(msg.sender, address(this));
        require(allowance >= amountToWithdraw, "Not enough allowance");

        claimableERC20.transferFrom(msg.sender, address(this), amountToWithdraw);
        custodyTracker[msg.sender] += amountToWithdraw;
        solutionERC20.mint(msg.sender, amountToWithdraw);
        return amountToWithdraw;
    }

	function getERC20DepositAddress() external returns (address){
        return address(solutionERC20);
    }
}