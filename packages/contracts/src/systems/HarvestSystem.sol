// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
// ...
import { GameConfig, GameConfigData } from "../codegen/tables/GameConfig.sol";
import { CarriedBy } from "../codegen/tables/CarriedBy.sol";
// ...
import { LibCore } from "../libraries/LibCore.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibGoal } from "../libraries/LibGoal.sol";
import { LibUtils } from "../libraries/LibUtils.sol";
// ...
import { GoalKey } from "../utils/constants.sol";

contract HarvestSystem is System {
  function harvest() public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());

    GameConfigData memory gameConfig = GameConfig.get();

    require(LibCore.isSpawned(coreEntity), "HarvestSystem: entity does not exist");
    require(LibCore.isReady(coreEntity), "HarvestSystem: entity is in cooldown");
    require(!LibCore.isCommitted(coreEntity), "HarvestSystem: entity is committed");
    require(LibCore.checkEnergy(coreEntity, gameConfig.harvestCost), "HarvestSystem: not enough energy");

    bytes32 baseEntity = CarriedBy.get(coreEntity);

    // 1. Check if goal item exists and is carried by the entity
    require(LibInventory.isCarriedBy(GoalKey, baseEntity), "HarvestSystem: goal item not carried");

    // 2. Calculate points to give (block.number - goal value )
    // 3. Get all cores in the baseEntity
    // 4. Divide points to give by number of cores
    bytes32[] memory cores = LibCore.getCoresByBaseEntity(baseEntity);
    uint256 pointsPerCore = LibGoal.getPoints() / cores.length;

    // 5. Give points to each core
    for (uint256 i = 0; i < cores.length; i++) {
      LibCore.increasePoint(cores[i], pointsPerCore);
    }

    // 6. Set goal value to current block number
    LibGoal.setGoalValue(block.number);

    LibCore.decreaseEnergy(coreEntity, gameConfig.harvestCost);
  }
}
