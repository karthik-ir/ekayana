pragma solidity ^0.4.19;

import "./Mortal.sol";

contract EthMeetWallet is Mortal {
    
    function EthMeetWallet() {
    }

    function receiveFunds() payable {
        //require(msg.sender == sender);
    }

    function sendFunds(address receiver, uint amount) payable {
        receiver.transfer(amount);
    }
}