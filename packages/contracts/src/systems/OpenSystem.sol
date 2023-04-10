// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
// ...
import { GameConfig, GameConfigData } from "../codegen/tables/GameConfig.sol";
import { CarriedBy } from "../codegen/tables/CarriedBy.sol";
import { Loot } from "../codegen/tables/Loot.sol";
// ...
import { LibCore } from "../libraries/LibCore.sol";
import { LibLoot } from "../libraries/LibLoot.sol";
import { LibUtils } from "../libraries/LibUtils.sol";

contract OpenSystem is System {
  function open(bytes32 _lootEntity) public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());

    GameConfigData memory gameConfig = GameConfig.get();

    require(LibCore.isSpawned(coreEntity), "OpenSystem: entity does not exist");
    require(LibCore.isReady(coreEntity), "OpenSystem: entity is in cooldown");
    require(!LibCore.isCommitted(coreEntity), "OpenSystem: entity is committed");
    require(LibCore.checkEnergy(coreEntity, gameConfig.openCost), "OpenSystem: not enough energy");

    bytes32 baseEntity = CarriedBy.get(coreEntity);
    require(CarriedBy.get(_lootEntity) == baseEntity, "OpenSystem: not carried");

    require(Loot.get(_lootEntity) > 0, "OpenSystem: not loot");

    LibLoot.open(_lootEntity);

    LibCore.decreaseEnergy(coreEntity, gameConfig.openCost);
  }
}
