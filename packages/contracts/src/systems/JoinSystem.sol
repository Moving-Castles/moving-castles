// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
import { CarriedBy } from "../codegen/Tables.sol";
import { LibUtils, LibBody } from "../libraries/Libraries.sol";
import { BodyOne, BodyTwo } from "../constants.sol";

contract JoinSystem is System {
  function join(uint32 _bodyIndex) public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());
    require(CarriedBy.get(coreEntity) == 0, "already carried");
    require(_bodyIndex == 1 || _bodyIndex == 2, "invalid body");
    bytes32 bodyEntity = _bodyIndex == 1 ? BodyOne : BodyTwo;
    require(LibBody.getCarriedByCount(bodyEntity) == 0, "body is full");
    CarriedBy.set(coreEntity, bodyEntity);
  }
}
