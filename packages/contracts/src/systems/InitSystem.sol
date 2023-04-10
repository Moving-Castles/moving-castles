// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
import { GameConfig, GameConfigData } from "../codegen/tables/GameConfig.sol";
import { Position, PositionData } from "../codegen/tables/Position.sol";
import { Untraversable } from "../codegen/tables/Untraversable.sol";
import { Portable } from "../codegen/tables/Portable.sol";
import { Loot } from "../codegen/tables/Loot.sol";
import { LibUtils } from "../libraries/LibUtils.sol";

contract InitSystem is System {
  function init() public {
    require(GameConfig.getWorldHeight() == 0, "InitSystem: already initialized");

    GameConfig.set(
      GameConfigData({
        worldHeight: 10,
        worldWidth: 10,
        initialEnergy: 100,
        defaultCarryingCapacity: 4,
        moveCost: 10,
        pickUpCost: 5,
        dropCost: 5,
        transferCost: 5,
        playCost: 50,
        moveCooldown: 1,
        openCost: 0,
        harvestCost: 50,
        organMatter: 30
      })
    );

    // PositionData[6] memory untraversableTiles = [
    //   PositionData(4, 0),
    //   PositionData(4, 2),
    //   PositionData(4, 3),
    //   PositionData(4, 5),
    //   PositionData(4, 6),
    //   PositionData(4, 9)
    // ];

    // for (uint256 i = 0; i < untraversableTiles.length; ++i) {
    //   bytes32 untraversableEntity = LibUtils.getRandomKey();
    //   Portable.set(untraversableEntity, true);
    //   Untraversable.set(untraversableEntity, true);
    //   Position.set(untraversableEntity, untraversableTiles[i]);
    // }

    // PositionData[11] memory lootBoxTiles = [
    //   PositionData(4, 7),
    //   PositionData(4, 8),
    //   PositionData(2, 0),
    //   PositionData(2, 4),
    //   PositionData(3, 7),
    //   PositionData(6, 7),
    //   PositionData(7, 6),
    //   PositionData(8, 6),
    //   PositionData(3, 3),
    //   PositionData(3, 4),
    //   PositionData(2, 3)
    // ];

    // for (uint256 i = 0; i < lootBoxTiles.length; ++i) {
    //   bytes32 lootBox = LibUtils.getRandomKey();
    //   Portable.set(lootBox, true);
    //   // 1 == normal loot box
    //   Loot.set(lootBox, 1);
    //   Position.set(lootBox, lootBoxTiles[i]);
    // }
  }
}
