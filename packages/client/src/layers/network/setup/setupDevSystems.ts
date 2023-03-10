import type { TxQueue } from "@latticexyz/network";
import type { SystemTypes } from "contracts/types/SystemTypes";
import type { Component, ComponentValue, EntityIndex, Schema, World } from "@latticexyz/recs";

import { defineComponent, Type } from "@latticexyz/recs";
import { keccak256 } from "@latticexyz/utils";
import { BigNumber } from "ethers";

export function setupDevSystems(
  world: World,
  encodersPromise: Promise<Record<string, (value: { [key: string]: unknown }) => string>>,
  systems: TxQueue<SystemTypes>
) {
  const DevHighlightComponent = defineComponent(world, { value: Type.OptionalNumber });

  const HoverHighlightComponent = defineComponent(world, {
    x: Type.OptionalNumber,
    y: Type.OptionalNumber,
  });

  async function setContractComponentValue<T extends Schema>(
    entity: EntityIndex,
    component: Component<T, { contractId: string }>,
    newValue: ComponentValue<T>
  ) {
    if (!component.metadata.contractId)
      throw new Error(
        `Attempted to set the contract value of Component ${component.id} without a deployed contract backing it.`
      );
    const encoders = await encodersPromise;
    const data = encoders[keccak256(component.metadata.contractId)](newValue);
    const entityId = world.entities[entity];
    console.log(`Sent transaction to edit networked Component ${component.id} for Entity ${entityId}`);
    await systems["system.ComponentDev"].executeTyped(
      keccak256(component.metadata.contractId),
      BigNumber.from(entityId),
      data
    );
  }

  return { setContractComponentValue, DevHighlightComponent, HoverHighlightComponent };
}
