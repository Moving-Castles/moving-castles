/* Autogenerated file. Do not edit manually. */

import { TableId } from "@latticexyz/utils";
import { defineComponent, Type as RecsType, World } from "@latticexyz/recs";

export function defineContractComponents(world: World) {
  return {
    AbilityChat: (() => {
      const tableId = new TableId("moving_castles", "AbilityChat");
      return defineComponent(
        world,
        {
          value: RecsType.Boolean,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    AbilityConsume: (() => {
      const tableId = new TableId("moving_castles", "AbilityConsume");
      return defineComponent(
        world,
        {
          value: RecsType.Boolean,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    AbilityMove: (() => {
      const tableId = new TableId("moving_castles", "AbilityMove");
      return defineComponent(
        world,
        {
          value: RecsType.Boolean,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    AbilityPlay: (() => {
      const tableId = new TableId("moving_castles", "AbilityPlay");
      return defineComponent(
        world,
        {
          value: RecsType.Boolean,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    CarriedBy: (() => {
      const tableId = new TableId("moving_castles", "CarriedBy");
      return defineComponent(
        world,
        {
          value: RecsType.String,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    CarryingCapacity: (() => {
      const tableId = new TableId("moving_castles", "CarryingCapacity");
      return defineComponent(
        world,
        {
          value: RecsType.Number,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    Commit: (() => {
      const tableId = new TableId("moving_castles", "Commit");
      return defineComponent(
        world,
        {
          value: RecsType.BigInt,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    Core: (() => {
      const tableId = new TableId("moving_castles", "Core");
      return defineComponent(
        world,
        {
          value: RecsType.Boolean,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    CreationBlock: (() => {
      const tableId = new TableId("moving_castles", "CreationBlock");
      return defineComponent(
        world,
        {
          value: RecsType.BigInt,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    Energy: (() => {
      const tableId = new TableId("moving_castles", "Energy");
      return defineComponent(
        world,
        {
          value: RecsType.Number,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    GameConfig: (() => {
      const tableId = new TableId("moving_castles", "GameConfig");
      return defineComponent(
        world,
        {
          worldHeight: RecsType.Number,
          worldWidth: RecsType.Number,
          initialEnergy: RecsType.Number,
          defaultCarryingCapacity: RecsType.Number,
          moveCost: RecsType.Number,
          pickUpCost: RecsType.Number,
          dropCost: RecsType.Number,
          transferCost: RecsType.Number,
          playCost: RecsType.Number,
          moveCooldown: RecsType.Number,
          openCost: RecsType.Number,
          harvestCost: RecsType.Number,
          organMatter: RecsType.Number,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    Goal: (() => {
      const tableId = new TableId("moving_castles", "Goal");
      return defineComponent(
        world,
        {
          value: RecsType.BigInt,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    Loot: (() => {
      const tableId = new TableId("moving_castles", "Loot");
      return defineComponent(
        world,
        {
          value: RecsType.Number,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    Matter: (() => {
      const tableId = new TableId("moving_castles", "Matter");
      return defineComponent(
        world,
        {
          value: RecsType.Number,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    Point: (() => {
      const tableId = new TableId("moving_castles", "Point");
      return defineComponent(
        world,
        {
          value: RecsType.BigInt,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    Portable: (() => {
      const tableId = new TableId("moving_castles", "Portable");
      return defineComponent(
        world,
        {
          value: RecsType.Boolean,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    Position: (() => {
      const tableId = new TableId("moving_castles", "Position");
      return defineComponent(
        world,
        {
          x: RecsType.Number,
          y: RecsType.Number,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    ReadyBlock: (() => {
      const tableId = new TableId("moving_castles", "ReadyBlock");
      return defineComponent(
        world,
        {
          value: RecsType.BigInt,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    Untraversable: (() => {
      const tableId = new TableId("moving_castles", "Untraversable");
      return defineComponent(
        world,
        {
          value: RecsType.Boolean,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
  };
}
