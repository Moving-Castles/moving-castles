// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.17;

bytes32 constant GoalKey = bytes32(uint256(0x60A1));

enum Activity {
  Idle,
  Play
}

enum LootBoxType {
  Initial,
  Normal
}
