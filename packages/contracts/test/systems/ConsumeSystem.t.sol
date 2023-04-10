// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { MudV2Test } from "../MudV2Test.t.sol";
import { console } from "forge-std/console.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";
import { PositionData } from "../../src/codegen/tables/Position.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";

contract ConsumeSystemTest is MudV2Test {
  function testConsume() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);
    PositionData memory spawnPosition = Position.get(world, baseEntity);

    // Increase carrying capacity of base entity
    world.moving_castles_DevSystem_set(CarryingCapacityTableId, baseEntity, abi.encodePacked(uint32(9)));

    // Give baseEntity a blank organ
    bytes32 portableEntity = LibUtils.getRandomKey();
    world.moving_castles_DevSystem_set(PortableTableId, portableEntity, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(MatterTableId, portableEntity, abi.encodePacked(uint32(10)));
    world.moving_castles_DevSystem_set(CarriedByTableId, portableEntity, abi.encodePacked(baseEntity));

    vm.roll(block.number + 2);

    // Consume the blank organ
    vm.startPrank(alice);
    world.moving_castles_ConsumeSystem_consume(portableEntity);
    vm.stopPrank();

    // Core energy should be INITIAL_ENERGY + 20
    assertEq(Energy.get(world, coreEntity), gameConfig.initialEnergy + 20);

    // portableEntity should be removed
    assertEq(Portable.get(world, portableEntity), false);
    assertEq(Matter.get(world, portableEntity), 0);
    assertEq(CarriedBy.get(world, portableEntity), bytes32(0));
  }

  function testMultiAbilityConversion() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);
    PositionData memory spawnPosition = Position.get(world, baseEntity);

    // Increase carrying capacity of base entity
    world.moving_castles_DevSystem_set(CarryingCapacityTableId, baseEntity, abi.encodePacked(uint32(9)));

    // Give baseEntity a blank organ
    bytes32 portableEntity = LibUtils.getRandomKey();
    world.moving_castles_DevSystem_set(PortableTableId, portableEntity, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(MatterTableId, portableEntity, abi.encodePacked(uint32(10)));
    world.moving_castles_DevSystem_set(CarriedByTableId, portableEntity, abi.encodePacked(baseEntity));

    vm.roll(block.number + 2);

    // Give baseEntity two more "consume organs" for a total of three
    bytes32 c1 = LibUtils.getRandomKey();
    world.moving_castles_DevSystem_set(PortableTableId, c1, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(AbilityConsumeTableId, c1, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(CarriedByTableId, c1, abi.encodePacked(baseEntity));

    vm.roll(block.number + 2);
    bytes32 c2 = LibUtils.getRandomKey();
    world.moving_castles_DevSystem_set(PortableTableId, c2, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(AbilityConsumeTableId, c2, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(CarriedByTableId, c2, abi.encodePacked(baseEntity));

    // Consume blank organ
    vm.startPrank(alice);
    world.moving_castles_ConsumeSystem_consume(portableEntity);
    vm.stopPrank();

    // Energy should be:
    // gameConfig.initialEnergy + (10 * (3 * 2))
    // 3 => number of consume organs
    assertEq(Energy.get(world, coreEntity), gameConfig.initialEnergy + 60);
  }
}
