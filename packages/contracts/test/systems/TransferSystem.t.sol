// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { MudV2Test } from "../MudV2Test.t.sol";
import { console } from "forge-std/console.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";
import { PositionData } from "../../src/codegen/tables/Position.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";

contract TransferSystemTest is MudV2Test {
  function testTransfer() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);
    PositionData memory spawnPosition = Position.get(world, baseEntity);

    // Increase carrying capacity of alice's base entity
    world.moving_castles_DevSystem_set(CarryingCapacityTableId, baseEntity, abi.encodePacked(uint32(9)));

    // Place an item in inventory
    bytes32 portableEntity = LibUtils.getRandomKey();
    world.moving_castles_DevSystem_set(PortableTableId, portableEntity, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(CarriedByTableId, portableEntity, abi.encodePacked(baseEntity));

    // Spawn Bob
    vm.startPrank(bob);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 bobCoreEntity = LibUtils.addressToEntityKey(bob);
    bytes32 bobBaseEntity = CarriedBy.get(world, coreEntity);

    // Increase carrying capacity of bob's base entity
    world.moving_castles_DevSystem_set(CarryingCapacityTableId, bobBaseEntity, abi.encodePacked(uint32(9)));

    // Move bob to same position as Alice
    world.moving_castles_DevSystem_set(PositionTableId, bobBaseEntity, spawnPosition.x, spawnPosition.y);

    vm.roll(block.number + 2);

    // Transfer portableEntity to bob
    vm.startPrank(alice);
    world.moving_castles_TransferSystem_transfer(portableEntity, bobBaseEntity);
    vm.stopPrank();

    // portableEntity should be carried by Bob
    assertEq(CarriedBy.get(world, portableEntity), bobBaseEntity);

    // Core energy should be INITAL_ENERGY - TRANSFER_COST
    assertEq(Energy.get(world, coreEntity), gameConfig.initialEnergy - gameConfig.transferCost);
  }
}
