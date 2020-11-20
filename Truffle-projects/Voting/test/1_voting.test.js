const { expect } = require('chai');
const { BN } = require('@openzeppelin/test-helpers');
const Voting = artifacts.require("voting");

contract("Voting", (accounts) => {
    const admin = accounts[0];
    const voter1 = accounts[1];
    const voter2 = accounts[2];
    const voter3 = accounts[3];

    let VotingInstance;
    beforeEach(async function () {
        VotingInstance = await Voting.new({from: admin});
    }); 
    it("should register a voter list", async () => {
        
        const isVoterBefore = await VotingInstance.isVoter(voter1,{from: admin});
        expect(isVoterBefore).to.equal(false);

        await VotingInstance.registerVoter(voter1, {from: admin});

        const isVoterAfter = await VotingInstance.isVoter(voter1, {from: admin});
        expect(isVoterAfter).to.equal(true);
    });

    it("should start proposal registration session", async () => {
        //given
        let statusBefore = await VotingInstance.status();
       
        //when
        await VotingInstance.startProposalSession({from: admin});
        let statusAfter = await VotingInstance.status();

        //then
        expect(statusBefore).to.be.bignumber.equal(new BN(0));
        expect(statusAfter).to.be.bignumber.equal(new BN(1));
        
    });
});