// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { PointComponent, ID as PointComponentID } from "../components/PointComponent.sol";
import { GoalComponent, ID as GoalComponentID } from "../components/GoalComponent.sol";

library LibGoal {
  /**
   * Get goal entity
   *
   * @param _components World components
   * @return uint256 goal entity
   */
  function getGoalEntity(IUint256Component _components) internal view returns (uint256) {
    GoalComponent goalComponent = GoalComponent(getAddressById(_components, GoalComponentID));
    return goalComponent.getEntities().length == 0 ? 0 : goalComponent.getEntities()[0];
  }

  /**
   * Check if entity is goal
   *
   * @param _components World components
   * @param _entity entity to check
   * @return bool is the entity a goal?
   */
  function isGoal(IUint256Component _components, uint256 _entity) internal view returns (bool) {
    GoalComponent goalComponent = GoalComponent(getAddressById(_components, GoalComponentID));
    return goalComponent.has(_entity);
  }

  /**
   * Get points
   *
   * @param _components World components
   * @return uint32 points
   */
  function getPoints(IUint256Component _components) internal view returns (uint256) {
    GoalComponent goalComponent = GoalComponent(getAddressById(_components, GoalComponentID));
    return block.number - goalComponent.getValue(getGoalEntity(_components));
  }

  /**
   * Get goal value
   *
   * @param _components World components
   * @return uint256 goal value
   */
  function getGoalValue(IUint256Component _components) internal view returns (uint256) {
    GoalComponent goalComponent = GoalComponent(getAddressById(_components, GoalComponentID));
    return goalComponent.getValue(getGoalEntity(_components));
  }

  /**
   * Set goal value
   *
   * @param _components World components
   * @param _goalValue goal value
   */
  function setGoalValue(IUint256Component _components, uint256 _goalValue) internal {
    GoalComponent goalComponent = GoalComponent(getAddressById(_components, GoalComponentID));
    goalComponent.set(getGoalEntity(_components), _goalValue);
  }
}
