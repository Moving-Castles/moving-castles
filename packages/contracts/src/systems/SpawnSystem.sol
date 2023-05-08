// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
import { Core, Portable, ReadyBlock, Energy, CreationBlock, Avatar, Name, RealmId, CarriedBy } from "../codegen/Tables.sol";
import { LibUtils } from "../libraries/Libraries.sol";

contract SpawnSystem is System {
  function spawn() public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());

    require(!Core.get(coreEntity), "already spawned");

    Core.set(coreEntity, true);
    CreationBlock.set(coreEntity, block.number);
    ReadyBlock.set(coreEntity, block.number);
    Energy.set(coreEntity, 0);
    Portable.set(coreEntity, true);
    Avatar.set(coreEntity, 0);
    Name.set(coreEntity, "Player1");
    RealmId.set(coreEntity, 0);
    CarriedBy.set(coreEntity, 0);
  }
}
