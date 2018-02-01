pragma solidity ^0.4.8;

import "./sharedLibrary.sol";
import "./strings.sol";
import "./EthMeetSetter.sol";
import "./UserLibrary.sol";

contract EthMeetUser is EthMeetSetter {
    using strings for *;
    
    function EthMeetUser(address _ethMeetDB) public {
        if(_ethMeetDB == 0x0) throw;
        ethMeetDB = _ethMeetDB;
    }
    
    function setUser(string name, string email) public {
        UserLibrary.setUser(ethMeetDB, msg.sender, name, email);
    }

    function getUsers() public view returns(address[]){
        return UserLibrary.getAllUsers(ethMeetDB);
    }
}