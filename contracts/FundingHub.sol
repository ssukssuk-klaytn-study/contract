pragma solidity ^0.5.0;

import './Project.sol';

contract FundingHub {
// 주소 & contract 매핑해서 프로젝트를 만듦

    event LogStandardProjectCreation(address indexed projectCreator, Project indexed standardProject);
    event LogProjectContribution(address indexed projectContract, address contributor, uint contribution);

    enum Status {
        Active,
        Inactive
    }

    address public creator;
    uint public createdAtBlock;
    Status public status;

    function createProject(uint _fundingGoal, uint _deadline) public returns(Project);
    function contribute(Project _project, uint _contribution) public;
}
