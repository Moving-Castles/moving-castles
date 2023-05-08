// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import { MudV2Test } from "../MudV2Test.t.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";

contract SpawnSystemTest is MudV2Test {
  function testSpawn() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);

    // Check that the core was spawned correctly
    assertTrue(Core.get(world, coreEntity));
    assertEq(CreationBlock.get(world, coreEntity), block.number);
    assertEq(ReadyBlock.get(world, coreEntity), block.number);
    assertEq(Energy.get(world, coreEntity), 0);
    assertTrue(Portable.get(world, coreEntity));
    assertEq(Avatar.get(world, coreEntity), 0);
    assertEq(Name.get(world, coreEntity), "Player1");
    assertEq(RealmId.get(world, coreEntity), 0);
    assertEq(CarriedBy.get(world, coreEntity), 0);
  }

  function testRevertRespawn() public {
    setUp();
    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn();
    vm.expectRevert(bytes("already spawned"));
    world.moving_castles_SpawnSystem_spawn();
    vm.stopPrank();
  }
}
