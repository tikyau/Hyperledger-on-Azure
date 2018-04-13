# Fabric boilerplate
This is a boilerplate application to get you up and running quickly with your own blockchain application. With this boilerplate you get an application that you can run locally as well as on IBM Bluemix. There is a simple Angular frontend application, a NodeJS backend application and of course a blockchain network, all running in containers. Locally, the boilerplate starts up a blockchain network using Docker containers; on Bluemix you can use the Blockchain service.

The boilerplate uses Hyperledger Fabric v0.6.1-preview and HFC 0.6.5.

It has been created and is maintained by the IBM CIC Benelux Blockchain team. Pull requests are more than welcome!

## Prerequisites
- Docker and docker-compose (https://www.docker.com/)

To have good support in your IDE it's advisable to also install NPM, TypeScript, TSLint and Golang.

## Getting started
1. Fork this repo  
2. `git clone` your fork  
3. `cd` into the main directory  
4. `git checkout v2-typescript`  
5. `npm install` (or, if you don't have npm, `./install.sh`).  

This will pull the baseimage, peer and memberservice, download the Go dependencies of the chaincode and build your containers. It will take a while.  

To get rid of missing module errors in your IDE, also run `npm install` from the `server` and `client` directory. This is not mandatory to run the application.

## Running the application
To run the application, simply do `docker-compose up`.

This will start the three tiers of our application in separate containers:  
1. One validating peer  
2. The memberservice  
3. The NodeJS server, which registers the users and deploys the chaincode on first boot  
4. The Angular frontend, which connects to the server through a REST API.  

The app is running on `http://localhost:4200/`. You can login with the user credentials you find in `server/resources/testData.json`  

## Development
Both the frontend and the server use filewatchers. Any change in the source files will trigger the transpiler and restart that part of the application.  

Every time you pull changes, update the package.json of the server or client or change anything that might affect deployment of chaincode: `docker-compose build`.  

When you end docker-compose, the containers still exist. They keep state:  
- Memberservice:  
  - The registered users and webAppAdmin  
- Peer:  
  - World state and ledger  
- Server:  
  - chaincodeId of the last deployment  
  - keyValStore with the private keys of the users  

So if you start the app again, you can use your old chaincode. If you want to clear, just run with `docker-compose --force-recreate`.  

Currently if you change the chaincode you will have to recreate the containers. In the future we will add a filewatcher for the chaincode as well.

Notes:
- if anyone updates the npm packages all developers have to rebuild the containers  
- if you add angular components from your host environment, make sure you have the correct angular-cli version! To be sure you can enter the client container and do it from there.

## Updating the Fabric
1. Update the HFC client in the package.json  
2. Update the commit level in `blockchain/src/build-chaincode/vendor.yml`.
3. Delete the `blockchain/src/build-chaincode/vendor` directory  
4. `npm run govend` from the project root  
5. Update the baseimage and tag as latest
6. `docker-compose build`  

## Tests
We support unittests for the server, client and chaincode. Especially for writing chaincode we recommend a test-driven approach to save time. You can find the commands to run the tests in the package.json in the root:  
- `npm run test-go` (`blockchain/src/build-chaincode/chaincode_test.go` contains mock functions for the chaincode stub)
- `npm run test-server` (see the `server/tests` directory)
- `npm run test-client` (each component has its own test, courtesy of angular-cli)
- `npm run test-e2e` (needs the application to be running, it hits the API endpoints for end to end testing)
- `npm test` runs all the tests except for e2e.

You can also run the server tests directly from the server directory with `npm test` and `npm run e2e`.

# Troubleshooting
- `no rows in result set`: The memberservice remembers something outdated. Stop your app and run `./clean.sh`.
- `name or token does not match`: The info in blockchain/data/keyValStore does not match with the connected memberservice. `./clean.sh`.
- `Can't connect to docker daemon.`: `sudo usermod -aG docker $(whoami)`, logout and login again.
- `Error: /usr/src/app/node_modules/grpc/src/node/extension_binary/grpc_node.node: invalid ELF header`: The node_modules of the server were built outside of the container. Delete this directory and make a change in `server/package.json`. Then do `docker-compose build server`.

HFC:

- `handshake failed`: is there a `certificate.pem` in the `blockchain/src/build-chaincode` dir?
- NPM modules not found: `docker-compose build`

## Running on Azure
  [![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Foscarkoe%2Fhyperledger-on-azure%2Fv2-typescript%2Fazure%2Fazuredeploy.json)
