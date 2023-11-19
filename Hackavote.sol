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

    function getOpinionsOfHacker(address hackerAddress) public view returns (bytes[] memory) {
        return opinions[hackerAddress];
    }

    function getOpinionCountOfHacker(address hackerAddress) public view returns (uint) {
        return opinions[hackerAddress].length;
    }

    function getHackerCount() public view returns (uint) {
        return hackers.length;
    }
}
