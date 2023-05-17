// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";
import { getKeysInTable } from "@latticexyz/world/src/modules/keysintable/getKeysInTable.sol";
import { BodyOne, BodyTwo } from "../constants.sol";
import { CarriedBy, CarriedByTableId } from "../codegen/Tables.sol";

library LibBody {
  function getCarriedByCount(bytes32 _bodyEntity) internal view returns (uint256 count) {
    bytes32[] memory keysWithValue = getKeysWithValue(CarriedByTableId, CarriedBy.encode(_bodyEntity));
    return keysWithValue.length;
  }

  function resetBodies() internal {
    bytes32[][] memory keys = getKeysInTable(CarriedByTableId);
    for (uint256 i = 0; i < keys.length; i++) {
      CarriedBy.deleteRecord(keys[i][0]);
    }
  }
}
