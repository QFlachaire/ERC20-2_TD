pragma solidity >=0.6.0;

import "./ERC20Claimable.sol";

contract ExerciceSolution {
    
    mapping(address => uint256) public claimedToken;
    ERC20Claimable claimableERC20;

    constructor(ERC20Claimable _claimableToken) public {
        claimableERC20 = _claimableToken;
	}

    function claimTokensOnBehalf() external {
        claimableERC20.claimTokens();
        uint256 amount = claimableERC20.distributedAmount();
        claimedToken[msg.sender] += amount;
    }
}