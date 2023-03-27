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
import { MatterComponent, ID as MatterComponentID } from "../components/MatterComponent.sol";
import { GoalComponent, ID as GoalComponentID } from "../components/GoalComponent.sol";

import { ID as AbilityMoveComponentID } from "../components/AbilityMoveComponent.sol";
import { ID as AbilityConsumeComponentID } from "../components/AbilityConsumeComponent.sol";
import { ID as AbilityPlayComponentID } from "../components/AbilityPlayComponent.sol";
import { ID as AbilityChatComponentID } from "../components/AbilityChatComponent.sol";

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
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    GoalComponent goalComponent = GoalComponent(getAddressById(_components, GoalComponentID));

    // Remove loot Component from entity
    lootComponent.remove(_entity);

    // Give organ matter
    matterComponent.set(_entity, 30);

    uint256 randomNumber = LibUtils.random(_entity, block.timestamp) % 5;

    // 0    =>  20%	  => 	Move
    // 1    =>  20%   =>	Consume
    // 2    =>  20%   =>	Play
    // 3    =>  20%   =>	Chat
    // 4    =>  20%   =>	Goal (only once, otherwise Movek)

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

    // 2: Play
    if (randomNumber == 2) {
      LibAbility.giveAbility(_components, _entity, AbilityPlayComponentID);
      return true;
    }

    // 3: Chat
    if (randomNumber == 3) {
      LibAbility.giveAbility(_components, _entity, AbilityChatComponentID);
      return true;
    }

    // 4: Goal or Move
    if (randomNumber == 4) {
      if (goalComponent.getEntities().length == 0) {
        // Goal
        goalComponent.set(_entity, block.number);
      } else {
        LibAbility.giveAbility(_components, _entity, AbilityMoveComponentID);
      }
      return true;
    }
  }
}
