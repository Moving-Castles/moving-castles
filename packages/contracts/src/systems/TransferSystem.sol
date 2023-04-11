// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
// ...
import { Position, PositionData } from "../codegen/tables/Position.sol";
import { GameConfig, GameConfigData } from "../codegen/tables/GameConfig.sol";
import { CarriedBy } from "../codegen/tables/CarriedBy.sol";
// ...
import { LibCore } from "../libraries/LibCore.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibUtils } from "../libraries/LibUtils.sol";

contract TransferSystem is System {
  function transfer(bytes32 _portableEntity, bytes32 _targetBaseEntity) public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());

    GameConfigData memory gameConfig = GameConfig.get();

    require(LibCore.isSpawned(coreEntity), "TransferSystem: entity does not exist");
    require(LibCore.isReady(coreEntity), "TransferSystem: entity is in cooldown");
    require(!LibCore.isCommitted(coreEntity), "TransferSystem: entity is committed");
    require(LibCore.checkEnergy(coreEntity, gameConfig.transferCost), "TransferSystem: not enough energy");

    bytes32 baseEntity = CarriedBy.get(coreEntity);
    require(LibInventory.isCarriedBy(_portableEntity, baseEntity), "TransferSystem: not carried by caller");

    PositionData memory baseEntityPosition = Position.get(baseEntity);
    PositionData memory targetBaseEntityPosition = Position.get(_targetBaseEntity);
    require(LibMap.isAdjacent(baseEntityPosition, targetBaseEntityPosition), "TransferSystem: not adjacent");

    LibInventory.addToInventory(_targetBaseEntity, _portableEntity);

    LibCore.decreaseEnergy(coreEntity, gameConfig.transferCost);
  }
}
