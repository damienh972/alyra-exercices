
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Voting is Ownable{
    
    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }
    
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        uint id;
        string description;
        uint voteCount;
    }
    
    
    WorkflowStatus private currState;
    mapping (address  => Voter) public voters;
    Proposal[] public proposals;
    uint proposalId;
    uint public winningProposalId;
    
    
    event VoterRegistered(address voterAddress);
    event ProposalsRegistrationStarted();
    event ProposalsRegistrationEnded();
    event ProposalRegistered(uint proposalId);
    event VotingSessionStarted();
    event VotingSessionEnded();
    event Voted (address voter, uint proposalId);
    event VotesTallied();
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    
    function addVoter(address _address) external onlyOwner {
        require(voters[_address].isRegistered == false, "This address is already registered");
        require(currState == WorkflowStatus.RegisteringVoters, "The registering period is over");
        voters[_address].isRegistered = true;
        emit VoterRegistered (_address);
    }
    
    function startProposalsSession() external onlyOwner {
        require(currState == WorkflowStatus.RegisteringVoters, "A session is already in progress");
        currState = WorkflowStatus.ProposalsRegistrationStarted;
        emit WorkflowStatusChange (WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);
        emit ProposalsRegistrationStarted ();
    }
    
    function addProposal(string memory _description ) external {
        require(currState == WorkflowStatus.ProposalsRegistrationStarted, "The proposal registration period has ended or has not yet started");
        require(voters[msg.sender].isRegistered == true, "You're not registered");
        proposals.push(Proposal({
                id: proposalId,
                description: _description,
                voteCount: 0
        }));
        proposalId++;
        emit ProposalRegistered(proposalId);
    }
    
    function endProposalSession() external onlyOwner {
                require(currState == WorkflowStatus.ProposalsRegistrationStarted, "No session to end");
                currState = WorkflowStatus.ProposalsRegistrationEnded;
                emit WorkflowStatusChange (WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
                emit ProposalsRegistrationEnded ();
    }
    
    function startVotingSession() external onlyOwner {
        require(currState == WorkflowStatus.ProposalsRegistrationEnded, "A voting or proposal session is already in progress ");
        currState = WorkflowStatus.VotingSessionStarted;
        emit WorkflowStatusChange (WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
        emit ProposalsRegistrationEnded ();
        
    }
    
    function addVote(uint8 _proposalId) external {
        require(currState == WorkflowStatus.VotingSessionStarted, "Vote period has ended or has not yet started");
        require(voters[msg.sender].isRegistered == true, "You're not registered");
        require(voters[msg.sender].hasVoted == false, "You have already voted");
        proposals[_proposalId].voteCount++;
        voters[msg.sender].votedProposalId = _proposalId;
        voters[msg.sender].hasVoted = true;
        emit Voted (msg.sender, _proposalId);
    }
    
    function endVotingSession() external onlyOwner{
        require(currState == WorkflowStatus.VotingSessionStarted, "No session to end");
        currState = WorkflowStatus.VotingSessionEnded;
        emit WorkflowStatusChange (WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
        emit VotingSessionEnded ();
    }
    
    function getTheWinningProposal() external onlyOwner returns(uint) {
        require(currState == WorkflowStatus.VotingSessionEnded, "Please end voting session before get the winning proposal");
         uint winningVoteCount;
         for (uint id = 0; id < proposals.length; id++) {
            if (proposals[id].voteCount > winningVoteCount) {
                winningVoteCount = proposals[id].voteCount;
                winningProposalId = id;
            }
        }
        currState = WorkflowStatus.VotesTallied;
        emit WorkflowStatusChange (WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied);
        emit VotesTallied();
    }
    
    function showWinnerProposal() external view returns(string memory,uint) {
        return (string(abi.encodePacked("The winner is : ",proposals[winningProposalId].description)), proposals[winningProposalId].voteCount);
    }
    
    
    
    
    
    
    
    
    
}