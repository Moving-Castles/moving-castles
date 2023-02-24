import { defineComponentSystem } from "@latticexyz/recs";
import type { NetworkLayer } from "../../network";
import { ready, loadingMessage } from "../modules/network";

export function createLoadingStateSystem(network: NetworkLayer) {
  const {
    world,
    components: { LoadingState },
  } = network;

  defineComponentSystem(world, LoadingState, (update) => {
    console.log("==> LoadingState system: ", update.value[0]);
    loadingMessage.set(update.value[0]?.msg + ": " + update.value[0]?.percentage.toFixed(2));
    if (update.value[0]?.state === 2) ready.set(true);
  });
}
