<script lang="ts">
  import { onMount } from "svelte"
  import { setup } from "../mud/setup"
  import { createComponentSystem, createLoadingStateSystem } from "./systems"
  import { network, ready, blockNumber } from "./modules/network"
  import { playerCore } from "./modules/player"
  import { initStaticContent } from "./modules/staticContent"
  import { initActionSequencer } from "./modules/actionSequencer"
  import { initActionUpdater } from "./modules/actionUpdater"

  import Loading from "./components/Loading/Loading.svelte"
  import Spawn from "./components/Spawn/Spawn.svelte"
  import Void from "./components/Void/Void.svelte"

  // - - - - -
  import { entities } from "./modules/entities"
  $: console.log("$entities", $entities)
  $: console.log("$network", $network)
  $: console.log($playerCore)
  // - - - - -

  onMount(async () => {
    // App mounted. Start initializing...
    initStaticContent()
    const mudLayer = await setup()
    network.set(mudLayer)
    initActionSequencer()
    initActionUpdater()

    // Create systems to listen to changes to defined component
    for (const componentKey of Object.keys(mudLayer.contractComponents)) {
      createComponentSystem(componentKey)
    }

    // Listen to changes to the LoadingState component
    createLoadingStateSystem()

    // For convenience, we store the block number in a svelte store
    mudLayer.network.blockNumber$.subscribe((x: number) => blockNumber.set(x))
  })
</script>

<main>
  {#if !$ready}
    <Loading />
  {/if}
  {#if $ready}
    {#if !$playerCore}
      <Spawn />
    {:else}
      <Void />
    {/if}
  {/if}
</main>
