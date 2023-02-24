// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.17;
import "solecs/BareComponent.sol";

uint256 constant ID = uint256(keccak256("component.GameConfig"));

struct GameConfig {
  int32 worldHeight;
  int32 worldWidth;
  uint32 initialEnergy;
  uint32 matterPerTile;
  uint32 defaultCarryingCapacity;
  uint32 moveCost;
  uint32 extractCost;
  uint32 pickUpCost;
  uint32 dropCost;
  uint32 transferCost;
  uint32 playCost;
  uint32 burnCost;
  uint32 moveCooldown;
  uint32 extractCooldown;
  uint32 burnTime;
}

contract GameConfigComponent is BareComponent {
  constructor(address world) BareComponent(world, ID) {}

  function getSchema() public pure override returns (string[] memory keys, LibTypes.SchemaValue[] memory values) {
    keys = new string[](15);
    values = new LibTypes.SchemaValue[](15);

    keys[0] = "worldHeight";
    values[0] = LibTypes.SchemaValue.INT32;

    keys[1] = "worldWidth";
    values[1] = LibTypes.SchemaValue.INT32;

    keys[2] = "initialEnergy";
    values[2] = LibTypes.SchemaValue.UINT32;

    keys[3] = "matterPerTile";
    values[3] = LibTypes.SchemaValue.UINT32;

    keys[4] = "defaultCarryingCapacity";
    values[4] = LibTypes.SchemaValue.UINT32;

    keys[5] = "moveCost";
    values[5] = LibTypes.SchemaValue.UINT32;

    keys[6] = "extractCost";
    values[6] = LibTypes.SchemaValue.UINT32;

    keys[7] = "pickUpCost";
    values[7] = LibTypes.SchemaValue.UINT32;

    keys[8] = "dropCost";
    values[8] = LibTypes.SchemaValue.UINT32;

    keys[9] = "transferCost";
    values[9] = LibTypes.SchemaValue.UINT32;

    keys[10] = "playCost";
    values[10] = LibTypes.SchemaValue.UINT32;

    keys[11] = "burnCost";
    values[11] = LibTypes.SchemaValue.UINT32;

    keys[12] = "moveCooldown";
    values[12] = LibTypes.SchemaValue.UINT32;

    keys[13] = "extractCooldown";
    values[13] = LibTypes.SchemaValue.UINT32;

    keys[14] = "burnTime";
    values[14] = LibTypes.SchemaValue.UINT32;
  }

  function set(uint256 entity, GameConfig memory gameConfig) public {
    set(entity, abi.encode(gameConfig));
  }

  function getValue(uint256 entity) public view returns (GameConfig memory) {
    GameConfig memory gameConfig = abi.decode(getRawValue(entity), (GameConfig));
    return gameConfig;
  }
}
