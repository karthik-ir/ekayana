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

module.exports = async function(deployer) {
  await deployer.deploy(Ownable);
  await deployer.link(Ownable, [EthMeetDB,EthMeetSetter, Killable]);
  await deployer.deploy(Killable);
  await deployer.link(Killable, Authentication);
  await deployer.deploy(Authentication);

  await deployer.deploy(SharedLibrary);

  await deployer.deploy(BookingLibrary);
  await deployer.deploy(UserLibrary);
  await deployer.deploy(ListingLibrary);
  await deployer.deploy(EthMeetSetter);
  await deployer.link(EthMeetSetter, [EthMeetUser,EthMeetListing, EthMeetBooking]);

  await deployer.deploy(EthMeetDB);
  await deployer.deploy([
    [EthMeetUser, EthMeetDB.address],
    [EthMeetListing, EthMeetDB.address],
    [EthMeetBooking, EthMeetDB.address]
  ]);
};
