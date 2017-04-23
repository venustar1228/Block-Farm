pragma solidity ^0.4.8;
import "./StringUtils.sol";

contract Congress{

    mapping (address => uint) public stakeholderId;

    function addProperty(uint _id, uint p_Id);
    function getStakeholdersLength() constant returns(uint);

    function getStakeholder(uint s_Id) constant returns(bytes32, uint256, uint256, uint, address, uint, bytes32);

    function getPropertyId(uint s_Id, uint index) constant returns(uint);

    function getStakeholderPropertyCount(uint s_Id) constant returns(uint);

}

contract usingProperty{

    event propertyAdded(bytes32);
    event propertyTypeAdded(bool);

    event propertyUpdated(uint);
    event updatedPropertiesCalled();
    event propertyNewed(uint);
    event propertyInited(uint);
    event propertyRatinglength_testing(uint);


    struct PropertyType{
        bytes32 name;
        uint id;
        uint[] rating;
        uint averageRating;
        bytes32[] img;
        bytes32 time;
        uint harvestUnit;
    }

    struct UserPropertyType{
        uint[] id;
        uint[] count;
    }

    struct UserLandConfiguration{
        uint[] id;
        uint[] crop;
        uint[] land;

    }

    mapping (uint => UserLandConfiguration) userLandConfigurationList;


    PropertyType[] public propertyTypeList;

    mapping (uint => UserPropertyType) userPropertyTypeList;

    struct Property{
        bytes32 name;
        uint id;
        uint since;
        uint256 propertyCount;
        uint256 minUnit; //可拆分最小單位
        address owner;
        bytes32 extraData;
        uint propertyType;
        uint tradeable; //可被交易的數量
    }

    Property[] public propertyList;

    address CongressAddress;
    Congress congress;
  /*
    // seller property
    struct TicketInfo{
        uint date;
        bytes32 location;
        uint cost;
        bytes32 seat;
        address seller;
    }

    mapping (string => string[]) Tickets;  //using singer name to search for his concert list
  */


    function usingProperty(address _congressAddress){
        CongressAddress = _congressAddress;
        congress = Congress(CongressAddress);
    }

    function getCongressAddr() constant returns(address){
        return CongressAddress;
    }

    function getStakeholdersLength() constant returns(uint){
        return congress.getStakeholdersLength();
    }

    function addProperty(bytes32 _name, uint256 _propertyCount, uint256 _minUnit, bytes32 _extraData, uint _rating, uint _type, uint _tradeable) returns(uint _id){

        bool flag = true;
        for (uint w = 0 ; w < propertyTypeList.length ; w++){
            if (_type == propertyTypeList[w].id){
                flag = false;
                break;
            }
        }
        if (flag){
            propertyAdded("Property Type Not Found");
        }


        _id = propertyList.length++;

        uint s_Id = congress.stakeholderId(msg.sender);
        congress.addProperty(s_Id, _id);

      //  Stakeholder[] s_List = temp.stakeholders;

        Property prop = propertyList[_id];


        //uint length = congress.getStakeholdersLength();
        //for (uint j = 0 ; j < length ; j++){
        //    updatePropertiesRating(_id, 0, "init");
        //}

        prop.name = _name;
        prop.id= _id;
        prop.propertyCount= _propertyCount;
        prop.since= now;
        prop.minUnit= _minUnit;
        prop.owner= msg.sender;
        prop.extraData= _extraData;
        prop.propertyType = _type;
        prop.tradeable = _tradeable;



        propertyAdded("Success");
    }

    function removeProperty(uint _id){
        if (getPropertiesLength() == 0) throw;

        for (uint i = 0; i<propertyList.length; i++){
            propertyList[i] = propertyList[i+1];
        }
        delete propertyList[propertyList.length-1];
        propertyList.length--;

    }

    function getPropertiesLength() constant returns(uint){
        return propertyList.length;
    }

    function getProperty(uint p_Id) constant returns(bytes32, uint, uint256, uint256, address, bytes32){
        return (propertyList[p_Id].name, propertyList[p_Id].since, propertyList[p_Id].propertyCount, propertyList[p_Id].minUnit, propertyList[p_Id].owner, propertyList[p_Id].extraData);
    }

    function getProperty_Shop(uint p_Id) constant returns(uint, bytes32, address, uint256, uint){
        return (propertyList[p_Id].propertyType, propertyTypeList[propertyList[p_Id].propertyType].name, propertyList[p_Id].owner, propertyList[p_Id].propertyCount, propertyList[p_Id].tradeable);
    }

    function getPartialProperty(uint p_Id) constant returns(address){
        return (propertyList[p_Id].owner);
    }

    function getPropertyRating(uint p_Id, uint s_Id) constant returns(uint){
        return propertyTypeList[propertyList[p_Id].propertyType].rating[s_Id];
    }

    function getPropertyRatingLength(uint p_Id) constant returns(uint){
        propertyRatinglength_testing(propertyTypeList[p_Id].rating.length);
        return propertyTypeList[p_Id].rating.length;
    }

    function addUserPropertyType(uint u_Id, uint p_Id){
        userPropertyTypeList[u_Id].id.push(p_Id);
        userPropertyTypeList[u_Id].count.push(0);

    }

    function updateUserPropertyType(uint u_Id, uint level){
        userPropertyTypeList[u_Id].count[level]++;

    }

    function getUserPropertyType(uint u_Id) constant returns(uint[], uint[]){
        return (userPropertyTypeList[u_Id].id, userPropertyTypeList[u_Id].count);

    }


    function addUserLandConfiguration(uint u_Id){
        uint _id = userLandConfigurationList[u_Id].id.length++;
        userLandConfigurationList[u_Id].id.push(_id);
        //userLandConfigurationList[u_Id].land.push(0);
        //userLandConfigurationList[u_Id].crop.push(0);

    }

    function updateUserLandConfiguration(uint u_Id, uint c_Id, uint cropId, uint landId){
        userLandConfigurationList[u_Id].land[c_Id] = landId;
        userLandConfigurationList[u_Id].crop[c_Id] = cropId;
    }

    function getUserLandConfiguration(uint u_Id) constant returns(uint[], uint[]){
        return (userLandConfigurationList[u_Id].land, userLandConfigurationList[u_Id].crop);

    }

    //function updatePropertiesRating(uint _id, uint rate, string operation){
    //    updatedPropertiesCalled();
    //    if (StringUtils.equal(operation,"init")){      //consider import string.utils contract ?
    //        propertyInited(_id);
    //        propertyList[_id].rating.push(0);
    //    }else if (StringUtils.equal(operation,"update")){
    //        propertyUpdated(_id);

    //        uint length = congress.getStakeholdersLength();

    //        length = length-1; // ignore founder rating

    //        uint s_Id = congress.stakeholderId(msg.sender);
    //        //propertyList的id需要調整
    //        for(uint i = 0; i < propertyList.length; i++){
    //            if(_id == propertyList[i].propertyType){
    //                propertyList[i].rating[s_Id] = rate;
    //                propertyList[i].averageRating = ((propertyList[i].averageRating * (length-1))+rate)/length;
    //            }
    //        }

    //        propertyTypeList[_id].rating[s_Id] = rate;
    //        propertyTypeList[_id].averageRating = ((propertyTypeList[_id].averageRating * (length-1))+rate)/length;

    //    }else if (StringUtils.equal(operation,"new")){
    //        propertyNewed(_id);

    //        for (uint j = 0 ; j < _id ; j++){
    //            propertyList[j].rating.push(0);
    //        }
    //    }
    //}

    function updatePropertyTypeRating(uint _id, uint rate, string operation){
        updatedPropertiesCalled();
        if (StringUtils.equal(operation,"update")){

            uint length = congress.getStakeholdersLength();

            length = length-1; // ignore founder rating

            uint s_Id = congress.stakeholderId(msg.sender);

            propertyTypeList[_id].rating[s_Id] = rate;
            propertyTypeList[_id].averageRating = ((propertyTypeList[_id].averageRating * (length-1))+rate)/length;

            //for (uint i = 0 ; i < propertyList.length; i++){
            //    if (propertyList[i].propertyType == _id){
            //        propertyList[i].averageRating = propertyTypeList[_id].averageRating;
            //    }
            //}

        }else if (StringUtils.equal(operation,"new")){

            for (uint j = 0 ; j < _id ; j++){
                propertyTypeList[j].rating.push(0);
            }
        }
    }

    function updatePropertyCount(uint _id, uint _propertyCount, uint _tradeable){

        if(propertyList[_id].owner == msg.sender){
            propertyList[_id].propertyCount = _propertyCount;
            propertyList[_id].tradeable = _tradeable;
        }
        else{
            throw;
        }
    }



    function addPropertyType(bytes32 _name, bytes32[] _img, bytes32 _time, uint _harvestUnit){


        uint _id = propertyTypeList.length++;

        uint length = congress.getStakeholdersLength();
        for (uint j = 0 ; j < length ; j++){
            propertyTypeList[_id].rating.push(0);
        }

        PropertyType prop = propertyTypeList[_id];

        prop.name = _name;
        prop.id= _id;


        prop.averageRating = 0;
        prop.img.push("_seed");
        prop.img.push("_grow");
        prop.img.push("_harvest");
        prop.img.push("");
        prop.time = _time;

        uint imgLength = _img.length;
        for (uint i = 0 ; i < imgLength ; i++){
            propertyTypeList[_id].img.push(_img[i]);
        }


        prop.time = _time;
        prop.harvestUnit = _harvestUnit;

        //propertyTypeAdded(true);

    }

    function getPropertyType(uint p_id, uint u_id) constant returns(bytes32, uint, uint, uint){
        return(propertyTypeList[p_id].name, propertyTypeList[p_id].id, propertyTypeList[p_id].harvestUnit, propertyTypeList[p_id].averageRating);
    }


    function getPropertyType(uint p_Id) constant returns(bytes32, uint, uint, bytes32, uint){
        return(propertyTypeList[p_Id].name, propertyTypeList[p_Id].id, propertyTypeList[p_Id].averageRating, propertyTypeList[p_Id].time, propertyTypeList[p_Id].harvestUnit);
    }

    function getPropertyTypeId(uint p_Id) constant returns(uint){
        return propertyTypeList[p_Id].id;
    }

    function getPropertyTypeImg(uint p_Id, uint img_Id) constant returns(bytes32){
        return propertyTypeList[p_Id].img[img_Id];
    }

    function getPropertyType_forMission(uint p_id, uint cropStage) constant returns(bytes32, uint, bytes32){
        return(propertyTypeList[p_id].name, propertyTypeList[p_id].id, propertyTypeList[p_id].img[cropStage]);
    }

    function getPropertyTypeRating(uint p_id) constant returns(uint){
        uint s_Id = congress.stakeholderId(msg.sender);
        return propertyTypeList[p_id].rating[s_Id];
    }

    function getPropertyTypeLength() constant returns(uint){
        return propertyTypeList.length;
    }

}
