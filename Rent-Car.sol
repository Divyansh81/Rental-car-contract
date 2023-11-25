// SPDX-License-Identifier: GPL-3.0
pragma solidity^0.8.2;

contract Rent  {

 address public owner;
    uint256 public fee = 1 ether;
    
    struct RentDetails {
        address user;
        string carDetails;
  
  
    }
    
    mapping(uint256 => RentDetails) public rentedCars;
    mapping(address => bool) public rentedUsers;
    
    constructor() {
        owner = msg.sender;
    }
    
    function rentCar(string memory _carDetails) public payable {
        require(msg.value >= 2 ether, "Please pay the correct rental fee to rent a car.");
        require(!rentedUsers[msg.sender], "You have already rented a car.");
        
        uint256 carId = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));
        rentedCars[carId] = RentDetails(msg.sender, _carDetails);
        rentedUsers[msg.sender] = true;
    }
    
    function returnCar(uint256 _carId) public {
        require(msg.sender == owner, "Only the owner can return a rented car.");
        require(rentedCars[_carId].user != address(0), "The rented car was not found.");
        
        address user = rentedCars[_carId].user;
        uint256 refundAmount = fee * 75 / 100;
        
        delete rentedCars[_carId];
        rentedUsers[user] = false;
        
        payable(user).transfer(refundAmount);
    }

}
 