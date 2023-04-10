// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { GameConfig, GameConfigData } from "../codegen/tables/GameConfig.sol";
import { Core } from "../codegen/tables/Core.sol";
import { CreationBlock } from "../codegen/tables/CreationBlock.sol";
import { ReadyBlock } from "../codegen/tables/ReadyBlock.sol";
import { Energy } from "../codegen/tables/Energy.sol";
import { Portable } from "../codegen/tables/Portable.sol";
import { CarriedBy } from "../codegen/tables/CarriedBy.sol";
import { Commit } from "../codegen/tables/Commit.sol";
import { Point } from "../codegen/tables/Point.sol";
import { Commit } from "../codegen/tables/Commit.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { Activity } from "../utils/constants.sol";

library LibCore {
  /**
   * Spawn a Core
   *
   * @param _coreEntity Entity Id. Should be address of the owner/controller of the Core
   */
  function spawn(bytes32 _coreEntity) internal {
    GameConfigData memory gameConfig = GameConfig.get();
    Core.set(_coreEntity, true);
    CreationBlock.set(_coreEntity, block.number);
    ReadyBlock.set(_coreEntity, block.number);
    Energy.set(_coreEntity, gameConfig.initialEnergy);
    Point.set(_coreEntity, 0);
    Portable.set(_coreEntity, true);
  }

  /**
   * Checks if a core with this id exists
   *
   * @param _coreEntity core entity Id
   * @return bool does a core with this Id exist?
   */
  function isSpawned(bytes32 _coreEntity) internal view returns (bool) {
    return Core.get(_coreEntity);
  }

  /**
   * Set the ready block for entity
   *
   * @param _entity Entity
   * @param _period How many block to add
   */
  function setReadyBlock(bytes32 _entity, uint256 _period) internal {
    ReadyBlock.set(_entity, block.number + _period);
  }

  /**
   * Check if the entity's cooldown period is over
   *
   * @param _entity Entity
   * @return bool is the cooldown period over?
   */
  function isReady(bytes32 _entity) internal view returns (bool) {
    return ReadyBlock.get(_entity) >= block.number ? false : true;
  }

  /**
   * Check energy
   *
   * @param _coreEntity Core entity
   * @param _amount Amount to check against
   * @return bool False if the core does not have enough energy
   */
  function checkEnergy(bytes32 _coreEntity, uint32 _amount) internal view returns (bool) {
    uint32 currentEnergy = Energy.get(_coreEntity);
    if (currentEnergy < _amount) return false;
    return true;
  }

  /**
   * Decrease energy
   *
   * @param _coreEntity Core entity
   * @param _amount Amount to decrease by
   * @return bool False if the core does not have enough energy
   */
  function decreaseEnergy(bytes32 _coreEntity, uint32 _amount) internal returns (bool) {
    uint32 currentEnergy = Energy.get(_coreEntity);
    if (currentEnergy < _amount) return false;
    Energy.set(_coreEntity, currentEnergy - _amount);
    return true;
  }

  /**
   * Increase energy
   *
   * @param _coreEntity Core entity
   * @param _amount Amount to increase by
   */
  function increaseEnergy(bytes32 _coreEntity, uint32 _amount) internal {
    uint32 currentEnergy = Energy.get(_coreEntity);
    Energy.set(_coreEntity, currentEnergy + _amount);
  }

  /**
   * Commit to activity
   *
   * @param _coreEntity Core entity
   * @param _activity Activity
   */
  function commit(bytes32 _coreEntity, Activity _activity) internal {
    Commit.set(_coreEntity, uint32(_activity));
  }

  /**
   * Uncommit from activity
   *
   * @param _coreEntity Core entity
   */
  function uncommit(bytes32 _coreEntity) internal {
    Commit.deleteRecord(_coreEntity);
  }

  /**
   * Check if committed
   *
   * @param _coreEntity Core entity
   * @return bool is the core committed to something?
   */
  function isCommitted(bytes32 _coreEntity) internal view returns (bool) {
    return Commit.get(_coreEntity) > 0;
  }

  /**
   * Check point
   *
   * @param _coreEntity Core entity
   * @param _amount Amount to check against
   * @return bool False if the core does not have enough energy
   */
  function checkPoint(bytes32 _coreEntity, uint256 _amount) internal view returns (bool) {
    uint256 currentPoint = Point.get(_coreEntity);
    if (currentPoint < _amount) return false;
    return true;
  }

  /**
   * Decrease point
   *
   * @param _coreEntity Core entity
   * @param _amount Amount to decrease by
   * @return bool False if the core does not have enough energy
   */
  function decreasePoint(bytes32 _coreEntity, uint256 _amount) internal returns (bool) {
    uint256 currentPoint = Point.get(_coreEntity);
    if (currentPoint < _amount) return false;
    Point.set(_coreEntity, currentPoint - _amount);
    return true;
  }

  /**
   * Increase point
   *
   * @param _coreEntity Core entity
   * @param _amount Amount to increase by
   */
  function increasePoint(bytes32 _coreEntity, uint256 _amount) internal {
    uint256 currentPoint = Point.get(_coreEntity);
    Point.set(_coreEntity, currentPoint + _amount);
  }

  /**
   * Get cores by base entity
   *
   * @param _baseEntity base entity
   * @return array cores in inventory of base entity
   */
  function getCoresByBaseEntity(bytes32 _baseEntity) internal view returns (bytes32[] memory) {
    bytes32[] memory inventory = LibInventory.getInventory(_baseEntity);
    // !!! TODO
    return inventory;
  }
}
