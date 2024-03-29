pragma solidity ^0.5.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20Mintable.sol";

contract SSToken is ERC20, ERC20Mintable {
	uint256 private _price;
	string private _name;
	string private _symbol;
	uint8 private _decimals;
	/**
	* @dev Sets the values for 'initialSupply', '`name` and `symbol`. All three of
	* these values are immutable: they can only be set once during
	* construction.
	*/
	constructor(uint256 price,
							string memory name,
							string memory symbol,
							uint8 decimals
	) public {
		_price = price;
		_name = name;
    _symbol = symbol;
		_decimals = decimals;
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

/**
	* @dev Returns the number of decimals used to get its user representation.
	* For example, if `decimals` equals `2`, a balance of `505` tokens should
	* be displayed to a user as `5,05` (`505 / 10 ** 2`).
	*
	* Tokens usually opt for a value of 18, imitating the relationship between
	* Ether and Wei.
	*
	* NOTE: This information is only used for _display_ purposes: it in
	* no way affects any of the arithmetic of the contract, including
	* {IERC20-balanceOf} and {IERC20-transfer}.
	*/
	function decimals() public view returns (uint8) {
			return _decimals;
	}
}