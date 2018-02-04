pragma solidity ^0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EthMeetUser.sol";
import "../contracts/EthMeetDB.sol";

contract TestEthMeetUser {
    function testUserCreation() {
        EthMeetUser userContract = EthMeetUser(DeployedAddresses.EthMeetUser());

        userContract.setUser("testUser","testUserEmail");

        bytes32 expectedUserName = "testUser";
        
         Assert.equal(
             EthMeetDB(DeployedAddresses.EthMeetDB()).getStringValueAsBytes32(sha3("user/name"
             , msg.sender)), expectedUserName, "The name has to be same");
    }
}