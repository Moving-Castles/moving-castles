// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibConfig } from "./LibConfig.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";

import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";
import { MatterComponent, ID as MatterComponentID } from "../components/MatterComponent.sol";
import { PortableComponent, ID as PortableComponentID } from "../components/PortableComponent.sol";

library LibConsumable {
  /**
   * Create a consumable entity
   *
   * @param _components World components
   * @param _consumableEntity entity
   * @param _coordinates coord
   * @param _amount Matter
   */
  function create(
    IUint256Component _components,
    uint256 _consumableEntity,
    Coord memory _coordinates,
    uint32 _amount
  ) internal {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    PortableComponent portableComponent = PortableComponent(getAddressById(_components, PortableComponentID));

    positionComponent.set(_consumableEntity, _coordinates);
    matterComponent.set(_consumableEntity, _amount);
    portableComponent.set(_consumableEntity);
  }

  /**
   * Destroy a consumable entity
   *
   * @param _components World components
   * @param _consumableEntity entity
   */
  function destroy(IUint256Component _components, uint256 _consumableEntity) internal {
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    PortableComponent portableComponent = PortableComponent(getAddressById(_components, PortableComponentID));

    matterComponent.remove(_consumableEntity);
    portableComponent.remove(_consumableEntity);
  }

  /**
   * Is entity consumable
   *
   * @param _components World components
   * @param _entity entity
   * @return bool is entity consumable?
   */
  function isConsumable(IUint256Component _components, uint256 _entity) internal view returns (bool) {
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    return matterComponent.has(_entity);
  }

  /**
   * Convert substance block to energy
   *
   * @param _components World components
   * @param _consumableEntity entity
   * @param _abilityCount number of items giving the consume ability
   * @return unsigned energy value
   */
  function convertToEnergy(
    IUint256Component _components,
    uint256 _consumableEntity,
    uint32 _abilityCount
  ) internal view returns (uint32) {
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    uint32 energy = matterComponent.getValue(_consumableEntity);
    // Give more energy if entity has more than one "consume organ"
    return energy * (2 * _abilityCount);
  }
}
