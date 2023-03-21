// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibCore } from "../libraries/LibCore.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibConsumable } from "../libraries/LibConsumable.sol";
import { LibAbility } from "../libraries/LibAbility.sol";

import { ID as AbilityConsumeComponentID } from "../components/AbilityConsumeComponent.sol";

uint256 constant ID = uint256(keccak256("system.Consume"));

contract ConsumeSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint256 _consumableEntity = abi.decode(arguments, (uint256));
    uint256 coreEntity = addressToEntity(msg.sender);

    require(LibCore.isSpawned(components, coreEntity), "ConsumeSystem: entity does not exist");
    require(LibCore.isReady(components, coreEntity), "ConsumeSystem: entity is in cooldown");
    require(!LibCore.isCommitted(components, coreEntity), "ConsumeSystem: entity is committed");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);

    require(LibInventory.isCarriedBy(components, _consumableEntity, baseEntity), "ConsumeSystem: not carried");

    uint32 abilityCount = LibAbility.checkInventoryForAbility(components, baseEntity, AbilityConsumeComponentID);
    require(abilityCount > 0, "ConsumeSystem: no item with AbilityConsume");

    require(LibConsumable.isConsumable(components, _consumableEntity), "ConsumeSystem: not consumable");

    uint32 energy = LibConsumable.convertToEnergy(components, _consumableEntity, abilityCount);
    LibCore.increaseEnergy(components, coreEntity, energy);

    LibInventory.removeFromInventory(components, _consumableEntity);
    LibConsumable.destroy(components, _consumableEntity);
  }

  function executeTyped(uint256 _consumableEntity) public returns (bytes memory) {
    return execute(abi.encode(_consumableEntity));
  }
}
