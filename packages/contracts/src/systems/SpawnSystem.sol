// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibConfig } from "../libraries/LibConfig.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibMove } from "../libraries/LibMove.sol";
import { LibMap } from "../libraries/LibMove.sol";
import { LibAbility } from "../libraries/LibAbility.sol";
import { LibUtils } from "../libraries/LibUtils.sol";
import { LibLoot } from "../libraries/LibLoot.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";
import { Coord } from "../components/PositionComponent.sol";

import { ID as AbilityMoveComponentID } from "../components/AbilityMoveComponent.sol";
import { ID as AbilityConsumeComponentID } from "../components/AbilityConsumeComponent.sol";

uint256 constant ID = uint256(keccak256("system.Spawn"));

contract SpawnSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint256 coreEntity = addressToEntity(msg.sender);

    require(!LibCore.isSpawned(components, coreEntity), "SpawnSystem: ID already exists");

    GameConfig memory gameConfig = LibConfig.getGameConfig(components);

    LibCore.spawn(components, coreEntity);

    // Place the core in the inventory of a new base entity
    uint256 baseEntity = world.getUniqueEntityId();
    LibInventory.setCarryingCapacity(components, baseEntity, gameConfig.defaultCarryingCapacity);
    LibInventory.addToInventory(components, baseEntity, coreEntity);

    // Place three loot boxes in inventory
    for (uint256 i = 0; i < 3; i++) {
      uint256 lootBox = world.getUniqueEntityId();
      LibInventory.makePortable(components, lootBox);
      LibLoot.makeLoot(components, lootBox);
      LibInventory.addToInventory(components, baseEntity, lootBox);
    }

    // Find valid spawn position
    Coord memory spawnPosition = LibMap.getSpawnPosition(components);
    LibMove.setPosition(components, baseEntity, spawnPosition);
  }

  function executeTyped() public returns (bytes memory) {
    return execute(abi.encode());
  }
}
