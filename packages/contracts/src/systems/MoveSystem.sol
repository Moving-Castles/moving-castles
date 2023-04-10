// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
// ...
import { GameConfig, GameConfigData } from "../codegen/tables/GameConfig.sol";
import { CarriedBy } from "../codegen/tables/CarriedBy.sol";
import { Position, PositionData } from "../codegen/tables/Position.sol";
import { AbilityMoveTableId } from "../codegen/tables/AbilityMove.sol";
// ...
import { LibCore } from "../libraries/LibCore.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibAbility } from "../libraries/LibAbility.sol";
import { LibUtils } from "../libraries/LibUtils.sol";

contract MoveSystem is System {
  // function move(PositionData memory _targetPosition) public {
  function move(int32 x, int32 y) public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());
    PositionData memory _targetPosition = PositionData(x, y);

    GameConfigData memory gameConfig = GameConfig.get();

    require(LibCore.isSpawned(coreEntity), "MoveSystem: entity does not exist");
    require(LibCore.isReady(coreEntity), "MoveSystem: entity is in cooldown");
    require(!LibCore.isCommitted(coreEntity), "MoveSystem: entity is committed");
    // // @todo: calculate energy discount
    require(LibCore.checkEnergy(coreEntity, gameConfig.moveCost), "MoveSystem: not enough energy");

    bytes32 baseEntity = CarriedBy.get(coreEntity);

    uint32 abilityCount = LibAbility.checkInventoryForAbility(AbilityMoveTableId, baseEntity);
    require(abilityCount > 0, "MoveSystem: no item with AbilityMove");

    PositionData memory currentPosition = Position.get(baseEntity);
    require(LibMap.isWithinBounds(_targetPosition), "MoveSystem: out of bounds");
    require(LibMap.isAdjacent(currentPosition, _targetPosition), "MoveSystem: not adjacent");
    require(!LibMap.isUntraversable(_targetPosition), "MoveSystem: untraversable");
    Position.set(baseEntity, _targetPosition);

    // Apply discount if entity has more than one "movement organ"
    uint32 calculatedMoveCost = gameConfig.moveCost - (2 * (abilityCount - 1));

    LibCore.decreaseEnergy(coreEntity, calculatedMoveCost);
    LibCore.setReadyBlock(coreEntity, gameConfig.moveCooldown);
  }
}
