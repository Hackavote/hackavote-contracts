// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

contract Hackavote {
    mapping(address => bytes[]) private opinions;
    address[] public hackers;

    function submitOpinion(bytes memory opinion) public {
        if (opinions[msg.sender].length == 0) {
            hackers.push(msg.sender);
        }
        opinions[msg.sender].push(opinion);
    }

    function getOpinionOfHackerAtIndex(address hackerAddress, uint256 index)
    public
    view
    returns (bytes memory)
    {
        require(index < opinions[hackerAddress].length, "Index out of bounds.");
        return opinions[hackerAddress][index];
    }

    function getOpinionCountOfHacker(address hackerAddress)
    public
    view
    returns (uint256)
    {
        return opinions[hackerAddress].length;
    }

    function getHackerCount() public view returns (uint256) {
        return hackers.length;
    }
}
