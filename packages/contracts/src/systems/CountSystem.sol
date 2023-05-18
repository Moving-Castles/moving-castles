// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
import { Counter } from "../codegen/Tables.sol";
import { LibUtils } from "../libraries/Libraries.sol";

contract CountSystem is System {
  function init() public {
    Counter.set(0);
  }

  function count(uint32 _val) public {
    if (_val == Counter.get() + 1) {
      Counter.set(_val);
    } else {
      Counter.set(0);
    }
  }
}
