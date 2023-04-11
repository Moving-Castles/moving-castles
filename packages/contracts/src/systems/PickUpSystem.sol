// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
// ...
import { Position, PositionData } from "../codegen/tables/Position.sol";
import { CarriedBy } from "../codegen/tables/CarriedBy.sol";
import { GameConfig, GameConfigData } from "../codegen/tables/GameConfig.sol";
// ...
import { LibCore } from "../libraries/LibCore.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibUtils } from "../libraries/LibUtils.sol";

contract PickUpSystem is System {
  function pickUp(bytes32 _portableEntity) public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());

    GameConfigData memory gameConfig = GameConfig.get();

    require(LibCore.isSpawned(coreEntity), "PickUpSystem: entity does not exist");
    require(LibCore.isReady(coreEntity), "PickUpSystem: entity is in cooldown");
    require(!LibCore.isCommitted(coreEntity), "PickUpSystem: entity is committed");
    require(LibCore.checkEnergy(coreEntity, gameConfig.pickUpCost), "PickUpSystem: not enough energy");

    require(LibInventory.isPortable(_portableEntity), "PickUpSystem: entity is not portable");

    bytes32 baseEntity = CarriedBy.get(coreEntity);
    PositionData memory baseEntityPosition = Position.get(baseEntity);

    PositionData memory portableEntityPosition = Position.get(_portableEntity);
    require(LibMap.isAdjacent(baseEntityPosition, portableEntityPosition), "PickUpSystem: tile not adjacent");

    Position.deleteRecord(_portableEntity);
    LibInventory.addToInventory(baseEntity, _portableEntity);
    LibCore.decreaseEnergy(coreEntity, gameConfig.pickUpCost);
  }
}
