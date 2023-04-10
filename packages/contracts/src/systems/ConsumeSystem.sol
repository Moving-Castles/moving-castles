// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
// ...
import { CarriedBy } from "../codegen/tables/CarriedBy.sol";
import { AbilityConsumeTableId } from "../codegen/tables/AbilityConsume.sol";
import { Matter } from "../codegen/tables/Matter.sol";
import { Portable } from "../codegen/tables/Portable.sol";
// ...
import { LibCore } from "../libraries/LibCore.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibConsumable } from "../libraries/LibConsumable.sol";
import { LibAbility } from "../libraries/LibAbility.sol";
import { LibUtils } from "../libraries/LibUtils.sol";

contract ConsumeSystem is System {
  function consume(bytes32 _consumableEntity) public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());

    require(LibCore.isSpawned(coreEntity), "ConsumeSystem: entity does not exist");
    require(LibCore.isReady(coreEntity), "ConsumeSystem: entity is in cooldown");
    require(!LibCore.isCommitted(coreEntity), "ConsumeSystem: entity is committed");

    bytes32 baseEntity = CarriedBy.get(coreEntity);

    require(CarriedBy.get(_consumableEntity) == baseEntity, "ConsumeSystem: not carried");

    uint32 abilityCount = LibAbility.checkInventoryForAbility(AbilityConsumeTableId, baseEntity);
    require(abilityCount > 0, "ConsumeSystem: no item with AbilityConsume");

    require(Matter.get(_consumableEntity) > 0, "ConsumeSystem: not consumable");

    uint32 energy = LibConsumable.convertToEnergy(_consumableEntity, abilityCount);
    LibCore.increaseEnergy(coreEntity, energy);

    LibInventory.removeFromInventory(_consumableEntity);
    Matter.deleteRecord(_consumableEntity);
    Portable.deleteRecord(_consumableEntity);
  }
}
