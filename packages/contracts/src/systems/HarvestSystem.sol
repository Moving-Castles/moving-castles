// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibCore } from "../libraries/LibCore.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibConfig } from "../libraries/LibConfig.sol";
import { LibGoal } from "../libraries/LibGoal.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";

uint256 constant ID = uint256(keccak256("system.Harvest"));

contract HarvestSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint256 coreEntity = addressToEntity(msg.sender);

    GameConfig memory gameConfig = LibConfig.getGameConfig(components);

    require(LibCore.isSpawned(components, coreEntity), "HarvestSystem: entity does not exist");
    require(LibCore.isReady(components, coreEntity), "HarvestSystem: entity is in cooldown");
    require(!LibCore.isCommitted(components, coreEntity), "HarvestSystem: entity is committed");
    require(LibCore.checkEnergy(components, coreEntity, gameConfig.harvestCost), "HarvestSystem: not enough energy");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);
    uint256 goalEntity = LibGoal.getGoalEntity(components);

    // 1. Check if goal item exists and is carried by the entity
    require(
      goalEntity != 0 && LibInventory.isCarriedBy(components, goalEntity, baseEntity),
      "HarvestSystem: goal item not carried"
    );

    // 2. Calculate points to give (block.number - goal value )
    // 3. Get all cores in the baseEntity
    // 4. Divide points to give by number of cores
    uint256[] memory cores = LibCore.getCoresByBaseEntity(components, baseEntity);
    uint256 pointsPerCore = LibGoal.getPoints(components) / cores.length;

    // 5. Give points to each core
    for (uint256 i = 0; i < cores.length; i++) {
      LibCore.increasePoint(components, cores[i], pointsPerCore);
    }

    // 6. Set goal value to current block number
    LibGoal.setGoalValue(components, block.number);

    LibCore.decreaseEnergy(components, coreEntity, gameConfig.harvestCost);
  }

  function executeTyped() public returns (bytes memory) {
    return execute(abi.encode());
  }
}
