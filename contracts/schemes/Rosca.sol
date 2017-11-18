pragma solidity ^0.4.18;

import "./Scheme.sol";

contract RotationScheme is Scheme {
    address owner;
    address lastCollector;
    address nextCollector;

    string CONTRIBUTION_FREQUENCY = "1 week";

    address[] members;

    uint currentRound;
    uint maxContributorSize;

    mapping (address => uint256) balances;

    ContributionStages contributionStages;
    
    event LogMemberRemoved(string message);
    event LogMemberPaid(string message);
    event LogNewMemberAdded(string message);
    
    enum ContributionStages { RECRUITING, ONGOING, ENDED }
    
    modifier isValidCollector () {
        _;
    }
    
    // constructor
    function RotationScheme(uint noOfContributor, string frequency) {
        owner = msg.sender;
        contributionStages = ContributionStages.RECRUITING;
        maxContributorSize = noOfContributor;
    }
    
    // implements join. adds sender to members array and create a record for their start balance
    function join() public payable {
        members.push(msg.sender);
        balances[msg.sender] += msg.value;
    }
    
    //checks if sender is an existing member of the scheme
    function isMemberAddress (address addressToCheck) private view returns (bool) {
        for (uint i; i < members.length; i++) {
            if (members[i] != addressToCheck) {
                return true;
            }
        }
        return false;
    }
    
    // impliments contribute
    function contribute() public onlyMember payable {
        balances[msg.sender] += msg.value;
    }
    
    // implements leave
    function leave() public onlyMember {
        
    }
    
    function setContributionStage () {

    }

    function getCOntributionStage () {

    }
    
    // implements pay .i.e paying out funds to a contributor based on rules of the scheme
    function pay() public onlyMember {
        
    }
}
