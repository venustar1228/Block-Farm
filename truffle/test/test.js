var Congress = artifacts.require("./Congress.sol");
var usingProperty = artifacts.require("./usingProperty.sol");
var MainActivity = artifacts.require("./MainActivity.sol");

var CongressAddr;

contract('Congress', function (accounts) {
    it("adding new member", function () {
        var congress;
       // var property;

        return Congress.deployed().then(function (instance) {
            return instance.addMember(0, 0, 100 { from: accounts[2] });

        }).then(function (txs) {
        });
    });

    it("bla", function(){
	return Congress.deployed().then(function (instance){
		return instance.initGameData("Bill", "Guard", {from:accounts[2]});
	});
	
   });

    it("check stakeholders length", function () {
        return Congress.deployed().then(function (instance) {
            return instance.getStakeholdersLength.call();
        });
    });

    it("add propertyType", function () {
        return usingProperty.deployed().then(function (instance) {
            return instance.addPropertyType("carrot", "piece", 1, {from:accounts[1]});
        });
    });

    it("updae Pikachu rating by john", function () {
        return usingProperty.deployed().then(function (instance) {
            return instance.updatePropertyTypeRating(0, 100, "update", { from: accounts[1] });
        }).then(function (txs) {
            console.log(txs);

        });
    });
});
