// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { Position, PositionData } from "../codegen/tables/Position.sol";
import { Matter } from "../codegen/tables/Matter.sol";
import { Portable } from "../codegen/tables/Portable.sol";

library LibConsumable {
  /**
   * Convert substance block to energy
   *
   * @param _consumableEntity entity
   * @param _abilityCount number of items giving the consume ability
   * @return result
   */
  function convertToEnergy(bytes32 _consumableEntity, uint32 _abilityCount) internal view returns (uint32 result) {
    uint32 energy = Matter.get(_consumableEntity);
    // Give more energy if entity has more than one consume organs
    return energy * (2 * _abilityCount);
  }
}
