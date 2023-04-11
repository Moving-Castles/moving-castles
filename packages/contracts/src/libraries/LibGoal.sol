// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { Point } from "../codegen/tables/Point.sol";
import { Goal, GoalTableId } from "../codegen/tables/Goal.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";
import { GoalKey } from "../utils/constants.sol";

library LibGoal {
  /**
   * Get points
   *
   * @return uint32 points
   */
  function getPoints() internal view returns (uint256) {
    return block.number - Goal.get(GoalKey);
  }

  /**
   * Set goal value
   *
   * @param _goalValue goal value
   */
  function setGoalValue(uint256 _goalValue) internal {
    Goal.set(GoalKey, _goalValue);
  }
}
