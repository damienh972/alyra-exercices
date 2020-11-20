
const { expect } = require('chai');
const Greeter = artifacts.require('Greeter');

contract('Greeter', function (accounts) {
    beforeEach(async function () {
        this.GreeterInstance = await Greeter.new("rastafari"); 
    });

    it ("Check deployement", async function() {
        expect(await this.GreeterInstance.greet()).to.equal("rastafari")
    });

    it ("Check greeting set", async function() {
        this.GreeterInstance = await Greeter.new("rototom"); 
        expect(await this.GreeterInstance.greet()).to.equal("rototom")
    });
});