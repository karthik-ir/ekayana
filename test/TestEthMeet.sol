pragma solidity ^0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EthMeetUser.sol";
import "../contracts/EthMeetDB.sol";
import "../contracts/EthMeetListing.sol";

contract TestEthMeet {
    event receivedAddress(address addr);
    event receivedName(bytes32 name);
    function testUserCreation() {
        EthMeetUser userContract = EthMeetUser(DeployedAddresses.EthMeetUser());
        receivedAddress(DeployedAddresses.EthMeetUser());

        Assert.equal(userContract.getUsersCount(), 0, "The name has to be same");
        userContract.setUser("testUser","testUserEmail");
        uint userCount = userContract.getUsersCount();
        uint expectedUserName = 1;
         Assert.equal(userCount, expectedUserName, "The name has to be same");
    }

    function testListingCreation() {
        EthMeetListing listingContract = EthMeetListing(DeployedAddresses.EthMeetListing());
        Assert.equal(listingContract.getListingCount(),0,"There are no listings so far");

        var listingID = listingContract.addNewListing("listing_title",22 ether);

        Assert.equal(listingContract.getListingCount(),1, "There is exactly one listing");

        Assert.equal(listingContract.getCost(listingID),22 ether, "Mapping the cost");
    }
}