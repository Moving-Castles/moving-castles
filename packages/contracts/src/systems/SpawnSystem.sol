// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
// ...
import { GameConfig, GameConfigData } from "../codegen/tables/GameConfig.sol";
import { Position, PositionData } from "../codegen/tables/Position.sol";
import { Core } from "../codegen/tables/Core.sol";
import { Portable } from "../codegen/tables/Portable.sol";
import { Matter } from "../codegen/tables/Matter.sol";
import { CarryingCapacity } from "../codegen/tables/CarryingCapacity.sol";
import { AbilityMove, AbilityMoveTableId } from "../codegen/tables/AbilityMove.sol";
import { AbilityConsume, AbilityConsumeTableId } from "../codegen/tables/AbilityConsume.sol";
import { Loot } from "../codegen/tables/Loot.sol";
// ...
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibAbility } from "../libraries/LibAbility.sol";
import { LibUtils } from "../libraries/LibUtils.sol";
import { LibLoot } from "../libraries/LibLoot.sol";

contract SpawnSystem is System {
  function spawn() public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());

    require(!LibCore.isSpawned(coreEntity), "SpawnSystem: ID already exists");

    GameConfigData memory gameConfig = GameConfig.get();

    LibCore.spawn(coreEntity);

    // Place the core in the inventory of a new base entity
    bytes32 baseEntity = LibUtils.getRandomKey();
    CarryingCapacity.set(baseEntity, gameConfig.defaultCarryingCapacity);
    LibInventory.addToInventory(baseEntity, coreEntity);

    // Find valid spawn position
    PositionData memory spawnPosition = LibMap.getSpawnPosition();
    Position.set(baseEntity, spawnPosition);

    // Place move organ in inventory
    bytes32 moveOrgan = LibUtils.getRandomKey();
    Portable.set(moveOrgan, true);
    Matter.set(moveOrgan, gameConfig.organMatter);
    AbilityMove.set(moveOrgan, true);
    LibInventory.addToInventory(baseEntity, moveOrgan);

    // Place consume organ in inventory
    bytes32 consumeOrgan = LibUtils.getRandomKey();
    Portable.set(consumeOrgan, true);
    Matter.set(consumeOrgan, gameConfig.organMatter);
    AbilityConsume.set(moveOrgan, true);
    LibInventory.addToInventory(baseEntity, consumeOrgan);

    // Place loot box in inventory
    bytes32 lootBox = LibUtils.getRandomKey();
    Portable.set(lootBox, true);
    Loot.set(lootBox, 2);
    LibInventory.addToInventory(baseEntity, lootBox);
  }
}
