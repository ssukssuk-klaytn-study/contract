pragma solidity ^0.5.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FundingToken is ERC20 {
	uint256 private _price;
	string private _name;
	string private _symbol;

	/**
	* @dev Sets the values for 'initialSupply', '`name` and `symbol`. All three of
	* these values are immutable: they can only be set once during
	* construction.
	*/
	constructor(uint256 initialSupply, uint256 price, string memory name, string memory symbol) public {
		_mint(msg.sender, initialSupply);
		_price = price;
		_name = name;
    _symbol = symbol;
	}

	/**
		* @dev Returns the price of the token.
		*/
	function price() public view returns (uint256) {
			return _price;
	}

	/**
		* @dev Returns the name of the token.
		*/
	function name() public view returns (string memory) {
			return _name;
	}

	/**
		* @dev Returns the symbol of the token, usually a shorter version of the
		* name.
		*/
	function symbol() public view returns (string memory) {
			return _symbol;
	}
}