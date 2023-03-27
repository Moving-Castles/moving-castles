import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineAbilityChatComponent(world: World) {
    return defineComponent(
        world,
        {
            value: Type.Boolean,
        },
        {
            id: "AbilityChat",
            metadata: { contractId: "component.AbilityChat" },
        }
    );
}
