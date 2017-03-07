import { Template } from 'meteor/templating';
import { ReactiveVar } from 'meteor/reactive-var';

import './main.html';

// Template.hello.onCreated(function helloOnCreated() {
//   // counter starts at 0
//   this.counter = new ReactiveVar(0);
// });
//
// Template.hello.helpers({
//   counter() {
//     return Template.instance().counter.get();
//   },
// });
//
// Template.hello.events({
//   'click button'(event, instance) {
//     // increment the counter when button is clicked
//     instance.counter.set(instance.counter.get() + 1);
//   },
// });
var stakeholderLength;

Template.init.rendered = function() {
    if(!this._rendered) {
      this._rendered = true;
      console.log('Template render complete');
      var height = window.innerHeight
        || document.documentElement.clientHeight
        || document.body.clientHeight;
      $(window).scroll(function(){
          if (window.pageYOffset >= height){
              $(".indexHeader").addClass("fixed");
          }else{
              $(".indexHeader").removeClass("fixed");
          }

      });
    }
}

var hex2a = function(hexx) {
    var hex = hexx.toString();//force conversion
    var str = '';
    for (var i = 0; i < hex.length; i += 2)
        str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
    return str;
}

if (Meteor.isClient) {
  Template.manage.helpers({

    stakeholders: function(){
      var stakeholdersData = [];
      var stakeholderLength = CongressInstance.getStakeholdersLength.call({from:web3.eth.accounts[0]}).c[0];
      console.log(stakeholderLength)
      for (var i = 0 ; i < stakeholderLength; i++){
        var data = CongressInstance.getStakeholder.call(i, {from:web3.eth.accounts[0]});
        //console.log(data);
        stakeholdersData.push({
          "name": hex2a(data[0]),
          "threshold": data[1],
          "fund": data[2],
          "rate" :data[3],
          "address" :data[4],
          "since" : data[5],
          "character": hex2a(data[6])
        });
        console.log(data);

      }
      return stakeholdersData;

    }
  });


  Template.index.events({
    'click #arrow-down': function (e) {
        e.preventDefault();
        var height = window.innerHeight
          || document.documentElement.clientHeight
          || document.body.clientHeight;
          scrollDuration = 1000;
        $(window).scrollTo(height, scrollDuration);
    },
    'click .chooseCharacters':function (event, instance){
        document.getElementById("seller").setAttribute("class", "btn btn-default");
        document.getElementById("buyer").setAttribute("class", "btn btn-default");
        event.target.className = "btn btn-info";
        character = event.target.value;
    },
    'click #previous': function (event){
        event.preventDefault();
        var temp = document.getElementById("flipper");
        temp.className = " flipper";
    },
    'click #submit': function (event){
        event.preventDefault();
        var name = $(".p_Name").val();
        var count = parseInt($(".p_Count").val());
        var accessStakeholders = $(".p_AccessStakeholders").val();
        var unit = $(".p_Unit").val();
        var atomicUnit = parseInt($(".p_AtomicUnit").val());
        var data = $(".p_Data").val();
        var rating = parseInt($(".p_Rating").val());
        console.log(name, count, accessStakeholders, unit, atomicUnit, data, rating);

        var txs = usingPropertyInstance.addProperty(name, count, [web3.eth.accounts[0]], unit, atomicUnit, data, rating, {from:web3.eth.accounts[1], gas:800000});
        console.log(txs);

    },
    'click #next': function (event){
        event.preventDefault();
        var name = $(".s_Name").val();
        var threshold = parseInt($(".s_Threshold").val());
        var fund = parseInt($(".s_Fund").val());
        var rate = parseInt($(".s_Rate").val());


        console.log(name, threshold, fund, rate, character);

        var txs = CongressInstance.addMember(name, threshold, fund, rate, character, {from:web3.eth.accounts[1], gas:221468});
        console.log(txs);

        document.getElementById("buyerInfo").style.display = "inline";
        document.getElementById("sellerInfo").style.display = "inline";

        if (character == "seller"){
            document.getElementById("buyerInfo").style.display = "none";
        }else{
            document.getElementById("sellerInfo").style.display = "none";
        }

        var temp = document.getElementById("flipper");
        temp.className += " flipperClicked";

    },
    'click #test': function (event){
        console.log(CongressInstance.getStakeholdersLength.call({from:web3.eth.accounts[0]}));


    },

  });
}
