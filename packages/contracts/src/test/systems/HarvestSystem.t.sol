// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";

import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";
import { HarvestSystem, ID as HarvestSystemID } from "../../systems/HarvestSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";

import { Coord } from "../../components/PositionComponent.sol";

import { LibInventory } from "../../libraries/LibInventory.sol";
import { LibAbility } from "../../libraries/LibAbility.sol";

contract HarvestSystemTest is MudTest {
  function testHarvest() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    HarvestSystem harvestSystem = HarvestSystem(system(HarvestSystemID));

    vm.startPrank(alice);
    spawnSystem.executeTyped();

    // Get base entity
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    // Place goal item in inventory
    uint256 goalItem = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, goalItem, abi.encode(1));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(GoalComponentID, goalItem, abi.encode(block.number));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      CarriedByComponentID,
      goalItem,
      abi.encode(baseEntity)
    );

    vm.roll(200);

    // Harvest
    harvestSystem.executeTyped();

    // Core point should be harvest-block (200) - initial-block (2) = 198
    assertEq(pointComponent.getValue(addressToEntity(alice)), 198);

    // Core energy should be INITIAL_ENERGY - HARVEST_COST
    assertEq(energyComponent.getValue(addressToEntity(alice)), gameConfig.initialEnergy - gameConfig.harvestCost);

    vm.stopPrank();
  }

  function testMultiCoreHarvest() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    HarvestSystem harvestSystem = HarvestSystem(system(HarvestSystemID));

    vm.startPrank(alice);
    spawnSystem.executeTyped();
    vm.stopPrank();

    vm.startPrank(bob);
    spawnSystem.executeTyped();
    vm.stopPrank();

    vm.startPrank(eve);
    spawnSystem.executeTyped();
    vm.stopPrank();

    // Get base entity
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    // Move Bob to Alice's base entity
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      CarriedByComponentID,
      addressToEntity(bob),
      abi.encode(baseEntity)
    );

    // Move Eve to Alice's base entity
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      CarriedByComponentID,
      addressToEntity(eve),
      abi.encode(baseEntity)
    );

    // Place goal item in inventory
    uint256 goalItem = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, goalItem, abi.encode(1));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(GoalComponentID, goalItem, abi.encode(block.number));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      CarriedByComponentID,
      goalItem,
      abi.encode(baseEntity)
    );

    vm.roll(213);

    // Harvest
    vm.startPrank(alice);
    harvestSystem.executeTyped();
    vm.stopPrank();

    // As there are three cores in the base entity
    // the points for each core should be:
    // harvest-block (213) - initial-block (2) = 211 / 3 = 70,3333... = 70
    assertEq(pointComponent.getValue(addressToEntity(alice)), 70);
    assertEq(pointComponent.getValue(addressToEntity(bob)), 70);
    assertEq(pointComponent.getValue(addressToEntity(eve)), 70);

    // Core energy should be INITIAL_ENERGY - HARVEST_COST
    assertEq(energyComponent.getValue(addressToEntity(alice)), gameConfig.initialEnergy - gameConfig.harvestCost);

    vm.stopPrank();
  }
}
