// Web3.givenProvider provides the network URL that is connected to MetaMask
var web3 = new Web3(Web3.givenProvider);

//contract instance
var instance;
var user;
var contractAddress = "0xF5fea29aF6C1edeAC53d11086eabc3881E24f245";

$(document).ready(function(){
    // need to prompt user to enable metamask
    window.ethereum.enable().then(function(accounts){
        
        // accounts is an array is almost always the first
        // item in the array
        user = accounts[0];

        // abi is a specification of what the contract does
        // application binary interface and we can check the build file for KittyContract.json to find abi
        // the last argument allows you to pass multiple arguments
        instance = new web3.eth.Contract(abi, contractAddress, {from: user})

        console.log(instance);

        // use this as your base for creating a kitty on the blockchain
        instance.methods.createKityGen0(dnaStr).send({}, function(error, txHash){
            if(error){
                console.log(error);
            } else {
                console.log(txHash);
            }
        })
    })
})