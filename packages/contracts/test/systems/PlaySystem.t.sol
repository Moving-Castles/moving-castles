// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { MudV2Test } from "../MudV2Test.t.sol";
import { console } from "forge-std/console.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";
import { PositionData } from "../../src/codegen/tables/Position.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";
import { Activity } from "../../src/utils/constants.sol";

contract PlaySystemTest is MudV2Test {
  function testPlay() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);
    PositionData memory spawnPosition = Position.get(world, baseEntity);

    // Give core more energy
    world.moving_castles_DevSystem_set(EnergyTableId, coreEntity, abi.encodePacked(uint32(500)));

    // Increase carrying capacity of base entity
    world.moving_castles_DevSystem_set(CarryingCapacityTableId, baseEntity, abi.encodePacked(uint32(9)));

    // Place an item allowing Play in inventory
    bytes32 portableEntity = LibUtils.getRandomKey();
    world.moving_castles_DevSystem_set(PortableTableId, portableEntity, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(AbilityPlayTableId, portableEntity, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(CarriedByTableId, portableEntity, abi.encodePacked(baseEntity));

    vm.roll(block.number + 2);

    // Start playing
    vm.startPrank(alice);
    world.moving_castles_PlaySystem_play();
    vm.stopPrank();

    // Core energy should be 500 - PLAY_COST
    assertEq(Energy.get(world, coreEntity), 500 - gameConfig.playCost);

    // Core commit should be Activity.Play
    assertEq(Commit.get(world, coreEntity), uint32(Activity.Play));

    console.log(Commit.get(world, coreEntity));

    vm.roll(block.number + 100);

    // Place an item allowing Play in inventory
    bytes32 abilityMoveItem = LibUtils.getRandomKey();
    world.moving_castles_DevSystem_set(PortableTableId, abilityMoveItem, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(AbilityMoveTableId, abilityMoveItem, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(CarriedByTableId, abilityMoveItem, abi.encodePacked(baseEntity));

    PositionData memory targetPosition = PositionData(
      spawnPosition.x < gameConfig.worldWidth - 2 ? spawnPosition.x + 1 : spawnPosition.x - 1,
      spawnPosition.y
    );

    // Core should be unable to take action
    vm.expectRevert(bytes("MoveSystem: entity is committed"));
    vm.startPrank(alice);
    world.moving_castles_MoveSystem_move(targetPosition.x, targetPosition.y);
    vm.stopPrank();

    vm.roll(block.number + 100);

    // Stop playing
    vm.startPrank(alice);
    world.moving_castles_PlaySystem_play();
    vm.stopPrank();

    console.log(Commit.get(world, coreEntity));

    // Core commit should be removed
    assertEq(Commit.get(world, coreEntity), 0);

    // Core should again be able to take action
    vm.startPrank(alice);
    world.moving_castles_MoveSystem_move(targetPosition.x, targetPosition.y);
    vm.stopPrank();
  }
}
