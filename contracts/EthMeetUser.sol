pragma solidity ^0.4.8;

import "./EthMeetSetter.sol";
import "./UserLibrary.sol";

contract EthMeetUser is EthMeetSetter {
    
    function EthMeetUser(address _ethMeetDB) public {
        if(_ethMeetDB == 0x0) throw;
        ethMeetDB = _ethMeetDB;
    }
    
    function setUser(string name, string email) public {
        UserLibrary.setUser(ethMeetDB, msg.sender, name, email);
    }

    function getUsers() public view returns(address[]) {
        return UserLibrary.getAllUsers(ethMeetDB);
    }
    

    function getUsersCount() public view returns(uint) {
        return UserLibrary.getAllUsers(ethMeetDB).length;
    }

    function getAppliedBookings() public view returns(uint[]) {
        return UserLibrary.getAttendeeContracts(ethMeetDB, msg.sender);
    }

    function getReceivedBookings() public view returns(uint[]) {
        return UserLibrary.getHostContracts(ethMeetDB, msg.sender);
    }
}