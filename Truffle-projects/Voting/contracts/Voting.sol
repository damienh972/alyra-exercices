// SPDX-License-Identifier: MIT
pragma solidity  0.6.12;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract voting is Ownable {

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalRegistrationStarted,
        ProposalRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VoteTallied
    }
    WorkflowStatus public status;
    mapping(address => bool) public Whitelist;

    function registerVoter(address _voter) public onlyOwner {
     Whitelist[_voter] = true;
    }

    function isVoter(address _address) public view returns(bool) {
        return Whitelist[_address];
    }

    function startProposalSession() public onlyOwner {
        status = WorkflowStatus.ProposalRegistrationStarted;
    }
}