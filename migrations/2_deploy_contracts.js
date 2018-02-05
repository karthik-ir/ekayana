var Ownable = artifacts.require("./Ownable.sol");
var Killable = artifacts.require("./zeppelin/lifecycle/Killable.sol");
var Authentication = artifacts.require("./Authentication.sol");

var EthMeetDB = artifacts.require("./EthMeetDB.sol");
var EthMeetUser = artifacts.require("./EthMeetUser.sol");
var EthMeetListing = artifacts.require("./EthMeetListing.sol");
var EthMeetBooking = artifacts.require("./EthMeetBooking.sol");

var BookingLibrary = artifacts.require("./BookingLibrary.sol");
var ListingLibrary = artifacts.require("./ListingLibrary.sol");
var UserLibrary = artifacts.require("./UserLibrary.sol");
var SharedLibrary = artifacts.require("./SharedLibrary.sol");

var EthMeetSetter = artifacts.require("./EthMeetSetter.sol");

var Mortal = artifacts.require("./Mortal.sol");
var SafeMath = artifacts.require("./SafeMath");

module.exports = function(deployer) {
  deployFactory(deployer);
};

function deployFactory(deployer){
   deployer.deploy(Ownable);
   deployer.link(Ownable, [EthMeetDB,EthMeetSetter, Killable]);
   deployer.deploy(Killable);
   deployer.link(Killable, Authentication);
   deployer.deploy(Authentication);
   deployer.deploy(SafeMath);
   deployer.link(SafeMath,[SharedLibrary,EthMeetDB])
   deployer.deploy(SharedLibrary);
   deployer.link(SharedLibrary, [UserLibrary,ListingLibrary,BookingLibrary]);

   deployer.deploy(EthMeetDB);
   deployer.link(EthMeetDB,[UserLibrary,ListingLibrary,BookingLibrary]);

   deployer.deploy(UserLibrary);

   deployer.link(UserLibrary, [ListingLibrary,BookingLibrary, EthMeetSetter]);
   deployer.deploy(ListingLibrary);

   deployer.link(ListingLibrary, BookingLibrary);
   deployer.deploy(BookingLibrary);
  
   deployer.deploy(EthMeetSetter);
   deployer.link(EthMeetSetter, [EthMeetUser,EthMeetListing, EthMeetBooking]);
  
   deployer.link(UserLibrary,[EthMeetUser])
   deployer.deploy(EthMeetUser, EthMeetDB.address);
  
   deployer.link(ListingLibrary,[EthMeetListing])
   deployer.deploy(EthMeetListing, EthMeetDB.address);

   deployer.link(BookingLibrary,[EthMeetBooking])
   deployer.deploy(EthMeetBooking, EthMeetDB.address);
}
