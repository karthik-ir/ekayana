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
  deployFactory(deployer).then(function(){
    return;
  });
};

async function deployFactory(deployer){
  await deployer.deploy(Ownable);
  await deployer.link(Ownable, [EthMeetDB,EthMeetSetter, Killable]);
  await deployer.deploy(Killable);
  await deployer.link(Killable, Authentication);
  await deployer.deploy(Authentication);
  await deployer.deploy(SafeMath);
  await deployer.link(SafeMath,[SharedLibrary,EthMeetDB])
  await deployer.deploy(SharedLibrary);
  await deployer.link(SharedLibrary, [UserLibrary,ListingLibrary,BookingLibrary]);

  await deployer.deploy(EthMeetDB);
  await deployer.link(EthMeetDB,[UserLibrary,ListingLibrary,BookingLibrary]);

  await deployer.deploy(UserLibrary);

  await deployer.link(UserLibrary, [ListingLibrary,BookingLibrary, EthMeetSetter]);
  await deployer.deploy(ListingLibrary);

  await deployer.link(ListingLibrary, BookingLibrary);
  await deployer.deploy(BookingLibrary);
  
  await deployer.deploy(EthMeetSetter);
  await deployer.link(EthMeetSetter, [EthMeetUser,EthMeetListing, EthMeetBooking]);
  
  await deployer.link(UserLibrary,[EthMeetUser])
  await deployer.deploy(EthMeetUser, EthMeetDB.address);
  
  await deployer.link(ListingLibrary,[EthMeetListing])
  await deployer.deploy(EthMeetListing, EthMeetDB.address);

  await deployer.link(BookingLibrary,[EthMeetBooking])
  await deployer.deploy(EthMeetBooking, EthMeetDB.address);
}
