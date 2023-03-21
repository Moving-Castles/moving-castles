// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";

import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";
import { OpenSystem, ID as OpenSystemID } from "../../systems/OpenSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";

import { Coord } from "../../components/PositionComponent.sol";

import { LibLoot } from "../../libraries/LibLoot.sol";
import { LibInventory } from "../../libraries/LibInventory.sol";

contract OpenSystemTest is MudTest {
  function testOpen() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    OpenSystem openSystem = OpenSystem(system(OpenSystemID));

    vm.startPrank(alice);
    spawnSystem.executeTyped();
    vm.stopPrank();

    // Get base entity
    assertTrue(carriedByComponent.has(addressToEntity(alice)));
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    // Create a portable entity
    uint256 portableEntity = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, portableEntity, abi.encode(1));

    // Make it loot
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(LootComponentID, portableEntity, abi.encode(1));

    // Place in inventory
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      CarriedByComponentID,
      portableEntity,
      abi.encode(baseEntity)
    );

    uint256[] memory inventory = LibInventory.getInventory(components, baseEntity);
    assertEq(inventory.length, 5);

    // Open it
    vm.startPrank(alice);
    openSystem.executeTyped(portableEntity);
    vm.stopPrank();

    // loot should be gone
    assertTrue(!lootComponent.has(portableEntity));
    // assertTrue(!portableComponent.has(portableEntity));
    // assertTrue(!carriedByComponent.has(portableEntity));
  }
}
