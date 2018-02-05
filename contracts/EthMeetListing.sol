pragma solidity ^0.4.19;

import "./EthMeetSetter.sol";
import "./ListingLibrary.sol";

contract EthMeetListing  is EthMeetSetter {
    
    function EthMeetListing(address _ethMeetDB) public {
        if(_ethMeetDB == 0x0) throw;
        ethMeetDB = _ethMeetDB;
    }
    
    function addNewListing(string _title, uint256 _cost) public returns(uint listingID) {
        listingID = ListingLibrary.setListing(ethMeetDB,msg.sender,0,_title,_cost);
    } 

    function getBookings(uint listingId) public view returns(uint[]) {
        return ListingLibrary.getBookings(ethMeetDB, listingId);
    }

    function getListingCount() public view returns(uint) {
        return ListingLibrary.getListingCount(ethMeetDB);
    }

    function getListingIds() public view returns(uint[]){
        return ListingLibrary.getListingIds(ethMeetDB);
    }

    function getCost( uint listingId) public view returns(uint){
        return ListingLibrary.getCost(ethMeetDB,listingId);
    }
}