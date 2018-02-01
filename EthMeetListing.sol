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
    
    function getListingDetails() public view returns(string,uint256,uint256,address[]){
        return(title,cost,listingDatetime,bookings);
    }
}