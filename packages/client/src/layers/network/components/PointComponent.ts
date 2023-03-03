import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function definePointComponent(world: World) {
    return defineComponent(
        world,
        {
            value: Type.Number,
        },
        {
            id: "Point",
            metadata: { contractId: "component.Point" },
        }
    );
}
