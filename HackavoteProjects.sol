// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

contract HackavoteProjects {
    struct Project {
        address author;
        string infoUri;
        string metaDataUri;
    }
    address private admin;
    Project[] public projects;
    uint256 public deadline;

    event ProjectSubmitted(address indexed author, string metaDataUri);
    event MetaDataUriChanged(uint256 indexed index, string newMetaDataUri);
    event InfoUriChanged(uint256 indexed index, string newInfoUri); // event for changeInfoUri

    constructor(uint256 _deadline) {
        admin = msg.sender;
        deadline = _deadline;
    }

    /// @notice allows users to submit a new project before the deadline
    function submitProject(string memory _infoUrl, string memory _metaDataUri)
    external
    beforeDeadline
    {
        projects.push(Project(msg.sender, _infoUrl, _metaDataUri));
        emit ProjectSubmitted(msg.sender, _metaDataUri);
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

    /// @notice allows the project author or the admin to change the metadata URI
    function changeMetaDataUri(uint256 _index, string memory _newMetaDataUri)
    external
    onlyAdminOrAuthor(_index)
    {
        projects[_index].metaDataUri = _newMetaDataUri;
        emit MetaDataUriChanged(_index, _newMetaDataUri);
    }

    /// @notice allows the project author or the admin to change the info URI
    function changeInfoUri(uint256 _index, string memory _newInfoUri)
    external
    onlyAdminOrAuthor(_index)
    beforeDeadline
    {
        projects[_index].infoUri = _newInfoUri;
        emit InfoUriChanged(_index, _newInfoUri); // emit event here
    }

    /// @notice returns the number of projects submitted
    function getProjectsLength() external view returns (uint256) {
        return projects.length;
    }
}
