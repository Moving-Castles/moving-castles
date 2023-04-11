// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { MudV2Test } from "../MudV2Test.t.sol";
import { console } from "forge-std/console.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";
import { PositionData } from "../../src/codegen/tables/Position.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";

contract DropSystemTest is MudV2Test {
  function testDrop() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);
    PositionData memory spawnPosition = Position.get(world, baseEntity);

    // Increase carrying capacity of base entity
    world.moving_castles_DevSystem_set(CarryingCapacityTableId, baseEntity, abi.encodePacked(uint32(9)));

    // Place an item in inventory
    bytes32 portableEntity = LibUtils.getRandomKey();
    world.moving_castles_DevSystem_set(PortableTableId, portableEntity, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(CarriedByTableId, portableEntity, abi.encodePacked(baseEntity));

    vm.roll(block.number + 2);

    // Drop its
    vm.startPrank(alice);
    world.moving_castles_DropSystem_drop(portableEntity);
    vm.stopPrank();

    // portableEntity should have position = baseEntity position
    PositionData memory droppedPosition = Position.get(world, portableEntity);
    assertEq(droppedPosition.x, spawnPosition.x);
    assertEq(droppedPosition.y, spawnPosition.y);

    // portableEntity should not have carriedBy
    assertEq(CarriedBy.get(world, portableEntity), bytes32(0));

    // Core energy should be INITIAL_ENERGY - DROP_COST
    assertEq(Energy.get(world, coreEntity), gameConfig.initialEnergy - gameConfig.dropCost);

    vm.stopPrank();
  }

  function testDropCore() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);

    vm.roll(block.number + 2);

    // Drop your own core
    vm.startPrank(alice);
    world.moving_castles_DropSystem_drop(coreEntity);
    vm.stopPrank();

    // Core is in the void
    PositionData memory corePosition = Position.get(world, coreEntity);
    assertEq(corePosition.x, 0);
    assertEq(corePosition.y, 0);

    // Core should not have carriedBy
    assertEq(CarriedBy.get(world, coreEntity), 0);

    // Core energy should be INITIAL_ENERGY - DROP_COST
    assertEq(Energy.get(world, coreEntity), gameConfig.initialEnergy - gameConfig.dropCost);

    vm.stopPrank();
  }
}
