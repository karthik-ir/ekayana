pragma solidity ^0.4.19;

import "./EthMeetSetter.sol";
import "./BookingLibrary.sol";
import "./EthMeetWallet.sol";

contract EthMeetBooking is EthMeetSetter {

    function EthMeetBooking(address _ethMeetDB) {
        if(_ethMeetDB == 0x0 ) throw;
        ethMeetDB = _ethMeetDB;
    }

    function addBooking(uint listingId) public payable returns(uint bookingId) {
        bookingId =  BookingLibrary.book(ethMeetDB, listingId, msg.sender, msg.value);
        address wallet = BookingLibrary.getWallet(ethMeetDB,listingId,msg.sender);
        //Send money to the contract
        EthMeetWallet(wallet).receiveFunds.value(msg.value)();        
        return bookingId;
    }

    function cancelBooking(uint listingId) public returns(uint bookingId) {
        bookingId = BookingLibrary.cancel(ethMeetDB, listingId, msg.sender);
    }

    function getWallet(uint listingId) public view returns(address) {
        return BookingLibrary.getWallet(ethMeetDB, listingId, msg.sender);
    }

    function getWalletBalance(address walletID) public view returns(uint) {
        return walletID.balance;
    }
}