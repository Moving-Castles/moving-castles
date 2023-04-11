<script lang="ts">
  import { loadingMessage } from "../../modules/network"
  import { isSpawned } from "../UI/index"
  import { playerBaseEntity, playerCore } from "../../modules/player"
  import { fade } from "svelte/transition"

  import SpawnSlide from "./SpawnSlide.svelte"

  let started = false

  $: {
    if ($playerCore && $playerBaseEntity) {
      isSpawned.set(true)
    }
  }

  console.log("loading screen")

  // Hide on refresh
  setTimeout(() => {
    started = true
  }, 3000)
</script>

<div class="loading-message">{$loadingMessage}</div>

{#if started}
  <SpawnSlide nextSpawnStage={2} buttonText={"START"}>
    <span slot="text">
      <p>you exist in this darkness</p>
      <p>in the cracks of abandoned buildings,</p>
      <p>in the ruins of decrepit myths...</p>
    </span>
  </SpawnSlide>
{:else}
  <div class="flash" transition:fade={{ delay: 500 }} />
{/if}

<style lang="scss">
  .loading-message {
    position: fixed;
    top: 10px;
    transform: translateX(-50%);
    left: 50%;
    margin-top: 1em;
    opacity: 0.5;
    font-size: 12px;
    z-index: 11;
  }

  .flash {
    position: fixed;
    background: #000;
    inset: 0;
    z-index: 10;
  }
</style>
