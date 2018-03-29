# c h a i r s

(smart contract demo / university project)

A basic contract that lets players play a game similar to Musical Chairs
(although without music).

An entry fee can be placed, in which case the winner gets the sum of all
fees.

## Running

Before running for the first time, run:

```
npm install
truffle compile
npm run build
```

In order to run this project inside an Ethereum simulation, run:

```
testrpc
truffle migrate --reset
npm run server
```

You can then find the contract address and sample user addresses in the
output of `testrpc` that you can then use inside the web application.
