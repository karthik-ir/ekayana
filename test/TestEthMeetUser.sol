pragma solidity ^0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EthMeetUser.sol";
import "../contracts/EthMeetDB.sol";

contract TestEthMeetUser {
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
}