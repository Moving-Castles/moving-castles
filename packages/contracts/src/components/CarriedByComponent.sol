// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import "std-contracts/components/Uint256Component.sol";

uint256 constant ID = uint256(keccak256("component.CarriedBy"));

contract CarriedByComponent is Uint256Component {
  constructor(address world) Uint256Component(world, ID) {}
}
