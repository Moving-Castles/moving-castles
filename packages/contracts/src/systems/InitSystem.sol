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

    // create loot box 1
    uint256 lootBox = world.getUniqueEntityId();
    LibInventory.makePortable(components, lootBox);
    LibLoot.makeLoot(components, lootBox);
    LibMove.setPosition(components, lootBox, Coord(4, 7));

    // create loot box 2
    uint256 lootBox2 = world.getUniqueEntityId();
    LibInventory.makePortable(components, lootBox2);
    LibLoot.makeLoot(components, lootBox2);
    LibMove.setPosition(components, lootBox2, Coord(4, 7));

    // create loot box 3
    uint256 lootBox3 = world.getUniqueEntityId();
    LibInventory.makePortable(components, lootBox3);
    LibLoot.makeLoot(components, lootBox3);
    LibMove.setPosition(components, lootBox3, Coord(4, 7));

    // create loot box 4
    uint256 lootBox4 = world.getUniqueEntityId();
    LibInventory.makePortable(components, lootBox4);
    LibLoot.makeLoot(components, lootBox4);
    LibMove.setPosition(components, lootBox4, Coord(4, 7));

    // create loot box 5
    uint256 lootBox5 = world.getUniqueEntityId();
    LibInventory.makePortable(components, lootBox5);
    LibLoot.makeLoot(components, lootBox5);
    LibMove.setPosition(components, lootBox5, Coord(4, 7));

    // create loot box 6
    uint256 lootBox6 = world.getUniqueEntityId();
    LibInventory.makePortable(components, lootBox6);
    LibLoot.makeLoot(components, lootBox6);
    LibMove.setPosition(components, lootBox6, Coord(4, 7));

    // create loot box 7
    uint256 lootBox7 = world.getUniqueEntityId();
    LibInventory.makePortable(components, lootBox7);
    LibLoot.makeLoot(components, lootBox7);
    LibMove.setPosition(components, lootBox7, Coord(6, 6));

    // create loot box 8
    uint256 lootBox8 = world.getUniqueEntityId();
    LibInventory.makePortable(components, lootBox8);
    LibLoot.makeLoot(components, lootBox8);
    LibMove.setPosition(components, lootBox8, Coord(6, 6));

    // create loot box 9
    uint256 lootBox9 = world.getUniqueEntityId();
    LibInventory.makePortable(components, lootBox9);
    LibLoot.makeLoot(components, lootBox9);
    LibMove.setPosition(components, lootBox9, Coord(6, 6));

    // create loot box 10
    uint256 lootBox10 = world.getUniqueEntityId();
    LibInventory.makePortable(components, lootBox10);
    LibLoot.makeLoot(components, lootBox10);
    LibMove.setPosition(components, lootBox10, Coord(2, 4));

    // create loot box 11
    uint256 lootBox11 = world.getUniqueEntityId();
    LibInventory.makePortable(components, lootBox11);
    LibLoot.makeLoot(components, lootBox11);
    LibMove.setPosition(components, lootBox11, Coord(2, 4));
  }

  function executeTyped() public returns (bytes memory) {
    return execute(abi.encode());
  }
}
