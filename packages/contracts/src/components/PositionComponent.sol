// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import "std-contracts/components/CoordComponent.sol";

uint256 constant ID = uint256(keccak256("component.Position"));

contract PositionComponent is CoordComponent {
  constructor(address world) CoordComponent(world, ID) {}
}
