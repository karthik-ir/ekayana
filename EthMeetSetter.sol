pragma solidity ^0.4.19;

import "ownable.sol";
import "userLibrary.sol";

contract EthlanceSetter is Ownable {
    address public ethlanceDB;
    uint8 public smartContractStatus;
    event onSmartContractStatusSet(uint8 status);

    modifier onlyActiveSmartContract {
      if (smartContractStatus != 0) throw;
      _;
    }
    modifier onlyActiveUser {
      if (!UserLibrary.hasStatus(ethlanceDB, msg.sender, 1)) throw;
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

    function getConfig(bytes32 key) constant returns(uint) {
        return EthlanceDB(ethlanceDB).getUIntValue(sha3("config/", key));
    }
}