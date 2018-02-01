pragma solidity ^0.4.19;

import "./EthMeetDB.sol";
import "./sharedLibrary.sol";

library UserLibrary {
    function setUser(address db,
        address userId,
        string name,
        string email) internal {
            
            if (!userExists(db, userId)) {
            EthMeetDB(db).setUIntValue(sha3("user/created-on", userId), now);
            EthMeetDB(db).setUInt8Value(sha3("user/status", userId), 1);
            SharedLibrary.addArrayItem(db, "user/ids", "user/count", userId);
        }


            EthMeetDB(db).setStringValue(sha3("user/name", userId), name);
        EthMeetDB(db).setStringValue(sha3("user/email", userId), email);
        
        }
        
         function userExists(address db, address userId) internal returns(bool) {
        return getStatus(db, userId) > 0;
    }
    
    function getStatus(address db, address userId) internal returns(uint8) {
        return EthMeetDB(db).getUInt8Value(sha3("user/status", userId));
    }

     function hasStatus(address db, address userId, uint8 status) internal returns(bool) {
        return status == EthMeetDB(db).getUInt8Value(sha3("user/status", userId));
    }
}