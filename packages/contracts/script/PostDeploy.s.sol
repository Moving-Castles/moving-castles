// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "forge-std/Script.sol";
import { IWorld } from "../src/codegen/world/IWorld.sol";
import { GameConfig, GameConfigData } from "../src/codegen/tables/GameConfig.sol";
import { Position, PositionData } from "../src/codegen/tables/Position.sol";
import { Untraversable } from "../src/codegen/tables/Untraversable.sol";
import { Portable } from "../src/codegen/tables/Portable.sol";
import { Loot } from "../src/codegen/tables/Loot.sol";
import { LibUtils } from "../src/libraries/LibUtils.sol";

contract PostDeploy is Script {
  function run(address worldAddress) external {
    console.log("Deployed world: ", worldAddress);
    IWorld world = IWorld(worldAddress);

    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    world.moving_castles_InitSystem_init();

    vm.stopBroadcast();
  }
}
