module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "7555" // Match any network id
    },
    // develop: {
    //   port: 8545
    // }
  },
  compilers: {
    solc: {
      version: "<0.7.0",
    }
  }
};

