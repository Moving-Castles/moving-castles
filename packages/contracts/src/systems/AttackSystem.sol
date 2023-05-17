// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
import { Health, CarriedBy } from "../codegen/Tables.sol";
import { LibUtils } from "../libraries/Libraries.sol";
import { BodyOne, BodyTwo } from "../constants.sol";

contract AttackSystem is System {
  function attack() public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());
    require(CarriedBy.get(coreEntity) == BodyOne || CarriedBy.get(coreEntity) == BodyTwo, "not carried by body");
    bytes32 targetBody = CarriedBy.get(coreEntity) == BodyOne ? BodyTwo : BodyOne;
    Health.set(targetBody, Health.get(targetBody) - 20);
  }
}
