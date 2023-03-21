// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";

import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";
import { PlaySystem, ID as PlaySystemID } from "../../systems/PlaySystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { MoveSystem, ID as MoveSystemID } from "../../systems/MoveSystem.sol";

import { Coord } from "../../components/PositionComponent.sol";
import { Activity } from "../../utils/constants.sol";

contract PlaySystemTest is MudTest {
  function testPlay() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    PlaySystem playSystem = PlaySystem(system(PlaySystemID));
    MoveSystem moveSystem = MoveSystem(system(MoveSystemID));

    vm.startPrank(alice);
    spawnSystem.executeTyped();

    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    // Place an item allowing Play in inventory
    uint256 abilityPlayItem = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, abilityPlayItem, abi.encode(1));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      AbilityPlayComponentID,
      abilityPlayItem,
      abi.encode(1)
    );
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      CarriedByComponentID,
      abilityPlayItem,
      abi.encode(baseEntity)
    );

    vm.roll(2);

    // Start playing
    playSystem.executeTyped();

    // Core energy should be INITAL_ENERGY - PLAY_COST
    assertEq(energyComponent.getValue(addressToEntity(alice)), gameConfig.initialEnergy - gameConfig.playCost);

    // Core commit should be Activity.Play
    assertEq(commitComponent.getValue(addressToEntity(alice)), uint32(Activity.Play));

    vm.roll(333);

    // Place an item allowing Move in inventory
    uint256 abilityMoveItem = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, abilityMoveItem, abi.encode(1));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      AbilityMoveComponentID,
      abilityMoveItem,
      abi.encode(1)
    );
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      CarriedByComponentID,
      abilityMoveItem,
      abi.encode(baseEntity)
    );

    Coord memory targetPosition = Coord(
      initialPosition.x < gameConfig.worldWidth - 2 ? initialPosition.x + 1 : initialPosition.x - 1,
      initialPosition.y
    );
    // Core should be unable to take action
    vm.expectRevert(bytes("MoveSystem: entity is committed"));
    moveSystem.executeTyped(targetPosition);

    vm.roll(666);

    // Stop playing
    playSystem.executeTyped();

    // Core commit should be removed
    assertTrue(!commitComponent.has(addressToEntity(alice)));

    // Core should again be able to take action
    moveSystem.executeTyped(targetPosition);

    vm.stopPrank();
  }
}
