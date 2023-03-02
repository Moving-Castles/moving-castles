import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineLootComponent(world: World) {
    return defineComponent(
        world,
        {
            value: Type.Boolean,
        },
        {
            id: "Loot",
            metadata: { contractId: "component.Loot" },
        }
    );
}
