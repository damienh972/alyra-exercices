# Join our Private Blockchain!!!  


## you can run node on a "promo-sharding" private blockchain using geth.

1. Clone repo.  


2. In your terminal go to folder's root.  


3. If not installed go to https://geth.ethereum.org/docs/install-and-build/installing-geth to install.  


3. Enter `geth --datadir . --syncmode 'full' --networkid "14142" --port "30303" --http --http.addr 'localhost' --http.port "8545" --http.api 'personal,eth,net,web3,txpool,miner,ethash,admin'  --nodiscover --gasprice '0' --allow-insecure-unlock --unlock 'a2d8929c715470dd595447547c5fb13df4e531ce' --password ./pwd.txt`  


4. The private blockchain will start, if you want to start mining open another terminal and enter `geth attach http://localhost:8545`, it'll open the geth console.  


5. Once you open the geth console enter `miner.start()` if it return null it's ok.now you can see mining in the blockchain!!!:heart_eyes:

