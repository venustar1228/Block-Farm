pragma solidity ^0.4.4;
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
        int256[] crop;
        int256[] land;

    }

    struct LandType{
        uint id;
        bytes32 name;
        bytes32 img;
        uint count;
    }

    mapping (uint => UserLandConfiguration) userLandConfigurationList;

    LandType[] public landTypeList;

    PropertyType[] public propertyTypeList;

    mapping (uint => UserPropertyType) userPropertyTypeList;

    struct Property{
        bytes32 name;
        uint id;
        uint since;
        uint propertyCount;
        uint256 minUnit; //可拆分最小單位
        address owner;
        bytes32 extraData;
        uint propertyType;
        uint tradeable; //可被交易的數量
        bool isTrading;
    }

    Property[] public propertyList;

    struct CropList{
        uint[] id;
        bytes32[] name;
        bytes32[] img;
        bytes32[] start;
        bytes32[] end;
        uint[] cropType;
        bool[] ripe;
        uint[] count;
    }

    mapping (uint => CropList) cropList;

    address CongressAddress;
    Congress congress;
    address owner;

    uint[] _id;
    bytes32[] _name;
    uint[] _propertyType;
    uint[] _count;
    uint[] _tradable;
    bytes32[] _img;

    function usingProperty(address _congressAddress){
        CongressAddress = _congressAddress;
        congress = Congress(CongressAddress);
        owner = msg.sender;
    }

    /*  ----------------------------------
        |                                |
        |       utility functions        |
        |                                |
        ----------------------------------  */

    function getCongressAddr() constant returns(address){
        return CongressAddress;
    }

    function getStakeholdersLength() constant returns(uint){
        return congress.getStakeholdersLength();
    }

    /*  ----------------------------------
        |                                |
        |            property            |
        |                                |
        ----------------------------------  */

    function initUserProperty(uint p_Id){
        uint _id = propertyList.length++;
        Property prop = propertyList[_id];
        PropertyType pt = propertyTypeList[p_Id];

        prop.name = pt.name;
        prop.id= _id;
        prop.propertyCount= 0;
        prop.since= now;
        prop.minUnit= 0;
        prop.owner= msg.sender;
        prop.extraData= "";
        prop.propertyType = pt.id;
        prop.tradeable = 0;
    }


    function getAllProperty() constant returns(uint[], uint[], bytes32[], uint[], uint[], bytes32[]){
        uint length = propertyList.length;

        for(uint i = 0; i < length; i++){
            if(propertyList[i].owner == msg.sender){
                _id.push(i);
                _name.push(propertyTypeList[propertyList[i].propertyType].name);
                _propertyType.push(propertyList[i].propertyType);
                _count.push(propertyList[i].propertyCount);
                _tradable.push(propertyList[i].tradeable);
                _img.push(propertyTypeList[propertyList[i].propertyType].img[3]);
            }
            else{
                continue;
            }
        }
        return (_id, _propertyType, _name, _count, _tradable, _img);
    }     

    function addProperty(bytes32 _name, uint _propertyCount, uint256 _minUnit, bytes32 _extraData, uint _type, uint _tradeable) returns(uint _id){
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

        Property prop = propertyList[_id];

        prop.name = _name;
        prop.id= _id;
        prop.propertyCount= _propertyCount;
        prop.since= now;
        prop.minUnit= _minUnit;
        prop.owner= msg.sender;
        prop.extraData= _extraData;
        prop.propertyType = _type;
        prop.tradeable = _tradeable;
        prop.isTrading = false;
    }

    function getPropertyByOwner(uint p_Id) constant returns (uint, bytes32, uint, uint256, bytes32, uint, uint){
        if(propertyList[p_Id].owner == msg.sender){
            return (propertyList[p_Id].id, propertyList[p_Id].name, propertyList[p_Id].propertyCount, propertyList[p_Id].minUnit, propertyList[p_Id].extraData, propertyList[p_Id].propertyType, propertyList[p_Id].tradeable);
        }else{
            throw;
        }
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

    function getProperty(uint p_Id) constant returns(bytes32, uint, uint, uint256, address, bytes32){
        return (propertyList[p_Id].name, propertyList[p_Id].since, propertyList[p_Id].propertyCount, propertyList[p_Id].minUnit, propertyList[p_Id].owner, propertyList[p_Id].extraData);
    }

    function getProperty_Shop(uint p_Id) constant returns(uint, bytes32, address, uint, uint, bytes32){
        return (propertyList[p_Id].propertyType, propertyTypeList[propertyList[p_Id].propertyType].name, propertyList[p_Id].owner, propertyList[p_Id].propertyCount, propertyList[p_Id].tradeable, propertyTypeList[propertyList[p_Id].propertyType].img[3]);
    }

    function getProperty_MissionSubmit(uint p_Id) constant returns(uint, address, uint){
        return (propertyList[p_Id].propertyType, propertyList[p_Id].owner, propertyList[p_Id].propertyCount);
    }


    function getPartialProperty(uint p_Id) constant returns(address){
        return (propertyList[p_Id].owner);
    }

    function getPropertyRatingLength(uint p_Id) constant returns(uint){
        propertyRatinglength_testing(propertyTypeList[p_Id].rating.length);
        return propertyTypeList[p_Id].rating.length;
    }

    function getPropertyCount(uint _id) constant returns(uint){
        return propertyList[_id].propertyCount;
    }

    function updatePropertyCount_Sudo(uint _id, uint _propertyCount, uint _tradeable){

        propertyList[_id].propertyCount = _propertyCount;
        propertyList[_id].tradeable = _tradeable;

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

    function updatePropertyCount_Cropped(uint _id, uint _croppedCount){
        if(propertyList[_id].owner == msg.sender){
            uint currentCount = propertyList[_id].propertyCount;
            propertyList[_id].propertyCount = currentCount + _croppedCount;
        }
        else{
            // throw;
        }
    }

    function updatePropertyCount_MissionSubmit(uint _id, uint _propertyCount){
        propertyList[_id].propertyCount = _propertyCount;
    }

    // for match making

    function getPropertyTypeRating_Matchmaking(uint p_Id, uint s_Id) constant returns(uint){
        return propertyTypeList[propertyList[p_Id].propertyType].rating[s_Id];
    }

    function getPropertyTypeAverageRating(uint p_Id, uint s_Id) constant returns(uint){
        return propertyTypeList[propertyList[p_Id].propertyType].averageRating;
    }

    function checkTradeable(uint p_Id) constant returns(uint){
        return propertyList[p_Id].tradeable;
    }

    function updateTradingStatus(uint p_Id, bool isTrading){
        propertyList[p_Id].isTrading = isTrading;
    }

    function checkTradingStatus(uint p_Id) constant returns (bool){
        return propertyList[p_Id].isTrading;
    }

    function getPropertyType_Matchmaking(uint p_Id) constant returns(uint){
        return propertyList[p_Id].propertyType;
    }

    function updateOwnershipStatus(uint receivedPID, uint currentPID){
        uint receivedCount = getPropertyCount(receivedPID);
        uint currentCount = getPropertyCount(currentPID);

        uint currentTradeable = checkTradeable(currentPID);
        uint receivedTradeable = checkTradeable(receivedPID);

        updatePropertyCount_Sudo(receivedPID, receivedCount + currentTradeable, receivedTradeable);
        updatePropertyCount_Sudo(currentPID, currentCount, 0);

    }

    function getPropertiesOwner(uint visitedProperty) constant returns(uint){

         uint visitedOwner;
         address owner = getPartialProperty(visitedProperty);
         visitedOwner = congress.stakeholderId(owner);
         return visitedOwner;

    }


    /*  ----------------------------------
        |                                |
        |       user property type       |
        |                                |
        ----------------------------------  */

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

    /*  ----------------------------------
        |                                |
        |            Crop List           |
        |                                |
        ----------------------------------  */

    function addCropList(uint u_Id, bytes32 _name, bytes32 _img, bytes32 _start, bytes32 _end, uint _cropType, bool _ripe, uint _count){
        uint _id = cropList[u_Id].id.length++;
        cropList[u_Id].id[_id] = _id;
        cropList[u_Id].name.push(_name);
        cropList[u_Id].img.push(_img);
        cropList[u_Id].start.push(_start);
        cropList[u_Id].end.push(_end);
        cropList[u_Id].cropType.push(_cropType);
        cropList[u_Id].ripe.push(_ripe);
        cropList[u_Id].count.push(_count);

    }

    function updateCropList(uint u_Id, uint p_Id, bytes32 _name, bytes32 _img, bytes32 _start, bytes32 _end, uint _cropType, bool _ripe, uint _count){

        cropList[u_Id].name[p_Id] = _name;
        cropList[u_Id].img[p_Id] = _img;
        cropList[u_Id].start[p_Id] = _start;
        cropList[u_Id].end[p_Id] = _end;
        cropList[u_Id].cropType[p_Id] = _cropType;
        cropList[u_Id].ripe[p_Id] = _ripe;
        cropList[u_Id].count[p_Id] = _count;
    }
    //for thief
    function updateCropCount(uint u_Id, uint p_Id, uint _count){
        cropList[u_Id].count[p_Id] = _count;
    }

    function getCropList(uint u_Id) constant returns( uint[], bytes32[], bytes32[], bytes32[], bytes32[], uint[], bool[]){
        return (cropList[u_Id].id, cropList[u_Id].name, cropList[u_Id].img, cropList[u_Id].start, cropList[u_Id].end, cropList[u_Id].cropType, cropList[u_Id].ripe);
    }

    function getCropListCount(uint u_Id) constant returns(uint[]){
        return cropList[u_Id].count;
    }

    function getCropListLength(uint u_Id) constant returns(uint){
        return cropList[u_Id].id.length;
    }



    /*  ----------------------------------
        |                                |
        |       land configuration       |
        |                                |
        ----------------------------------  */

    function addUserLandConfiguration(uint u_Id){
        uint _id = userLandConfigurationList[u_Id].id.length++;
        userLandConfigurationList[u_Id].id.push(_id);
        userLandConfigurationList[u_Id].land.push(-1);
        userLandConfigurationList[u_Id].crop.push(-1);

    }

    function updateUserLandConfiguration(uint u_Id, uint c_Id, int256 cropId, int256 landId, string operation){
        if (StringUtils.equal(operation,"land")){
            userLandConfigurationList[u_Id].land[c_Id] = landId;

        }else if (StringUtils.equal(operation,"crop")){
            userLandConfigurationList[u_Id].crop[c_Id] = cropId;
        }
    }

    function getUserLandConfiguration(uint u_Id) constant returns(int256[], int256[]){
        return (userLandConfigurationList[u_Id].land, userLandConfigurationList[u_Id].crop);

    }

    function moveUserLandPosition(uint u_Id, uint oldId, uint newId){
        userLandConfigurationList[u_Id].land[newId] = userLandConfigurationList[u_Id].land[oldId];
        userLandConfigurationList[u_Id].crop[newId] = userLandConfigurationList[u_Id].crop[oldId];
        userLandConfigurationList[u_Id].land[oldId] = -1;
        userLandConfigurationList[u_Id].crop[oldId] = -1;
    }

    /*  ----------------------------------
        |                                |
        |            land type           |
        |                                |
        ----------------------------------  */

    function addLandType(bytes32 _name, bytes32 _img, uint _count){

        uint _id = landTypeList.length++;

        LandType land = landTypeList[_id];
        land.name = _name;
        land.id= _id;
        land.img = _img;
        land.count = _count;
    }

    function getLandType(uint l_Id) constant returns(bytes32, uint, bytes32, uint){
        return(landTypeList[l_Id].name, landTypeList[l_Id].id, landTypeList[l_Id].img, landTypeList[l_Id].count);
    }


    /*  ----------------------------------
        |                                |
        |       property type            |
        |                                |
        ----------------------------------  */

    function updatePropertyTypeRating(uint _id, uint rate, string operation){
        updatedPropertiesCalled();
        if (StringUtils.equal(operation,"update")){

            uint length = congress.getStakeholdersLength();

            length = length-1; // ignore founder rating

            uint s_Id = congress.stakeholderId(msg.sender);

            propertyTypeList[_id].rating[s_Id] = rate;

            propertyTypeList[_id].averageRating = ((propertyTypeList[_id].averageRating * (length-1))+rate)/length;

        }else if (StringUtils.equal(operation,"new")){

            for (uint j = 0 ; j < _id ; j++){
                propertyTypeList[j].rating.push(0);
            }
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

        uint imgLength = _img.length;
        for (uint i = 0 ; i < imgLength ; i++){
            propertyTypeList[_id].img.push(_img[i]);
        }

        prop.time = _time;
        prop.harvestUnit = _harvestUnit;
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
