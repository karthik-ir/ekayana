import React, {Component} from 'react'
import EthMeetListing from '../../../build/contracts/EthMeetListing.json'
import EthMeetDB from '../../../build/contracts/EthMeetDB.json'


import getWeb3 from './getWeb3'

class ListingPage extends Component {

    componentWillMount() {
        // Get network provider and web3 instance.
        // See utils/getWeb3 for more info.

        getWeb3
            .then(results => {
                this.setState({
                    web3: results.web3
                })
                console.log("STARTING")
                // Instantiate contract once web3 provided.
                this.instantiateContract()
            })
            .catch(() => {
                console.log('Error finding web3.')
            })
    }
    instantiateContract(){
        const contract = require('truffle-contract')
        const sha3_512 = require('js-sha3').sha3_512;

        const ethMeetListing = contract(EthMeetListing)
        const ethMeetDB = contract(EthMeetDB);
        ethMeetListing.setProvider(this.state.web3.currentProvider)
        ethMeetDB.setProvider(this.state.web3.currentProvider)

        var listingContract;
        // Get current ethereum wallet.
        this.state.web3.eth.getCoinbase((error, coinbase) => {
            // Log errors, if any.
            if (error) {
                console.error(error);
            }

            ethMeetListing.deployed().then(function (instance) {
                listingContract = instance;
                console.log(coinbase)
                listingContract.addNewListing("list1", 22000000000000000000, {from: coinbase})
                    .then(function (result) {
                        console.log(result + " added")
                        listingContract.addNewListing("list2", "25000000000000000000", {from: coinbase})
                            .then(function (result) {
                                console.log(result + " added")
                                ethMeetDB.deployed().then(function (ethDB) {

                                    listingContract.getListingIds({from: coinbase})
                                        .then(function (result) {
                                            result.forEach(function (item) {
                                                var h = sha3_512.update("listing/title").update(item).hex();
                                                ethDB.getStringValue(h).then(function(result){
                                                    console.log(result+"is added");
                                                })
                                            })
                                        })
                                })
                            })
                    })



            })
        });

    }


    render() {
        return (
            <div>
                "Some text value"
            </div>
        )
    }
}

export default ListingPage