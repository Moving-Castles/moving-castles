<script lang="ts">
  import { onMount } from "svelte"
  import { setup } from "../mud/setup"
  import { entities } from "./modules/entities"
  import { createComponentSystem, createLoadingStateSystem } from "./systems"
  import UIContainer from "./components/UI/UIContainer.svelte"
  import { network, blockNumber } from "./modules/network"
  import { initStaticContent } from "./modules/staticContent"
  import { initActionSequencer } from "./modules/actionSequencer"
  import { initActionUpdater } from "./modules/actionUpdater"

  $: console.log("$entities", $entities)
  $: console.log("$network", $network)

  onMount(async () => {
    // App mounted. Start initializing...

    initStaticContent()

    const mudLayer = await setup()
    network.set(mudLayer)

    initActionSequencer()

    initActionUpdater()

    // Create systems to listen to all component changes
    for (const componentKey of Object.keys(mudLayer.components)) {
      if (componentKey === "LoadingState") {
        createLoadingStateSystem()
      } else {
        createComponentSystem(componentKey)
      }
    }

    // For convenience, we store the block number in a svelte store
    mudLayer.network.blockNumber$.subscribe(x => blockNumber.set(x))
  })
</script>

<main>
  <UIContainer />
</main>
