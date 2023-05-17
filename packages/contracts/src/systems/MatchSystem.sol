// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
import { Health, Active } from "../codegen/Tables.sol";
import { LibUtils, LibBody } from "../libraries/Libraries.sol";
import { MatchKey, BodyOne, BodyTwo } from "../constants.sol";

contract MatchSystem is System {
  function init() public {
    // TODO: restrict this
    Active.set(MatchKey, false);
    Health.set(BodyOne, 100);
    Health.set(BodyTwo, 100);
  }

  function start() public {
    require(Active.get(MatchKey) == false, "match already active");
    require(LibBody.getCarriedByCount(BodyOne) == 1 || LibBody.getCarriedByCount(BodyTwo) == 1, "not enough players");
    Active.set(MatchKey, true);
    Health.set(BodyOne, 100);
    Health.set(BodyTwo, 100);
  }

  function end() public {
    require(Active.get(MatchKey) == true, "match already ended");
    require(Health.get(BodyOne) == 0 || Health.get(BodyTwo) == 0, "no winner");
    Active.set(MatchKey, false);
    // LibBody.resetBodies();
  }
}
