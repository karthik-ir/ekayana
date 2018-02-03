pragma solidity ^0.4.19;

import "./mortal.sol";

contract EthMeetWallet is Mortal {
    
    function ethMeetWallet() {
    }

    function receiveFunds() payable {
        //require(msg.sender == sender);
    }

    function sendFunds(address receiver, uint amount) payable {
        receiver.transfer(amount);
    }
}