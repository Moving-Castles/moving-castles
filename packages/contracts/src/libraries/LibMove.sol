// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibMap } from "../libraries/LibMap.sol";
import { LibConfig } from "../libraries/LibConfig.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";

import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";

library LibMove {
  /**
   * Check if entity has position
   *
   * @param _components World components
   * @param _entity Entity
   * @return bool does entity have position?
   */
  function hasPosition(IUint256Component _components, uint256 _entity) internal view returns (bool) {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    return positionComponent.has(_entity);
  }

  /**
   * Get position of entity
   *
   * @param _components World components
   * @param _entity Entity
   * @return coord position of entity
   */
  function getPosition(IUint256Component _components, uint256 _entity) internal view returns (Coord memory) {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    return positionComponent.getValue(_entity);
  }

  /**
   * Set position of entity
   *
   * @param _components World components
   * @param _entity Entity
   * @param _coordinates position
   */
  function setPosition(IUint256Component _components, uint256 _entity, Coord memory _coordinates) internal {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    positionComponent.set(_entity, _coordinates);
  }

  /**
   * Remove position of entity
   *
   * @param _components World components
   * @param _entity Entity
   */
  function removePosition(IUint256Component _components, uint256 _entity) internal {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    positionComponent.remove(_entity);
  }

  /**
   * Move one step
   *
   * @param _components World components
   * @param _entity Entity to move
   * @param _targetPosition Position to move to
   */
  function step(IUint256Component _components, uint256 _entity, Coord memory _targetPosition) internal {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    Coord memory currentPosition = positionComponent.getValue(_entity);

    require(LibMap.isWithinBounds(_components, _targetPosition), "LibMove: out of bounds");
    require(LibMap.isAdjacent(currentPosition, _targetPosition), "LibMove: not adjacent");
    require(!LibMap.isUntraversable(_components, _targetPosition), "LibMove: untraversable");

    positionComponent.set(_entity, _targetPosition);
  }
}
