<script lang="ts">
  import { onMount } from "svelte";
  import { bootGame } from "./boot";
  import UIContainer from "./components/UI/UIContainer.svelte";
  import { createComponentSystem, createLoadingStateSystem } from "./systems";
  import { network as networkStore, blockNumber } from "./modules/network";
  import { initActionSequencer } from "./modules/actionSequencer";
  import { initStaticContent } from "./modules/staticContent";
  import { initActionUpdater } from "./modules/actionUpdater";
  import { toastMessage } from "./modules/toast";

  onMount(async () => {
    // App mounted. Start initializing...

    initStaticContent();

    const layers = await bootGame();

    networkStore.set(layers.network);

    // For convenience, we store the block number in a svelte store
    layers.network.network.blockNumber$.subscribe((x) => blockNumber.set(x));

    initActionSequencer();

    initActionUpdater();

    // Create systems to listen to all component changes
    for (const componentKey of Object.keys(layers.network.components)) {
      if (componentKey === "LoadingState") {
        createLoadingStateSystem(layers.network);
      } else {
        createComponentSystem(layers.network, componentKey);
      }
    }
  });

  const testToast = () => {
    if (import.meta.env.DEV) {
      toastMessage({ message: "test", type: "warning", timestamp: performance.now() });
    }
  };
</script>

<svelte:window on:keypress={testToast} />

<main>
  <UIContainer />
</main>
