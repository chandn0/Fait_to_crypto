// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract p2p{
    address payable owner;
    event check(uint256 indexed _id);
    struct enter {
        address payable owner;
        uint256 low;
        uint256 high;
        uint256 deposite;
        uint256 price;
        bool active;
        uint256 id;
    }
   enter[] public ledger;
   
   constructor(){
   owner=payable(msg.sender);
   }

    function createOrder(uint256 low,uint256 high,bool active,uint256 price) public payable{
        enter memory enter1;
        enter1.owner=payable(msg.sender);
        enter1.low=low;
        enter1.high=high;
        enter1.price=price;
        enter1.deposite=msg.value;
        enter1.active=active;
        enter1.id=orders.length;
        ledger.push(enter1);
    }

    function updateOrder(uint256 low,uint256 high,bool active,uint256 price,uint256 id) public payable{
        require(orders[id].owner==msg.sender,"not owner");
        ledger[id].price=price;
        ledger[id].deposite+=msg.value;
        ledger[id].active=active;
        ledger[id].low=low;
        ledger[id].high=high;
    }

    function verfiy(uint256 orderid,bool sent) public{
        require(ledger[orders[orderid].enterid].owner==msg.sender,"you are not owner");
        if(sent == true){
            orders[orderid].respond=process.verfiyed;
        ledger[orders[orderid].enterid].deposite -=orders[orderid].amount;
        (orders[orderid].owner).transfer(orders[orderid].amount);
        }else{
        orders[orderid].respond=process.falserequest;
        orderstovalidate[orderid].push(orderid);
         emit check(orderid);
        }
    }

   struct order{
       uint256 enterid;
       uint256 amount;
       address payable owner;
       process  respond; 
       uint256 price;
       uint256 ordernumber;
   }

   order[] public orders;
   enum process{ tobereview, verfiyed,falserequest,  validatorsreview ,invalidrequest}

   function paided(uint256 amount,uint id) public{
       require(ledger.length>id,"not enter");
       require(ledger[id].active==true," not active");
       require(ledger[id].deposite>=amount," higher amount");
       require((amount>=ledger[id].low)&&(amount<=ledger[id].high),"not in range");
       require(orderstovalidate[id].length<=0,"can't pay now");
        order memory order1;
        order1.enterid=id;
        order1.amount=amount;
        order1.owner=payable(msg.sender);
        order1.respond=process.tobereview;
        order1.ordernumber= block.number;
        order1.price=ledger[id].price;
        orders.push(order1);
   }

   function requestverfiy(uint256 orderid) public{
       require(orders.length>orderid,"doesn't exist");
       require(30 >=( block.number - orders[orderid].ordernumber),"can't apply for verfication");
       require(orders[orderid].respond==process.falserequest ,"already verfiyed");
       orderstovalidate[orders[orderid].enterid].push(orderid);
       orders[orderid].respond=process.validatorsreview;
   }

   //Vallidaters

   mapping(uint256=>uint256[])public orderstovalidate;

  function Govern(uint256 orderid,bool sent) public{
      require(orderstovalidate[orders[orderid].enterid][0]==orderid,"not request");

        if(sent == true){
        orders[orderid].respond=process.verfiyed;
        ledger[orders[orderid].enterid].deposite -=orders[orderid].amount;
        (orders[orderid].owner).transfer(orders[orderid].amount);
        }else{
        orders[orderid].respond=process.invalidrequest;
        }
  }

}
