// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import { MudV2Test } from "../MudV2Test.t.sol";
import { console } from "forge-std/console.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";
import { PositionData } from "../../src/codegen/tables/Position.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";

contract MoveSystemTest is MudV2Test {
  function testStep() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);
    PositionData memory spawnPosition = Position.get(world, baseEntity);

    PositionData memory targetPosition = PositionData(
      spawnPosition.x < gameConfig.worldWidth - 2 ? spawnPosition.x + 1 : spawnPosition.x - 1,
      spawnPosition.y
    );

    vm.roll(block.number + 2);

    vm.startPrank(alice);
    world.moving_castles_MoveSystem_move(targetPosition.x, targetPosition.y);
    vm.stopPrank();

    // New position
    PositionData memory newPosition = Position.get(world, baseEntity);
    assertEq(newPosition.x, targetPosition.x);
    assertEq(newPosition.y, targetPosition.y);

    // ReadyBlock
    assertEq(ReadyBlock.get(world, coreEntity), block.number + gameConfig.moveCooldown);

    // Energy
    assertEq(Energy.get(world, coreEntity), gameConfig.initialEnergy - gameConfig.moveCost);
  }

  function testRevertUnspawned() public {
    setUp();
    vm.startPrank(alice);
    vm.expectRevert(bytes("MoveSystem: entity does not exist"));
    world.moving_castles_MoveSystem_move(0, 0);
    vm.stopPrank();
  }

  function testRevertCooldown() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);
    PositionData memory spawnPosition = Position.get(world, baseEntity);

    PositionData memory targetPosition = PositionData(
      spawnPosition.x < gameConfig.worldWidth - 2 ? spawnPosition.x + 1 : spawnPosition.x - 1,
      spawnPosition.y
    );

    vm.startPrank(alice);
    vm.expectRevert(bytes("MoveSystem: entity is in cooldown"));
    world.moving_castles_MoveSystem_move(targetPosition.x, targetPosition.y);
    vm.stopPrank();
  }

  function testMultiAbilityCost() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    bytes32 baseEntity = CarriedBy.get(world, coreEntity);
    PositionData memory spawnPosition = Position.get(world, baseEntity);

    PositionData memory targetPosition = PositionData(
      spawnPosition.x < gameConfig.worldWidth - 2 ? spawnPosition.x + 1 : spawnPosition.x - 1,
      spawnPosition.y
    );

    // Increase carrying capacity of base entity
    world.moving_castles_DevSystem_set(CarryingCapacityTableId, baseEntity, abi.encodePacked(uint32(9)));

    // Place an item in inventory
    bytes32 portableEntity = LibUtils.getRandomKey();
    world.moving_castles_DevSystem_set(PortableTableId, portableEntity, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(CarriedByTableId, portableEntity, abi.encodePacked(baseEntity));

    // Give baseEntity two more movement organs for a total of three

    bytes32 m1 = LibUtils.getRandomKey();
    world.moving_castles_DevSystem_set(PortableTableId, m1, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(AbilityMoveTableId, m1, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(CarriedByTableId, m1, abi.encodePacked(baseEntity));

    vm.roll(block.number + 2);
    bytes32 m2 = LibUtils.getRandomKey();
    world.moving_castles_DevSystem_set(PortableTableId, m2, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(AbilityMoveTableId, m2, abi.encodePacked(true));
    world.moving_castles_DevSystem_set(CarriedByTableId, m2, abi.encodePacked(baseEntity));

    vm.roll(block.number + 2);

    vm.startPrank(alice);
    world.moving_castles_MoveSystem_move(targetPosition.x, targetPosition.y);
    vm.stopPrank();

    // Energy should be:
    // gameConfig.initialEnergy - (gameConfig.moveCost - (2 * (3 - 1)))
    // 3 => number of movement organs
    assertEq(Energy.get(world, coreEntity), gameConfig.initialEnergy - (gameConfig.moveCost - 4));
  }
}
