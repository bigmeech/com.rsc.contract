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
    
    // pays a member based on implemented scheme rules
    function pay() onlyMember public payable;
    
    // deposit/contribute funds to the scheme
    function contribute () public onlyMember payable;
    
    // checks if an address is a memeber of the scheme;
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
    
    // contributions
    Contribution[] contributions;
    
    uint contributionAmount;
    uint contributionCount = 0;
    uint currentContributionRound = 0;
    uint maxMemberSize = 15;

    address initiator;

    event LogNewMemberAdded(address member, uint amountContributed);
    event LogContributionMade(address madeBy, uint amountContributed);
    event LogMemberRemoved(address member);
    event LogNewRoscaContractCreated(address initiator, uint memberCount);

    // maintain balance of all participants in this contribution
    mapping (address => uint256) balances;
    
    struct Contribution {
        uint contributionId;
        address contrbutor;
        uint dateOfContribution;
    }

    /**
        this contract is automatically created from the main contract
     */
    function RotationScheme (uint _maxMemberSize, uint _contributionAmount) public {
        // set maximum size on creation
        maxMemberSize = _maxMemberSize;

        // set contribution state as recruiting by default
        currentContributiontPhase = ContributionPhase.RECRUITING;

        // contrib
        contributionAmount = _contributionAmount;

        // set foreperson/initiator as owner of contract
        initiator = msg.sender;
    }
    
    /**
        returns owner/initiator of the contract
    */
    function getInitiator () public view returns (address) {
        return initiator;
    }
    
    /**
        for functions required only on recruitment phase
        e.g. join or remove
    */
    modifier onlyOnRecruit {
        if (currentContributiontPhase != ContributionPhase.RECRUITING) {
            revert();
        }
        _;
    }

    /**
        checks if sent funds is a valid contribution based on the set rules of the scheme
    */
    modifier isValidContribution {
        require(msg.value == contributionAmount);
        _;
    }

    // implement joining this scheme. One can only join when contract is on recruitement pphace
    function join() public onlyOnRecruit isValidContribution payable {
        balances[msg.sender] += msg.value;
        Contribution memory contribution = Contribution(++contributionCount, msg.sender, block.timestamp);
        contributions.push(contribution);
    }

    // address to send previously deposited funds to if any
    function leave () public onlyOnRecruit () {
        
    }
    
    function contribute() public payable {
        
    }
    
    function isMemberAddress(address toCheck) private view returns (bool) {
        if(balances[toCheck] != 0) {
            return false;
        }
        return true;
    }
    
    function pay() public payable {
        
    }
}

contract Main {
    // all contracts
    uint schemeCounter = 0;
    mapping (uint => address) schemes;
    
    // supported schemes
    enum SchemeTypes { ROSCA, ASCA, ASCA_LOAN }
    
    event LogNewContractCreated(address initiator, uint contractId);
    
    modifier isInitiator(bool isContractInitiator) {
        require(!isContractInitiator);
        _;
    }
    // creates a new scheme
    function createNewScheme (uint schemeType, uint memberSize, uint amountPerContribution) private returns (Scheme) {
        if (schemeType == uint(SchemeTypes.ROSCA)) {
            return new RotationScheme(memberSize, amountPerContribution);
        }
    }
    
    // 
    function startScheme(uint schemeType, uint size, uint contributionAmount) public {
        uint schemeId = ++schemeCounter;
        schemes[++schemeCounter] = createNewScheme(schemeType, size, contributionAmount);
        LogNewContractCreated(msg.sender, schemeId);
    }
    
    // terminate contract
    // contracts can only be terminated when they in the RECRUITING 
    // phase of which funds will be returned to existing participants.
    // only initiators can terminate the contract
    function destroyScheme(uint _schemeId) public isInitiator(msg.sender == initiator) view {
        RotationScheme contractScheme = RotationScheme(schemes[_schemeId]);
        address initiator = RotationScheme(contractScheme).getInitiator();
    }
}