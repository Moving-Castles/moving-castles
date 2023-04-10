// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { GameConfig, GameConfigData } from "../codegen/tables/GameConfig.sol";
import { Loot } from "../codegen/tables/Loot.sol";
import { AbilityMove } from "../codegen/tables/AbilityMove.sol";
import { AbilityPlay } from "../codegen/tables/AbilityPlay.sol";
import { AbilityConsume } from "../codegen/tables/AbilityConsume.sol";
import { AbilityChat } from "../codegen/tables/AbilityChat.sol";
import { Matter } from "../codegen/tables/Matter.sol";
import { CarriedBy } from "../codegen/tables/CarriedBy.sol";
import { Portable } from "../codegen/tables/Portable.sol";
import { Goal } from "../codegen/tables/Goal.sol";
// ...
import { LibUtils } from "./LibUtils.sol";
// ...
import { GoalKey } from "../utils/constants.sol";

library LibLoot {
  /**
   * Open loot
   *
   * @param _entity entity to open
   */
  function open(bytes32 _entity) internal returns (bool success) {
    GameConfigData memory gameConfig = GameConfig.get();

    uint32 lootType = Loot.get(_entity);

    // Remove loot Component from entity
    Loot.deleteRecord(_entity);

    // Give organ matter
    Matter.set(_entity, gameConfig.organMatter);

    if (lootType == 1) {
      // Normal type loot

      uint256 randomNumber = LibUtils.random(uint256(_entity), block.timestamp) % 8;

      // 0    =>  12,5%	  => 	Move
      // 1    =>  12,5%   =>	Consume
      // 2    =>  12,5%   =>	Play
      // 3    =>  12,5%   =>	Chat
      // 4    =>  12,5%   =>	Goal (only once, otherwise blank)
      // 5–7  =>  37,5%   =>	Blank

      // 0: Move
      if (randomNumber == 0) {
        AbilityMove.set(_entity, true);
        return true;
      }

      // 1: Consume
      if (randomNumber == 1) {
        AbilityConsume.set(_entity, true);
        return true;
      }

      // 2: Play
      if (randomNumber == 2) {
        AbilityPlay.set(_entity, true);
        return true;
      }

      // 3: Chat
      if (randomNumber == 3) {
        AbilityChat.set(_entity, true);
        return true;
      }

      // 4: Goal or Blank
      if (randomNumber == 4) {
        if (Goal.get(GoalKey) == 0) {
          // Goal
          // @todo: redo goal system...
          Portable.deleteRecord(_entity);
          CarriedBy.deleteRecord(_entity);
          Goal.set(GoalKey, block.number);
          Portable.set(GoalKey, true);
          CarriedBy.set(GoalKey, _entity);
        }
        return true;
      }

      // 5–7: Blank, matter only
      return true;
    } else if (lootType == 2) {
      // Spawn type loot

      uint256 randomNumber = LibUtils.random(uint256(_entity), block.timestamp) % 5;

      // 0-1    =>  40%	  => 	Move
      // 2-3    =>  40%   =>	Consume
      // 4      =>  20%   =>	Blank

      // 0: Move
      if (randomNumber == 0 || randomNumber == 1) {
        AbilityMove.set(_entity, true);
        return true;
      }

      // 1: Consume
      if (randomNumber == 2 || randomNumber == 3) {
        AbilityConsume.set(_entity, true);
        return true;
      }

      // 4: Blank, matter only
      return true;
    }
  }
}
