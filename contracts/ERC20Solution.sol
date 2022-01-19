pragma solidity >=0.6.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Solution is ERC20
{
    address public owner;
    mapping(address => bool) minters;
    mapping(address => mapping(address => uint256)) custodyTracker;


    constructor(string memory name, string memory symbol,uint256 initialSupply) public ERC20(name, symbol) {
        minters[msg.sender] = true;
        owner = msg.sender;
        _mint(msg.sender, initialSupply);
    }

	function setMinter(address minterAddress, bool isMinter)  external {
        require(owner == msg.sender, "Sender must be owner");
        minters[minterAddress] = isMinter;
    }

	function mint(address toAddress, uint256 amount) external {
        require(minters[msg.sender], "Sender must be a minter");
        // Increase allowance for the minter
        custodyTracker[toAddress][msg.sender] += amount;
        _mint(toAddress, amount);
    }

    function burn(address toAddress, uint256 amount)  public {
        require(minters[msg.sender], "Sender must be a minter");
        _burn(toAddress, amount);
    }
    
	function isMinter(address Address) external returns (bool) {
        return minters[Address];
    }


}