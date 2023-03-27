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
   * Make entity normal Loot
   *
   * @param _components world components
   * @param _entity loot entity
   */
  function makeNormalLoot(IUint256Component _components, uint256 _entity) internal {
    LootComponent lootComponent = LootComponent(getAddressById(_components, LootComponentID));
    lootComponent.set(_entity, 1);
  }

  /**
   * Make entity spawn Loot
   *
   * @param _components world components
   * @param _entity loot entity
   */
  function makeSpawnLoot(IUint256Component _components, uint256 _entity) internal {
    LootComponent lootComponent = LootComponent(getAddressById(_components, LootComponentID));
    lootComponent.set(_entity, 2);
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

    uint32 lootType = lootComponent.getValue(_entity);

    // Remove loot Component from entity
    lootComponent.remove(_entity);

    // Give organ matter
    matterComponent.set(_entity, 30);

    if (lootType == 1) {
      // Normal type loot

      uint256 randomNumber = LibUtils.random(_entity, block.timestamp) % 8;

      // 0    =>  12,5%	  => 	Move
      // 1    =>  12,5%   =>	Consume
      // 2    =>  12,5%   =>	Play
      // 3    =>  12,5%   =>	Chat
      // 4    =>  12,5%   =>	Goal (only once, otherwise blank)
      // 5–7  =>  37,5%   =>	Blank

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

      // 4: Goal or Blank
      if (randomNumber == 4) {
        if (goalComponent.getEntities().length == 0) {
          // Goal
          goalComponent.set(_entity, block.number);
        }
        return true;
      }

      // 5–7: Blank, matter only
      return true;
    } else if (lootType == 2) {
      // Spawn type loot

      uint256 randomNumber = LibUtils.random(_entity, block.timestamp) % 5;

      // 0-1    =>  40%	  => 	Move
      // 2-3    =>  40%   =>	Consume
      // 4      =>  20%   =>	Blank

      // 0: Move
      if (randomNumber == 0 || randomNumber == 1) {
        LibAbility.giveAbility(_components, _entity, AbilityMoveComponentID);
        return true;
      }

      // 1: Consume
      if (randomNumber == 2 || randomNumber == 3) {
        LibAbility.giveAbility(_components, _entity, AbilityConsumeComponentID);
        return true;
      }

      // 4: Blank, matter only
      return true;
    }
  }
}
