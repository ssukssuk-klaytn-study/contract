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
// mint : 화폐 발행, 실행한 이후에도 화폐를 발행할 수 있도록
