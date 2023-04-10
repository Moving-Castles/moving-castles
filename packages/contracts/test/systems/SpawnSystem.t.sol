// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import { MudV2Test } from "../MudV2Test.t.sol";
import { console } from "forge-std/console.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";
import { PositionData } from "../../src/codegen/tables/Position.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";

contract SpawnSystemTest is MudV2Test {
  function testSpawn() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);

    // Check that the core was spawned correctly
    assertTrue(Core.get(world, coreEntity));
    assertTrue(Portable.get(world, coreEntity));
    assertEq(Energy.get(world, coreEntity), 100);
    assertEq(Point.get(world, coreEntity), 0);
    assertEq(CreationBlock.get(world, coreEntity), block.number);
    assertEq(ReadyBlock.get(world, coreEntity), block.number);
    assertTrue(CarriedBy.get(world, coreEntity) != 0);

    // Position
    PositionData memory spawnPosition = Position.get(world, baseEntity);
    assertGt(spawnPosition.x, -1);
    assertLt(spawnPosition.x, gameConfig.worldWidth);
    assertGt(spawnPosition.y, -1);
    assertLt(spawnPosition.y, gameConfig.worldHeight);

    // Carrying capacity
    assertEq(CarryingCapacity.get(world, baseEntity), gameConfig.defaultCarryingCapacity);
  }

  function testRevertRespawn() public {
    setUp();
    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.expectRevert(bytes("SpawnSystem: ID already exists"));
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();
  }

  function testSpawnInventory() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);

    // Should have 4 items in inventory:
    // - Core
    // - AbilityMoveItem
    // - AbilityConsumeItem
    // - Loot box
    // bytes32[] memory inventory = LibInventory.getInventory(baseEntity);
    bytes32[] memory inventory = getKeysWithValue(world, CarriedByTableId, CarriedBy.encode(baseEntity));
    assertEq(inventory.length, 4);
  }

  function testSpawnAbilities() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);
    vm.roll(2);

    bytes32[] memory inventory = getKeysWithValue(world, CarriedByTableId, CarriedBy.encode(baseEntity));
    uint256 inventoryLength = inventory.length;

    // Should be able to move
    uint256 moveAbilityCounter;
    for (uint256 i = 0; i < inventoryLength; ++i) {
      bytes32 item = inventory[i];
      if (AbilityMove.get(world, item)) {
        moveAbilityCounter++;
      }
    }
    assertEq(moveAbilityCounter, 1);

    // Should be able to consume
    uint256 consumeAbilityCounter;
    for (uint256 i = 0; i < inventoryLength; ++i) {
      bytes32 item = inventory[i];
      if (AbilityConsume.get(world, item)) {
        consumeAbilityCounter++;
      }
    }
    assertEq(consumeAbilityCounter, 1);
  }
}
