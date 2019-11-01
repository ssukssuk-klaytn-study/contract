pragma solidity ^0.5.0;

import "./SSToken.sol";


contract Project {
	address public owner;
  SSToken public ssToken;

  constructor() public {
    owner = msg.sender;
    ssToken = new SSToken(1000);
  }
}