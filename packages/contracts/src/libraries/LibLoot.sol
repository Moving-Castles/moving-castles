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
   * @param _components world components
   * @param _entity entity to open
   */
  function openLoot(IUint256Component _components, uint256 _entity) internal returns (bool) {
    LootComponent lootComponent = LootComponent(getAddressById(_components, LootComponentID));
    CarriedByComponent carriedByComponent = CarriedByComponent(getAddressById(_components, CarriedByComponentID));
    PortableComponent portableComponent = PortableComponent(getAddressById(_components, PortableComponentID));
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    GoalComponent goalComponent = GoalComponent(getAddressById(_components, GoalComponentID));

    // Remove loot Component from entity
    lootComponent.remove(_entity);

    uint256 randomNumber = LibUtils.random(_entity, block.timestamp) % 7;

    // 0    =>  10%	  => 	Move
    // 1    =>  10%   =>	Consume
    // 2    =>  10%   =>	Extract
    // 3    =>  10%   =>	Play
    // 4    =>  10%	  =>	Burn
    // 5    =>  10%	  =>	Goal (only once, otherwise SubstanceBlock)
    // 6    =>  10%	  =>	SubstanceBlock
    // XXX 7-9  =>  30%	  => 	Empty

    // 0: Move
    if (randomNumber == 0) {
      LibAbility.giveAbility(_components, _entity, AbilityMoveComponentID);
      return true;
    }

    // 1: Consume
    if (randomNumber == 1) {
      LibAbility.giveAbility(_components, _entity, AbilityConsumeComponentID);
      return true;
    }

    // 2: Extract
    if (randomNumber == 2) {
      LibAbility.giveAbility(_components, _entity, AbilityExtractComponentID);
      return true;
    }

    // 3: Play
    if (randomNumber == 3) {
      LibAbility.giveAbility(_components, _entity, AbilityPlayComponentID);
      return true;
    }

    // 4: Burn
    if (randomNumber == 4) {
      LibAbility.giveAbility(_components, _entity, AbilityBurnComponentID);
      return true;
    }

    // 5: Goal or SubstanceBlock
    if (randomNumber == 5) {
      if (goalComponent.getEntities().length == 0) {
        // Goal
        goalComponent.set(_entity, block.number);
      } else {
        // Substanceblock
        matterComponent.set(_entity, 10);
      }
      return true;
    }

    // 6: Substanceblock
    if (randomNumber == 6) {
      matterComponent.set(_entity, 10);
      return true;
    }

    // 7-9: Empty
    portableComponent.remove(_entity);
    carriedByComponent.remove(_entity);
    return false;
  }
}
