pragma solidity ^0.4.19;

import "./EthMeetDB.sol";
import "./sharedLibrary.sol";
import "./UserLibrary.sol";
import "./ListingLibrary.sol";

library BookingLibrary {
        //    status:
    //    1: invited, 2: pending proposal, 3: accepted, 4: finished, 5: cancelled
    
    function book(address db, uint listingId, address sender) 
            internal returns (uint bookingId) 
    {
        var hostUserId = ListingLibrary.getHostUser(db,listingId);
        require(hostUserId != 0x0);
        require(ListingLibrary.getStatus(db, listingId) == 1);
        bookingId = getBooking(db,sender,listingId);
        if (bookingId == 0) {
            bookingId = SharedLibrary.createNext(db,"booking/count");
            UserLibrary.addAttendeeContract(db, sender,bookingId);
            UserLibrary.addHostContract(db,hostUserId,bookingId);
            ListingLibrary.addBooking(db,listingId,bookingId);
        } else if (getBookingCreatedOn(db, bookingId) != 0) throw;

        setUserBookingIndex(db, bookingId, sender, listingId);
        EthMeetDB(db).setUIntValue(sha3("booking/created-on",listingId),now);
        setStatus(db, bookingId, 2);
        return bookingId;
    }
    
    function cancel(address db, uint listingId, address sender) internal returns(uint bookingId) {
        bookingId = getBooking(db,sender,listingId);
        if (bookingId == 0) {
            throw;
        }
        setStatus(db, bookingId,5);

        return bookingId;
    }

    function setUserBookingIndex(address db, uint bookingId, address userId, uint listingId) internal {
        EthMeetDB(db).setAddressValue(sha3("booking/customer", bookingId), userId);
        EthMeetDB(db).setUIntValue(sha3("booking/listing", bookingId), listingId);
        EthMeetDB(db).setUIntValue(sha3("booking/customer+listing", userId, listingId), bookingId);
    }

    function setStatus(address db, uint bookingId, uint8 status) {
        EthMeetDB(db).setUInt8Value(sha3("booking/status",bookingId),status);
    }

    function getBooking(address db, address userId, uint listingId) internal returns(uint) {
        return EthMeetDB(db).getUIntValue(sha3("booking/customer+listing", userId, listingId));
    }

    function getBookingCreatedOn(address db, uint bookingId) internal returns(uint) {
        return EthMeetDB(db).getUIntValue(sha3("booking/created-on",bookingId));
    }
}