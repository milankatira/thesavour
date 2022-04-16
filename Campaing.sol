// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract campaingFactory {
    address[] public deployedCampaing;
    event CampaignCretated(
        string title,
        uint requiredAmount,
        address indexed owner,
        address campaingAddress,
        string imgURI,
        uint indexed timestamp,
        string indexed category
    );

    function createCampaing(
        string memory campaignTitle,
        uint requiredCampaignAmount,
        string memory imgURI,
        string memory category,
        string memory storyURL
    ) public {
        Campaign newCampaign = new Campaign(
            campaignTitle,
            requiredCampaignAmount,
            imgURI,
            storyURL
        );
        deployedCampaing.push(address(newCampaign));

        emit CampaignCretated(
            campaignTitle,
            requiredCampaignAmount,
            msg.sender,
            address(newCampaign),
            imgURI,
            block.timestamp,
            category
        );
    }
}

contract Campaign {
    string public title;
    uint public requiredAmount;
    string public image;
    string public story;
    address payable public owner;
    uint public receivedAmount;

    event donated(
        address indexed donar,
        uint indexed amount,
        uint indexed timestamp
    );

    constructor(
        string memory campaignTitle,
        uint requiredCampaignAmount,
        string memory imgURI,
        string memory storyURL
    ) {
        title = campaignTitle;
        requiredAmount = requiredCampaignAmount;
        image = imgURI;
        story = storyURL;
        owner = payable(msg.sender);
    }

    function donate() public payable {
        require(requiredAmount > receivedAmount, "require amount fullfilled");
        owner.transfer(msg.value);
        receivedAmount += msg.value;
        emit donated(msg.sender, msg.value, block.timestamp);
    }
}
