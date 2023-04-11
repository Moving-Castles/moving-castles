// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
// ...
import { GameConfig, GameConfigData } from "../codegen/tables/GameConfig.sol";
import { CarriedBy } from "../codegen/tables/CarriedBy.sol";
import { AbilityPlayTableId } from "../codegen/tables/AbilityPlay.sol";
// ...
import { LibCore } from "../libraries/LibCore.sol";
import { LibAbility } from "../libraries/LibAbility.sol";
import { LibUtils } from "../libraries/LibUtils.sol";
import { Activity } from "../utils/constants.sol";

contract PlaySystem is System {
  function play() public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());

    require(LibCore.isSpawned(coreEntity), "PlaySystem: entity does not exist");
    require(LibCore.isReady(coreEntity), "PlaySystem: entity is in cooldown");

    GameConfigData memory gameConfig = GameConfig.get();

    bytes32 baseEntity = CarriedBy.get(coreEntity);

    uint32 abilityCount = LibAbility.checkInventoryForAbility(AbilityPlayTableId, baseEntity);
    require(abilityCount > 0, "PlaySystem: no item with AbilityPlay");

    if (LibCore.isCommitted(coreEntity)) {
      LibCore.uncommit(coreEntity);
    } else {
      require(LibCore.checkEnergy(coreEntity, gameConfig.playCost), "PlaySystem: not enough energy");
      LibCore.commit(coreEntity, Activity.Play);
      LibCore.decreaseEnergy(coreEntity, gameConfig.playCost);
    }
  }
}
