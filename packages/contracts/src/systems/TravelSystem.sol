// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
import { RealmId } from "../codegen/Tables.sol";
import { LibUtils } from "../libraries/Libraries.sol";

contract TravelSystem is System {
  function travel(uint256 realmId) public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());
    // If you are not in realm 0 (the void), you can only return to realm 0
    require(realmId == 0 || RealmId.get(coreEntity) == 0, "must be in realm 0");
    // @todo: Require 100 energy
    // @todo: Subtract 100 energy
    RealmId.set(coreEntity, realmId);
  }
}
