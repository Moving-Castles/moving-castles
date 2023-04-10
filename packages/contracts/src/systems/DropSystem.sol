// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
// ...
import { GameConfig, GameConfigData } from "../codegen/tables/GameConfig.sol";
import { Position, PositionData } from "../codegen/tables/Position.sol";
import { CarriedBy } from "../codegen/tables/CarriedBy.sol";
// ...
import { LibCore } from "../libraries/LibCore.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibUtils } from "../libraries/LibUtils.sol";

contract DropSystem is System {
  function drop(bytes32 _portableEntity) public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());

    GameConfigData memory gameConfig = GameConfig.get();

    require(LibCore.isSpawned(coreEntity), "DropSystem: entity does not exist");
    require(LibCore.isReady(coreEntity), "DropSystem: entity is in cooldown");
    require(!LibCore.isCommitted(coreEntity), "DropSystem: entity is committed");
    require(LibCore.checkEnergy(coreEntity, gameConfig.dropCost), "DropSystem: not enough energy");

    bytes32 baseEntity = CarriedBy.get(coreEntity);
    require(LibInventory.isCarriedBy(_portableEntity, baseEntity), "DropSystem: not carried by caller");

    LibInventory.removeFromInventory(_portableEntity);

    // Dropping a core ejects it into the void...
    if (_portableEntity == coreEntity) {
      Position.deleteRecord(_portableEntity);
    } else {
      PositionData memory baseEntityPosition = Position.get(baseEntity);
      Position.set(_portableEntity, baseEntityPosition);
    }

    LibCore.decreaseEnergy(coreEntity, gameConfig.dropCost);
  }
}
