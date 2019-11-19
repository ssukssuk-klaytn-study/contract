pragma solidity ^0.5.0;

contract Owned {
    address public owner;

    constructor () public {
        owner = msg.sender;
    }

    modifier fromOwner {
        require(msg.sender == owner,
                "Invalid Owner");
        _;
    }

    function setOwner(address newOwner) fromOwner public {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }
}