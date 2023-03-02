import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineGoalComponent(world: World) {
    return defineComponent(
        world,
        {
            value: Type.Boolean,
        },
        {
            id: "Goal",
            metadata: { contractId: "component.Goal" },
        }
    );
}
