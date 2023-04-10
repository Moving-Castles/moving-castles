// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { Portable } from "../codegen/tables/Portable.sol";
import { CarriedBy, CarriedByTableId } from "../codegen/tables/CarriedBy.sol";
import { CarryingCapacity } from "../codegen/tables/CarryingCapacity.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";

library LibInventory {
  /**
   * Get a base entity's inventory
   *
   * @param _baseEntity holder of the inventory
   * @return inventory
   */
  function getInventory(bytes32 _baseEntity) internal view returns (bytes32[] memory inventory) {
    return getKeysWithValue(CarriedByTableId, CarriedBy.encode(_baseEntity));
  }

  /**
   * Get a base entity's inventory
   *
   * @param _baseEntity holder of the inventory
   * @return length length of inventory
   */
  function getInventorySize(bytes32 _baseEntity) internal view returns (uint256 length) {
    return getInventory(_baseEntity).length;
  }

  /**
   * Add an item to an inventory
   *
   * @param _entity holder of the inventory
   * @param _item item to add
   */
  function addToInventory(bytes32 _entity, bytes32 _item) internal {
    require(CarryingCapacity.get(_entity) > 0, "LibInventory: entity has no carrying capacity");
    require(Portable.get(_item), "LibInventory: item is not portable");
    require(getInventorySize(_entity) < CarryingCapacity.get(_entity), "LibInventory: inventory is full");
    CarriedBy.set(_item, _entity);
  }

  /**
   * Remove an item from an inventory
   *
   * @param _entity item to remove
   */
  function removeFromInventory(bytes32 _entity) internal {
    CarriedBy.deleteRecord(_entity);
  }

  /**
   * Set inventory size for entity
   *
   * @param _entity holder of the inventory
   * @param _size size of inventory
   */
  function setCarryingCapacity(bytes32 _entity, uint32 _size) internal {
    CarryingCapacity.set(_entity, _size);
  }

  /**
   * Remove carrying capacity
   *
   * @param _entity holder of the inventory
   */
  function removeCarryingCapacity(bytes32 _entity) internal {
    CarryingCapacity.deleteRecord(_entity);
  }

  /**
   * Check if entity is portable
   *
   * @param _entity entity to check
   * @return result is the entity portable?
   */
  function isPortable(bytes32 _entity) internal view returns (bool result) {
    return Portable.get(_entity);
  }

  /**
   * Check if one entity is carried by another
   *
   * @param _portableEntity Carried
   * @param _baseEntity Carrier
   * @return result is the entity carried by the base entity?
   */
  function isCarriedBy(bytes32 _portableEntity, bytes32 _baseEntity) internal view returns (bool result) {
    return CarriedBy.get(_portableEntity) == _baseEntity;
  }
}
