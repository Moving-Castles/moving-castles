import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineGameConfigComponent(world: World) {
  return defineComponent(
    world,
    {
      worldHeight: Type.Number,
      worldWidth: Type.Number,
      initialEnergy: Type.Number,
      defaultCarryingCapacity: Type.Number,
      moveCost: Type.Number,
      pickUpCost: Type.Number,
      dropCost: Type.Number,
      transferCost: Type.Number,
      playCost: Type.Number,
      moveCooldown: Type.Number,
      openCost: Type.Number,
      harvestCost: Type.Number,
      organMatter: Type.Number
    },
    {
      id: "GameConfig",
      metadata: { contractId: "component.GameConfig" },
    }
  );
}
