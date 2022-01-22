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

        $('#create-kitty-btn').click(function(evt){
            console.log('CLICK');
            var dnaStr = getDna();
            console.log(dnaStr);
            instance.methods.createKittyGen0(dnaStr).send({}, function(error, txHash){
                if(error){
                    console.log(error);
                } else {
                    instance.events.Birth({}, function(error, event){ 
                        console.log(event);
                        console.log(event.returnValues);
                        $('#kittenOwner').text(event.returnValues.owner)
                        $('#kittenId').text(event.returnValues.kittenId)
                        $('#kittnMumId').text(event.returnValues.mumId)
                        $('#kittenDadId').text(event.returnValues.dadId)
                        $('#kittenGenes').text(event.returnValues.genes)

                        $('#exampleModal').modal('show'); 
                    })
                    console.log(txHash);
                }
            })
        })

        // use this as your base for creating a kitty on the blockchain

    })
})