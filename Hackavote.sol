// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

contract HackavoteProjects {
    struct Project {
        address author;
        address donationAddress;
        string submissionInfoSlug;
        string socialMediaUrl;
    }

    address private admin;
    Project[] public projects;
    uint256 public deadline;

    event ProjectSubmitted(address indexed author);
    event SubmissionInfoSlugChanged(
        uint256 indexed index,
        string newSubmissionInfoSlug
    );
    event ProjectTransferred(
        uint256 indexed projectId,
        address from,
        address to
    );
    event DonationAddressChanged(
        uint256 indexed projectId,
        address newDonationAddress
    );
    event SocialMediaUrlChanged(
        uint256 indexed projectId,
        string newSocialMediaUrl
    );

    constructor(uint256 _deadline) {
        admin = msg.sender;
        deadline = _deadline;
    }

    function submitProject(
        string memory _submissionInfoSlug,
        address _donationAddress,
        string memory _socialMediaUrl
    ) external beforeDeadline {
        projects.push(
            Project(
                msg.sender,
                _donationAddress,
                _submissionInfoSlug,
                _socialMediaUrl
            )
        );
        emit ProjectSubmitted(msg.sender);
    }

    modifier onlyAuthor(uint256 _index) {
        require(msg.sender == projects[_index].author, "Not authorized");
        _;
    }

    modifier beforeDeadline() {
        require(block.timestamp < deadline, "Deadline has passed");
        _;
    }

    function changeSubmissionInfoSlug(
        uint256 _index,
        string memory _newSubmissionInfoSlug
    ) external onlyAuthor(_index) beforeDeadline {
        projects[_index].submissionInfoSlug = _newSubmissionInfoSlug;
        emit SubmissionInfoSlugChanged(_index, _newSubmissionInfoSlug);
    }

    function changeDonationAddress(
        uint256 _projectId,
        address _newDonationAddress
    ) external onlyAuthor(_projectId) {
        projects[_projectId].donationAddress = _newDonationAddress;
        emit DonationAddressChanged(_projectId, _newDonationAddress);
    }

    function changeSocialMediaUrl(
        uint256 _projectId,
        string memory _newSocialMediaUrl
    ) external onlyAuthor(_projectId) {
        projects[_projectId].socialMediaUrl = _newSocialMediaUrl;
        emit SocialMediaUrlChanged(_projectId, _newSocialMediaUrl);
    }

    function transferProject(uint256 _projectId, address _newAuthor)
    external
    onlyAuthor(_projectId)
    {
        emit ProjectTransferred(
            _projectId,
            projects[_projectId].author,
            _newAuthor
        );
        projects[_projectId].author = _newAuthor;
    }

    function getProjectsLength() external view returns (uint256) {
        return projects.length;
    }
}
