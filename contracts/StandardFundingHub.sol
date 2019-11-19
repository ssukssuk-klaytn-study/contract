pragma solidity ^0.5.0;

import './FundingHub.sol';
import './Owned.sol';

contract StandardFundingHub is FundingHub, Owned {

    mapping (bytes32 => Project) public projects;
    mapping (bytes32 => bytes32) public projectList;

    constructor (
    )
        public
    {
        owner = msg.sender;
    }

    function createProject(
        uint _fundingGoal,
        uint _deadline)
        public
        returns (Project projectContract)
    {
        bytes32 projectHash = keccak256(abi.encodePacked(msg.sender, _fundingGoal, now + _deadline));

        // ensure that project does not already exist.
        require(address(projects[projectHash]) == address(0), "Status Error");
        // projectContract = new Project(msg.sender, _fundingGoal, _deadline);
        projectContract = new Project();
        addProject(projectContract, projectHash);
        emit LogStandardProjectCreation(msg.sender, projectContract);
    }

    function contribute(Project _project, uint _amount) public {
        require(address(_project) != address(0) && _amount > 0, "Status Error");
        // Project(_project).fund(_amount, msg.sender);
        Project(_project).fund();
        emit LogProjectContribution(address(_project), msg.sender, _amount);
    }

    function addProject(Project _projectContract, bytes32 _projectHash)
        internal
    {
        projects[_projectHash] = _projectContract;
        projectList[_projectHash] = projectList[0x0];
        projectList[0x0] = _projectHash;
    }
}