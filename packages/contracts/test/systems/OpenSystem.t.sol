// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { MudV2Test } from "../MudV2Test.t.sol";
import { console } from "forge-std/console.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";
import { PositionData } from "../../src/codegen/tables/Position.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";
import { Activity } from "../../src/utils/constants.sol";

contract OpenSystemTest is MudV2Test {
  function testOpen() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);

    // Increase carrying capacity of base entity
    world.moving_castles_DevSystem_set(CarryingCapacityTableId, baseEntity, abi.encodePacked(uint32(9)));

    // Place a loot box in inventory
    bytes32 portableEntity = LibUtils.getRandomKey();
    world.moving_castles_DevSystem_set(PortableTableId, portableEntity, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(LootTableId, portableEntity, abi.encodePacked(uint32(1)));
    world.moving_castles_DevSystem_set(CarriedByTableId, portableEntity, abi.encodePacked(baseEntity));

    vm.roll(block.number + 1);

    // Open it
    vm.startPrank(alice);
    world.moving_castles_OpenSystem_open(portableEntity);
    vm.stopPrank();

    // Loot should converted to organ
    assertEq(Loot.get(world, portableEntity), 0);
  }
}
