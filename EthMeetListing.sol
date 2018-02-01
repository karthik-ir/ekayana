pragma solidity ^0.4.18;

import "./EthMeetSetter.sol";
import "./ListingLibrary.sol";

contract EthMeetListing  is EthMeetSetter {
    using strings for *;
    
    function EthMeetListing(address _ethMeetDB) public {
        if(_ethMeetDB == 0x0) throw;
        ethMeetDB = _ethMeetDB;
    }
    
    function addNewListing(string _title, uint256 _cost) public {
        var listingID = ListingLibrary.setListing(ethMeetDB,msg.sender,0,_title,_cost);

    } 

    function getListingCount() returns(uint) {
        return ListingLibrary.getListingCount(ethMeetDB);
    }

    function getListingIds() returns(uint[]){
        return ListingLibrary.getListingIds(ethMeetDB);
    }

    function getCost( uint listingId) returns(uint){
        return ListingLibrary.getCost(ethMeetDB,listingId);
    }
}