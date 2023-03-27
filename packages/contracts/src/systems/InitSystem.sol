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
      defaultCarryingCapacity: 10,
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

    // Create initial entities
    LibMap.createUntraversable(world, components, Coord(4, 0));
    LibMap.createUntraversable(world, components, Coord(4, 2));
    LibMap.createUntraversable(world, components, Coord(4, 3));
    LibMap.createUntraversable(world, components, Coord(4, 5));
    LibMap.createUntraversable(world, components, Coord(4, 6));
    LibMap.createUntraversable(world, components, Coord(4, 9));

    Coord[11] memory lootBoxLocations = [
      Coord(4, 7),
      Coord(4, 7),
      Coord(4, 7),
      Coord(4, 7),
      Coord(4, 7),
      Coord(4, 7),
      Coord(6, 6),
      Coord(6, 6),
      Coord(6, 6),
      Coord(2, 4),
      Coord(2, 4)
    ];

    for (uint256 i = 0; i < 11; ++i) {
      uint256 lootBox = world.getUniqueEntityId();
      LibInventory.makePortable(components, lootBox);
      LibLoot.makeNormalLoot(components, lootBox);
      LibMove.setPosition(components, lootBox, lootBoxLocations[i]);
    }
  }

  function executeTyped() public returns (bytes memory) {
    return execute(abi.encode());
  }
}
