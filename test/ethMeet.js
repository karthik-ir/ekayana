
var EthMeetListing = artifacts.require("./EthMeetListing.sol");
var EthMeetBooking = artifacts.require('./EthMeetBooking.sol');

contract("EthMeetBooking", function(accounts){
    it("..should create a listing and book it",function(){
        return EthMeetListing.deployed().then(function(instance){
            listingInstance = instance;
            return listingInstance.addNewListing("list1","22000000000000000000", {from: accounts[0]});
        }).then(function(){
            return listingInstance.getListingCount.call();
        }).then(function(result){
            assert.equal(result.valueOf(),1,"listing was not added");
        })
    });

    it("...Test booking and cancellation", function(){
        return EthMeetBooking.deployed().then(function(instance){
            bookingInstance = instance;
            
            acc0 = web3.eth.getBalance(accounts[0]).toNumber();
            acc1 = web3.eth.getBalance(accounts[1]).toNumber();
            return bookingInstance.addBooking(1,{from: accounts[0],value:22000000000000000000});
            }).then(function(){
                return bookingInstance.getWallet.call(1);
            }).then(function(result){
                assert.notEqual(result,"0x0","no wallet");
                assert.equal(web3.eth.getBalance(result).toNumber(), 22000000000000000000)
                acc0AfterBooking = web3.eth.getBalance(accounts[0]).toNumber();
                assert.ok(acc0AfterBooking < (acc0-22000000000000000000));
                return result;
            }).then(function(){
                return bookingInstance.addBooking(1,{from: accounts[1],value:22000000000000000000});
            }).then(function(){
                return bookingInstance.getWallet.call(1);
            }).then(function(result){
                assert.notEqual(result,"0x0","no wallet");
                assert.equal(web3.eth.getBalance(result).toNumber(), 22000000000000000000)
                return result;
            }).then(function(){
                return bookingInstance.cancelBooking(1,{from: accounts[0]});
            }).then(function(){
                return bookingInstance.getWallet.call(1);
            }).then(function(result){
                acc0AfterAcancellation = web3.eth.getBalance(accounts[0]).toNumber();
                assert.equal(web3.eth.getBalance(result).toNumber(), 0)
                assert.ok(acc0AfterAcancellation >= (acc0-1000000000000000000));
            })
        })
    });