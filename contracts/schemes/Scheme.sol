pragma solidity ^0.4.18;

contract Scheme {
    //group creator
    address owner;
    
    //list of members in the group
    address[] members;
    
    modifier onlyMember () {
        require(isMemberAddress(msg.sender));
        _;
    }
    
    // join the scheme by sending an initial ether
    function join() public payable;
    
    // leave the scheme
    function leave() public;
    
    //pays a member based on implemented scheme rules
    function pay() onlyMember public;
    
    // deposit/contribute funds to the scheme
    function contribute () public onlyMember payable;
    
    function isMemberAddress(address toCheck) private view returns (bool);
}