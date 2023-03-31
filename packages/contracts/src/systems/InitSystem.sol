// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { LibConfig } from "../libraries/LibConfig.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibMove } from "../libraries/LibMove.sol";
import { LibAbility } from "../libraries/LibAbility.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibLoot } from "../libraries/LibLoot.sol";

import { Coord } from "../components/PositionComponent.sol";
import { GameConfig } from "../components/GameConfigComponent.sol";

uint256 constant ID = uint256(keccak256("system.Init"));

contract InitSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    require(!LibConfig.isInitialized(components), "InitSystem: already initialized");

    GameConfig memory gameConfig = GameConfig({
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
      harvestCost: 50
    });
    LibConfig.setGameConfig(components, gameConfig);

    Coord[6] memory untraversableTiles = [Coord(4, 0), Coord(4, 2), Coord(4, 3), Coord(4, 5), Coord(4, 6), Coord(4, 9)];

    for (uint256 i = 0; i < untraversableTiles.length; ++i) {
      LibMap.createUntraversable(world, components, untraversableTiles[i]);
    }

    Coord[11] memory lootBoxTiles = [
      Coord(4, 7),
      Coord(4, 8),
      Coord(2, 0),
      Coord(2, 4),
      Coord(3, 7),
      Coord(6, 7),
      Coord(7, 6),
      Coord(8, 6),
      Coord(3, 3),
      Coord(3, 4),
      Coord(2, 3)
    ];

    for (uint256 i = 0; i < lootBoxTiles.length; ++i) {
      uint256 lootBox = world.getUniqueEntityId();
      LibInventory.makePortable(components, lootBox);
      LibLoot.makeNormalLoot(components, lootBox);
      LibMove.setPosition(components, lootBox, lootBoxTiles[i]);
    }
  }

  function executeTyped() public returns (bytes memory) {
    return execute(abi.encode());
  }
}
