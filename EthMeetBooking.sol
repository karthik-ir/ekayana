pragma solidity ^0.4.19;

import "./EthMeetSetter.sol";
import "./BookingLibrary.sol";

contract EthMeetBooking is EthMeetSetter {

    function EthMeetBooking(address _ethMeetDB) {
        if(_ethMeetDB == 0x0) throw;
        ethMeetDB = _ethMeetDB;
    }

    function addBooking(uint listingId) returns(uint) {
        return BookingLibrary.book(ethMeetDB, listingId, msg.sender);
    }

}