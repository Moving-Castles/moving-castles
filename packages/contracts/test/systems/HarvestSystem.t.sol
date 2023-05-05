// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { MudV2Test } from "../MudV2Test.t.sol";
import { console } from "forge-std/console.sol";
import { GoalKey } from "../../src/utils/constants.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";
import { PositionData } from "../../src/codegen/tables/Position.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";

contract HarvestSystemTest is MudV2Test {
  function testHarvest() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);

    // Increase carrying capacity of base entity
    world.moving_castles_DevSystem_set(CarryingCapacityTableId, baseEntity, abi.encodePacked(uint32(9)));

    // Place goal item in inventory
    world.moving_castles_DevSystem_set(PortableTableId, GoalKey, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(GoalTableId, GoalKey, abi.encodePacked(block.number));
    world.moving_castles_DevSystem_set(CarriedByTableId, GoalKey, abi.encodePacked(baseEntity));

    assertTrue(Portable.get(world, GoalKey));
    assertEq(Goal.get(world, GoalKey), block.number);
    assertEq(CarriedBy.get(world, GoalKey), baseEntity);
    assertEq(CarriedBy.get(world, coreEntity), CarriedBy.get(world, GoalKey));

    vm.roll(block.number + 200);

    // Harvest
    vm.startPrank(alice);
    world.moving_castles_HarvestSystem_harvest();
    vm.stopPrank();

    // Should be 200 points
    assertEq(Point.get(world, coreEntity), 200);

    // Core energy should be INITIAL_ENERGY - HARVEST_COST
    assertEq(Energy.get(world, coreEntity), gameConfig.initialEnergy - gameConfig.harvestCost);
  }

  function testMultiCoreHarvest() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    vm.startPrank(bob);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    vm.startPrank(eve);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);

    // Move Bob to Alice's base entity
    world.moving_castles_DevSystem_set(
      CarriedByTableId,
      LibUtils.addressToEntityKey(bob),
      abi.encodePacked(baseEntity)
    );

    // Move Eve to Alice's base entity
    world.moving_castles_DevSystem_set(
      CarriedByTableId,
      LibUtils.addressToEntityKey(eve),
      abi.encodePacked(baseEntity)
    );

    // Place goal item in inventory
    world.moving_castles_DevSystem_set(PortableTableId, GoalKey, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(GoalTableId, GoalKey, abi.encodePacked(block.number));
    world.moving_castles_DevSystem_set(CarriedByTableId, GoalKey, abi.encodePacked(baseEntity));

    console.log(block.number);
    vm.roll(block.number + 200);
    console.log(block.number);

    // Harvest
    vm.startPrank(alice);
    world.moving_castles_HarvestSystem_harvest();
    vm.stopPrank();

    // As there are three cores in the base entity
    // the points for each core should be:
    //  200 / 3 = 66,6666... = 66
    assertEq(Point.get(world, coreEntity), 66);
    assertEq(Point.get(world, LibUtils.addressToEntityKey(bob)), 66);
    assertEq(Point.get(world, LibUtils.addressToEntityKey(eve)), 66);

    // Core energy should be INITIAL_ENERGY - HARVEST_COST
    assertEq(Energy.get(world, coreEntity), gameConfig.initialEnergy - gameConfig.harvestCost);
  }
}
