// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { GameConfig, GameConfigData } from "../codegen/tables/GameConfig.sol";
import { Position, PositionTableId, PositionData } from "../codegen/tables/Position.sol";
import { Untraversable } from "../codegen/tables/Untraversable.sol";
import { Portable } from "../codegen/tables/Portable.sol";
import { LibUtils } from "../libraries/LibUtils.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
// import { LibAbility } from "../libraries/LibAbility.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";

library LibMap {
  /**
   * Calculate chebyshev distance
   * https://en.wikipedia.org/wiki/Chebyshev_distance
   *
   * @param _A Coordinate A
   * @param _B Coordinate B
   * @return distance
   */
  function chebyshevDistance(PositionData memory _A, PositionData memory _B) internal pure returns (int32 distance) {
    return LibUtils.max(LibUtils.abs(_A.x - _B.x), LibUtils.abs(_A.y - _B.y));
  }

  /**
   * Check if two coordinates are adjacent
   *
   * @param _A Coordinate A
   * @param _B Coordinate B
   * @return adjacent bool
   */
  function isAdjacent(PositionData memory _A, PositionData memory _B) internal pure returns (bool adjacent) {
    int32 distance = chebyshevDistance(_A, _B);
    if (distance == 0 || distance == 1) return true;
    return false;
  }

  /**
   * Check if within the bounds of the world
   *
   * @param _coordinates position
   * @return withinBounds bool
   */
  function isWithinBounds(PositionData memory _coordinates) internal view returns (bool withinBounds) {
    GameConfigData memory gameConfig = GameConfig.get();
    if (_coordinates.x < 0) return false;
    if (_coordinates.x > gameConfig.worldWidth - 1) return false;
    if (_coordinates.y < 0) return false;
    if (_coordinates.y > gameConfig.worldHeight - 1) return false;
    return true;
  }

  /**
   * Generates random coordinates, within the bounds of the world
   *
   * @return position random coordinates
   */
  function randomCoordinates() internal view returns (PositionData memory position) {
    GameConfigData memory gameConfig = GameConfig.get();

    int32 x = int32(int256(LibUtils.random(666, block.timestamp)) % gameConfig.worldWidth);
    int32 y = int32(int256(LibUtils.random(block.timestamp, block.number)) % gameConfig.worldHeight);

    // Make sure the values are positive
    if (x < 0) x *= -1;
    if (y < 0) y *= -1;

    return PositionData(x, y);
  }

  /**
   * Find a valid spawn location
   *
   * @return position spawn position
   */
  function getSpawnPosition() internal view returns (PositionData memory position) {
    // We try max 20 times...
    uint256 i;
    do {
      PositionData memory spawnPosition = randomCoordinates();
      // Has to be traversable
      if (isUntraversable(spawnPosition) == false) {
        return spawnPosition;
      }
      unchecked {
        i++;
      }
    } while (i < 20);
    // @hack: should check conclusively if there is an open spawn position above, and deny spawn if not
    return PositionData(2, 4);
  }

  /**
   * Check if position is untraversable
   *
   * @param _coordinates position
   * @return untraversable  is untraversable?
   */
  function isUntraversable(PositionData memory _coordinates) internal view returns (bool untraversable) {
    // bytes32[] memory entitiesOnTile = getKeysWithValue(
    //   PositionTableId,
    //   Position.encode({ x: _coordinates.x, y: _coordinates.y })
    // );
    // if (entitiesOnTile.length > 0) return true;
    // All occupied tiles are untraversable
    return false;
  }
}
