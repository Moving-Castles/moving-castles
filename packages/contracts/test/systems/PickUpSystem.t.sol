// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { MudV2Test } from "../MudV2Test.t.sol";
import { console } from "forge-std/console.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";
import { PositionData } from "../../src/codegen/tables/Position.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";

contract PickUpSystemTest is MudV2Test {
  function testPickUp() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);
    PositionData memory spawnPosition = Position.get(world, baseEntity);

    // Increase carrying capacity of base entity
    world.moving_castles_DevSystem_set(CarryingCapacityTableId, baseEntity, abi.encodePacked(uint32(9)));

    // Create a portable entity on same tile
    bytes32 portableEntity = LibUtils.getRandomKey();
    world.moving_castles_DevSystem_set(PortableTableId, portableEntity, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(GoalTableId, portableEntity, abi.encodePacked(block.number));
    world.moving_castles_DevSystem_set(PositionTableId, portableEntity, spawnPosition.x, spawnPosition.y);

    vm.roll(block.number + 2);

    // Pick it up
    vm.startPrank(alice);
    world.moving_castles_PickUpSystem_pickUp(portableEntity);
    vm.stopPrank();

    // portableEntity should be carried by baseEntity
    assertEq(CarriedBy.get(world, portableEntity), baseEntity);

    // portableEntity should have no position
    assertEq(Position.get(world, portableEntity).x, 0);

    // Core energy should be INITAL_ENERGY - PICKUP_COST
    assertEq(Energy.get(world, coreEntity), gameConfig.initialEnergy - gameConfig.pickUpCost);
  }
}
