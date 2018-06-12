pragma solidity ^0.4.23;

// import { Auction } from './Auction.sol';
import { MeetUpV1 } from "./MeetUpV1.sol";

contract MeetUpFactory {
    address[] public meetups;

    event MeetUpCreated(address meetupContract, address owner, uint numMeetUps, address[] allMeetups);

    function MeetUpFactory() {
    }

    function createMeetUp(address _host, uint _capability, uint _password, uint _endDate
    ) {
        MeetUpV1 newMeetUp = new MeetUpV1(_host, _capability, _password, _endDate);
        meetups.push(newMeetUp);

        MeetUpCreated(newMeetUp, msg.sender, meetups.length, meetups);
    }

    function allMeetups() constant returns (address[]) {
        return meetups;
    }
}