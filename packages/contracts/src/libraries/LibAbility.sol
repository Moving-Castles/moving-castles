// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { console } from "forge-std/console.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { Ability } from "../codegen/tables/Ability.sol";

library LibAbility {
  /**
   * Check entity for ability
   *
   * @param _entity Entity
   * @param _tableId Ability table ID
   * @return result
   */
  function checkEntityForAbility(uint256 _tableId, bytes32 _entity) internal view returns (bool result) {
    return Ability.get(_tableId, _entity);
  }

  /**
   * Get the number of entities in inventory with the ability
   *
   * @param _baseEntity Base Entity
   * @param _tableId Ability table ID
   * @return result the number of entities in the inventory with this ability
   */
  function checkInventoryForAbility(uint256 _tableId, bytes32 _baseEntity) internal view returns (uint32 result) {
    bytes32[] memory inventory = LibInventory.getInventory(_baseEntity);
    uint32 count;
    uint256 inventoryLength = inventory.length;
    for (uint256 i; i < inventoryLength; ++i) {
      if (checkEntityForAbility(_tableId, inventory[i])) {
        unchecked {
          ++count;
        }
      }
    }
    return count;
  }
}
