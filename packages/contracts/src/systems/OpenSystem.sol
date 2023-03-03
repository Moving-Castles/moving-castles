// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibCore } from "../libraries/LibCore.sol";
import { LibLoot } from "../libraries/LibLoot.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibConfig } from "../libraries/LibConfig.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";

uint256 constant ID = uint256(keccak256("system.Open"));

contract OpenSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint256 _lootEntity = abi.decode(arguments, (uint256));
    uint256 coreEntity = addressToEntity(msg.sender);

    GameConfig memory gameConfig = LibConfig.getGameConfig(components);

    require(LibCore.isSpawned(components, coreEntity), "OpenSystem: entity does not exist");
    require(LibCore.isReady(components, coreEntity), "OpenSystem: entity is in cooldown");
    require(!LibCore.isCommitted(components, coreEntity), "OpenSystem: entity is committed");
    require(LibCore.checkEnergy(components, coreEntity, gameConfig.openCost), "OpenSystem: not enough energy");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);

    require(LibInventory.isCarriedBy(components, _lootEntity, baseEntity), "OpenSystem: not carried");

    require(LibLoot.isLoot(components, _lootEntity), "OpenSystem: not loot");

    LibLoot.openLoot(world, components, _lootEntity);

    LibCore.decreaseEnergy(components, coreEntity, gameConfig.openCost);
  }

  function executeTyped(uint256 _lootEntity) public returns (bytes memory) {
    return execute(abi.encode(_lootEntity));
  }
}
