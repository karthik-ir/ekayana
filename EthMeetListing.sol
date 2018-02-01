pragma solidity ^0.4.18;

contract Listing {
    
    address owner;
    string title;
    uint256 cost;
    uint256 listingDatetime;
    address[] bookings;
    
    function Listing() public {
        owner = msg.sender;
    }
    
    function addNewListing(string _title, uint256 _cost, uint256 _listingDatetime) public {
        title = _title;
        cost = _cost;
        listingDatetime = _listingDatetime;
    } 
    
    function book(address _id) public {
        bookings.push(_id);
    }
    
    function getListingDetails() public view returns(string,uint256,uint256,address[]){
        return(title,cost,listingDatetime,bookings);
    }
}