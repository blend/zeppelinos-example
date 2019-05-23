// Based on: https://github.com/truffle-box/metacoin-box/blob/c3e9674e39ac5d404509464556915e812ce64084/contracts/MetaCoin.sol
// License: https://github.com/truffle-box/metacoin-box/blob/c3e9674e39ac5d404509464556915e812ce64084/LICENSE

pragma solidity ^0.5.0;

import "openzeppelin-eth/contracts/ownership/Ownable.sol";
import "zos-lib/contracts/Initializable.sol";

contract MetaCoin is Initializable, Ownable {
  uint public conversionRate;

  mapping (address => uint) balances;

  event Transfer(address indexed _from, address indexed _to, uint256 _value);

  function initialize(address sender) public initializer {
    Ownable.initialize(sender);
    balances[owner()] = 10000;
    conversionRate = 2;
  }

  function sendCoin(address receiver, uint amount) public returns (bool sufficient) {
    if (balances[msg.sender] < amount) return false;
    balances[msg.sender] -= amount;
    balances[receiver] += amount;
    emit Transfer(msg.sender, receiver, amount);
    return true;
  }

  function getBalanceInEth(address addr) public view returns (uint) {
    return getBalance(addr) * conversionRate;
  }

  function getBalance(address addr) public view returns (uint) {
    return balances[addr];
  }
}
