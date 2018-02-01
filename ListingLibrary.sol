pragma solidity ^0.4.19;

import "./EthMeetDB.sol";
import "./sharedLibrary.sol";
import "./UserLibrary.sol";

library ListingLibrary {
    function setListing(address db,
    address senderId,
    uint existingListingId,
    string title,
    uint256 cost) internal returns (uint listingId) {

        if (existingListingId > 0) {
            //var currentListingStatus = getStatus(db, existingListingId);
            listingId = existingListingId;
        } else {
            listingId = SharedLibrary.createNext(db, "listing/count");
        }

        EthMeetDB(db).setAddressValue(sha3("listing/host", listingId), senderId);
        EthMeetDB(db).setUIntValue(sha3("listing/cost", listingId), cost);
        EthMeetDB(db).setStringValue(sha3("listing/title", listingId), title);

         if (existingListingId > 0) {
            EthMeetDB(db).setUIntValue(sha3("listing/updated-on", listingId), now);
        } else {
            EthMeetDB(db).setUIntValue(sha3("listing/created-on", listingId), now);
            UserLibrary.addUserListing(db, senderId, listingId);
        }

         setStatus(db, listingId, 1);
         return listingId;
    }

    function getStatus(address db, uint listingId) internal returns(uint8) {
        return EthMeetDB(db).getUInt8Value(sha3("listing/status", listingId));
    }

    function setStatus(address db, uint listingId, uint8 status) internal {
        EthMeetDB(db).setUInt8Value(sha3("listing/status", listingId), status);
    }
    
        function getListingCount(address db) internal returns(uint) {
        return EthMeetDB(db).getUIntValue(sha3("listing/count"));
    }
} 