// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
import { Core, Points, ReadyBlock, Energy, CarriedBy } from "../codegen/Tables.sol";
import { LibUtils } from "../libraries/Libraries.sol";

contract SpawnSystem is System {
  function spawn() public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());
    require(!Core.get(coreEntity), "already spawned");
    Core.set(coreEntity, true);
    ReadyBlock.set(coreEntity, block.number);
    Energy.set(coreEntity, 0);
    Points.set(coreEntity, 0);
  }
}
