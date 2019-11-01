pragma solidity ^0.5.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

contract SSToken is ERC20, ERC20Detailed {
	constructor(uint256 initialSupply) ERC20Detailed("ssuk-ssuk token", "SST", 18) public {
		_mint(msg.sender, initialSupply);
	}
}