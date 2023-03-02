// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibAbility } from "./LibAbility.sol";
import { LibInventory } from "./LibInventory.sol";
import { LibUtils } from "./LibUtils.sol";

import { LootComponent, ID as LootComponentID } from "../components/LootComponent.sol";
import { CarriedByComponent, ID as CarriedByComponentID } from "../components/CarriedByComponent.sol";
import { PortableComponent, ID as PortableComponentID } from "../components/PortableComponent.sol";
import { MatterComponent, ID as MatterComponentID } from "../components/MatterComponent.sol";
import { GoalComponent, ID as GoalComponentID } from "../components/GoalComponent.sol";

import { ID as AbilityConsumeComponentID } from "../components/AbilityConsumeComponent.sol";
import { ID as AbilityMoveComponentID } from "../components/AbilityMoveComponent.sol";
import { ID as AbilityExtractComponentID } from "../components/AbilityExtractComponent.sol";
import { ID as AbilityPlayComponentID } from "../components/AbilityPlayComponent.sol";
import { ID as AbilityBurnComponentID } from "../components/AbilityBurnComponent.sol";

library LibLoot {
  /**
   * Make entity Loot
   *
   * @param _components world components
   * @param _entity loot entity
   */
  function makeLoot(IUint256Component _components, uint256 _entity) internal {
    LootComponent lootComponent = LootComponent(getAddressById(_components, LootComponentID));
    lootComponent.set(_entity);
  }

  /**
   * Check if entity is Loot
   *
   * @param _components world components
   * @param _entity entity to check
   * @return bool is the entity loot?
   */
  function isLoot(IUint256Component _components, uint256 _entity) internal view returns (bool) {
    LootComponent lootComponent = LootComponent(getAddressById(_components, LootComponentID));
    return lootComponent.has(_entity);
  }

  /**
   * Open loot
   *
   * @param _world world
   * @param _components world components
   * @param _entity entity to open
   */
  function openLoot(
    IWorld _world,
    IUint256Component _components,
    uint256 _entity
  ) internal returns (bool) {
    LootComponent lootComponent = LootComponent(getAddressById(_components, LootComponentID));
    CarriedByComponent carriedByComponent = CarriedByComponent(getAddressById(_components, CarriedByComponentID));
    PortableComponent portableComponent = PortableComponent(getAddressById(_components, PortableComponentID));
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    GoalComponent goalComponent = GoalComponent(getAddressById(_components, GoalComponentID));

    uint256 baseEntity = carriedByComponent.getValue(_entity);

    // Remove loot Component
    lootComponent.remove(_entity);
    portableComponent.remove(_entity);
    carriedByComponent.remove(_entity);

    // Create new item
    uint256 resultEntity = _world.getUniqueEntityId();
    portableComponent.set(resultEntity);

    uint256 randomNumber = LibUtils.random(resultEntity, block.timestamp) % 9;

    // 0    =>  10%	  => 	Move
    // 1    =>  10%   =>	Consume
    // 2    =>  10%   =>	Extract
    // 3    =>  10%   =>	Play
    // 4    =>  10%	  =>	Burn
    // 5    =>  10%	  =>	Special (only once, otherwise SubstanceBlock)
    // 6    =>  10%	  =>	SubstanceBlock
    // 7-9  =>  30%	  => 	Empty

    if (randomNumber == 0) {
      // Move
      LibAbility.giveAbility(_components, resultEntity, AbilityMoveComponentID);
    } else if (randomNumber == 1) {
      // Consume
      LibAbility.giveAbility(_components, resultEntity, AbilityConsumeComponentID);
    } else if (randomNumber == 2) {
      // Extract
      LibAbility.giveAbility(_components, resultEntity, AbilityExtractComponentID);
    } else if (randomNumber == 3) {
      // Play
      LibAbility.giveAbility(_components, resultEntity, AbilityPlayComponentID);
    } else if (randomNumber == 4) {
      // Burn
      LibAbility.giveAbility(_components, resultEntity, AbilityBurnComponentID);
    } else if (randomNumber == 5) {
      // @todo: Special
      if (goalComponent.getEntities().length == 0) {
        // Special
        goalComponent.set(resultEntity);
      } else {
        // Substanceblock
        matterComponent.set(resultEntity, 10);
      }
    } else if (randomNumber == 6) {
      // Substanceblock
      matterComponent.set(resultEntity, 10);
    } else {
      return false;
    }

    LibInventory.addToInventory(_components, baseEntity, resultEntity);
    return true;
  }
}
