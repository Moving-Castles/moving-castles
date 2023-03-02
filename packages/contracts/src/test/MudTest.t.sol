// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import { DSTest } from "ds-test/test.sol";
import { World } from "solecs/World.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { Cheats } from "./utils/Cheats.sol";
import { Utilities } from "./utils/Utilities.sol";
import { Deploy } from "./utils/Deploy.sol";
import { componentsComponentId, systemsComponentId } from "solecs/constants.sol";
import { getAddressById } from "solecs/utils.sol";
import { console } from "forge-std/console.sol";

import { LibConfig } from "../libraries/LibConfig.sol";
import { GameConfig } from "../components/GameConfigComponent.sol";

import { PositionComponent, ID as PositionComponentID } from "../components/PositionComponent.sol";
import { EnergyComponent, ID as EnergyComponentID } from "../components/EnergyComponent.sol";
import { CreationBlockComponent, ID as CreationBlockComponentID } from "../components/CreationBlockComponent.sol";
import { ReadyBlockComponent, ID as ReadyBlockComponentID } from "../components/ReadyBlockComponent.sol";
import { PortableComponent, ID as PortableComponentID } from "../components/PortableComponent.sol";
import { CarryingCapacityComponent, ID as CarryingCapacityComponentID } from "../components/CarryingCapacityComponent.sol";
import { CoreComponent, ID as CoreComponentID } from "../components/CoreComponent.sol";
import { CarriedByComponent, ID as CarriedByComponentID } from "../components/CarriedByComponent.sol";
import { MatterComponent, ID as MatterComponentID } from "../components/MatterComponent.sol";
import { UntraversableComponent, ID as UntraversableComponentID } from "../components/UntraversableComponent.sol";
import { AbilityMoveComponent, ID as AbilityMoveComponentID } from "../components/AbilityMoveComponent.sol";
import { AbilityExtractComponent, ID as AbilityExtractComponentID } from "../components/AbilityExtractComponent.sol";
import { AbilityConsumeComponent, ID as AbilityConsumeComponentID } from "../components/AbilityConsumeComponent.sol";
import { AbilityPlayComponent, ID as AbilityPlayComponentID } from "../components/AbilityPlayComponent.sol";
import { AbilityBurnComponent, ID as AbilityBurnComponentID } from "../components/AbilityBurnComponent.sol";
import { CommitComponent, ID as CommitComponentID } from "../components/CommitComponent.sol";
import { BurnBlockComponent, ID as BurnBlockComponentID } from "../components/BurnBlockComponent.sol";
import { LootComponent, ID as LootComponentID } from "../components/LootComponent.sol";

contract MudTest is DSTest {
  Cheats internal immutable vm = Cheats(HEVM_ADDRESS);
  Utilities internal immutable utils = new Utilities();

  address payable internal alice;
  address payable internal bob;
  address payable internal eve;
  address internal deployer;

  IWorld internal world;
  IUint256Component components;
  IUint256Component systems;
  Deploy internal deploy = new Deploy();

  GameConfig gameConfig;

  PositionComponent positionComponent;
  EnergyComponent energyComponent;
  CreationBlockComponent creationBlockComponent;
  ReadyBlockComponent readyBlockComponent;
  PortableComponent portableComponent;
  CarryingCapacityComponent carryingCapacityComponent;
  CoreComponent coreComponent;
  CarriedByComponent carriedByComponent;
  MatterComponent matterComponent;
  UntraversableComponent untraversableComponent;
  CommitComponent commitComponent;
  BurnBlockComponent burnBlockComponent;
  LootComponent lootComponent;
  AbilityMoveComponent abilityMoveComponent;
  AbilityExtractComponent abilityExtractComponent;
  AbilityConsumeComponent abilityConsumeComponent;
  AbilityPlayComponent abilityPlayComponent;
  AbilityBurnComponent abilityBurnComponent;

  function component(uint256 id) public view returns (address) {
    return getAddressById(components, id);
  }

  function system(uint256 id) public view returns (address) {
    return getAddressById(systems, id);
  }

  function setUp() public {
    world = deploy.deploy(address(0), address(0), false);
    components = world.components();
    systems = world.systems();
    deployer = deploy.deployer();
    alice = utils.getNextUserAddress();
    bob = utils.getNextUserAddress();
    eve = utils.getNextUserAddress();

    // Initialize components
    positionComponent = PositionComponent(component(PositionComponentID));
    energyComponent = EnergyComponent(component(EnergyComponentID));
    creationBlockComponent = CreationBlockComponent(component(CreationBlockComponentID));
    readyBlockComponent = ReadyBlockComponent(component(ReadyBlockComponentID));
    portableComponent = PortableComponent(component(PortableComponentID));
    carryingCapacityComponent = CarryingCapacityComponent(component(CarryingCapacityComponentID));
    coreComponent = CoreComponent(getAddressById(components, CoreComponentID));
    carriedByComponent = CarriedByComponent(getAddressById(components, CarriedByComponentID));
    matterComponent = MatterComponent(getAddressById(components, MatterComponentID));
    untraversableComponent = UntraversableComponent(getAddressById(components, UntraversableComponentID));
    commitComponent = CommitComponent(getAddressById(components, CommitComponentID));
    burnBlockComponent = BurnBlockComponent(getAddressById(components, BurnBlockComponentID));
    lootComponent = LootComponent(getAddressById(components, LootComponentID));
    abilityMoveComponent = AbilityMoveComponent(getAddressById(components, AbilityMoveComponentID));
    abilityExtractComponent = AbilityExtractComponent(getAddressById(components, AbilityExtractComponentID));
    abilityConsumeComponent = AbilityConsumeComponent(getAddressById(components, AbilityConsumeComponentID));
    abilityPlayComponent = AbilityPlayComponent(getAddressById(components, AbilityPlayComponentID));
    abilityBurnComponent = AbilityBurnComponent(getAddressById(components, AbilityBurnComponentID));

    gameConfig = LibConfig.getGameConfig(components);
  }

  modifier prank(address prankster) {
    vm.startPrank(prankster);
    _;
    vm.stopPrank();
  }
}
