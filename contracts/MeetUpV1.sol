pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";


/**
 * @title RefundVault
 * @dev This contract is used for storing funds while a crowdsale
 * is in progress. Supports refunding the money if crowdsale fails,
 * and forwarding it if crowdsale is successful.
 */
contract MeetUpV1 is Ownable {
  using SafeMath for uint256;
  enum State { BeforeMeetup, OnMeeting, OnRefunding, RefundingFinished, Closed }
  address host;
  uint capability;
  uint fee;
  uint deposited;
  uint password;
  State state;
  uint endDate;
  address[] attendees;
  address[] refundedAttendees;

  event OnMeeting();
  event Refunded(address host, uint fee);
  event RefundsEnabled();
  event RefundingFinished();
  event Closed();

  function MeetUpV1(address _host, uint _capability, uint _password, uint _endDate) {
    host = _host;
    capability = _capability;
    password = _password;
    endDate = endDate;
    state = State.BeforeMeetup;
    deposited = 0;
  }

  function deposit(address attendee) onlyOwner public payable {
    require(state == State.BeforeMeetup);
    if (msg.value == 0) throw;
    attendees.push(msg.sender);
  }

  function close() onlyOwner public {
    require(state != State.Closed);
    state = State.Closed;
    emit Closed();
  }

  function enableRefunds() onlyOwner public {
    require(state == State.OnMeeting);
    state = State.OnRefunding;
    emit RefundsEnabled();
  }

  function refund(address attendee) public {
    require(state == State.OnRefunding);
    deposited =  deposited - fee;
    attendee.transfer(fee);
    emit Refunded(attendee, fee);
  }
}
