// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

contract HackavoteProjects {
    struct Project {
        address author;
        string metaDataUri;
    }

    address private admin;
    Project[] public projects;
    uint256 public deadline;

    constructor(uint256 _deadline) {
        admin = msg.sender;
        deadline = _deadline;
    }

    function submitProject(string memory _metaDataUri) external beforeDeadline {
        projects.push(Project(msg.sender, _metaDataUri));
    }

    modifier onlyAdminOrAuthor(uint256 _index) {
        require(
            msg.sender == admin || msg.sender == projects[_index].author,
            "Not authorized"
        );
        _;
    }

    modifier beforeDeadline() {
        require(block.timestamp < deadline, "Deadline has passed");
        _;
    }

    function changeMetaDataUri(uint256 _index, string memory _newMetaDataUri)
    external
    onlyAdminOrAuthor(_index)
    beforeDeadline
    {
        projects[_index].metaDataUri = _newMetaDataUri;
    }

    function getProjectsLength() external view returns (uint256) {
        return projects.length;
    }
}
