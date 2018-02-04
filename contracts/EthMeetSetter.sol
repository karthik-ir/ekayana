pragma solidity ^0.4.19;

import "./Ownable.sol";
import "./UserLibrary.sol";

contract EthMeetSetter is Ownable {
    address public ethMeetDB;
    uint8 public smartContractStatus;
    event onSmartContractStatusSet(uint8 status);

    modifier onlyActiveSmartContract {
      if (smartContractStatus != 0) throw;
      _;
    }
    modifier onlyActiveUser {
      if (!UserLibrary.hasStatus(ethMeetDB, msg.sender, 1)) throw;
      _;
    }
 
    function setSmartContractStatus(
          uint8 _status
    )
      onlyOwner
    {
        smartContractStatus = _status;
        onSmartContractStatusSet(_status);
    }
}