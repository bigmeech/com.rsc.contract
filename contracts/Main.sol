pragma solidity ^0.4.18;

/**
  Generic Scheme interface
 */
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

/**
    Members can only join or leave on recruitment Phase. 
    Once phase proceeds to ONGOING, you cant join or leave
    until all future rounds have ended.

 */
contract RotationScheme is Scheme {
    enum ContributionPhase { RECRUITING, ONGOING, ENDED }
    ContributionPhase currentContributiontPhase;

    uint contributionAmount;
    uint contributionCount = 0;
    uint currentContributionRound = 1;
    uint maxMemberSize = 15;

    address initiator;

    event LogNewMemberAdded(address member, uint amountContributed);
    event LogContributionMade(address madeBy, uint amountContributed);
    event LogMemberRemoved(address member);
    event LogNewRoscaContractCreated(address initiator, uint memberCount);

    // maintain balance of all participants in this contribution
    mapping (address => uint256) balances;

    /**
        this contract is automatically created from the main contract
     */
    function RotationScheme (address _initiator, uint _maxMemberSize, uint _contributionAmount) {
        // set maximum size on creation
        maxMemberSize = _maxMemberSize;

        // set contribution state as recruiting by default
        currentContributiontPhase = ContributionPhase.RECRUITING;

        // contrib
        contributionAmount = _contributionAmount;

        // set foreperson/initiator as owner of contract
        initiator = _initiator;
    }
    
    // for functions required only on recruitment phase
    // e.g. join or remove
    modifier onlyOnRecruit {
        if (currentContributiontPhase != ContributionPhase.RECRUITING) {
            revert();
        }
        _;
    }

    modifier isValidContribution {
        if (msg.value != contributionAmount) {
            revert();
        }
        _;
    }

    struct Contribution {
        uint contributionId;
        address contrbutor;
        uint dateOfContribution;
    }

    // contributions
    Contribution[] contributions;

    // implement joining this scheme. One can only join when contract is on recruitement pphace
    function join() public onlyOnRecruit isValidContribution payable {
        balances[msg.sender] += msg.value;
        Contribution memory contribution = Contribution(++contributionCount, msg.sender, now);
        contributions.push(contribution);
    }

    // address to send previously deposited funds to if any
    function leave (address leaverAddress) public onlyOnRecruit () {
        if(currennt)
    }
}

contract Main {
    // all contracts
    Scheme[] contracts;
    
    // supported schemes
    enum SchemeTypes { ROSCA, ASCA, ASCA_LOAN }
    
    // creates a new scheme
    function createNewScheme (uint schemeType) private returns (address) {
        if (schemeType == uint(SchemeTypes.ROSCA)) {
            return new RotationScheme(msg.value);
        }
    }
    
    // terminate contract
    function destroyScheme (address contractToDestroy) public {
        
    }
}
