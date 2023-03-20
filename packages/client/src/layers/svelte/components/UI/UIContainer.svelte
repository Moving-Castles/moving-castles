<script lang="ts">
  import { onMount } from "svelte";
  import { entities } from "../../modules/entities";
  import { ready } from "../../modules/network";
  import { playerBaseEntity, playerCore } from "../../modules/player";
  import { uiState, castleExtended, spawnStage } from "./index";
  // ...
  import UIComponent from "./../SpawnSequence/LoadingScreen.svelte";
  import Map from "../Map/Map.svelte";
  import UIPane from "./UIPane.svelte";
  import Leaderboard from "../Leaderboard/Leaderboard.svelte";
  // ---
  import LoadingScreen from "../SpawnSequence/LoadingScreen.svelte";
  import SpawnStart from "../SpawnSequence/SpawnStart.svelte";
  import SpawnCore from "../SpawnSequence/SpawnCore.svelte";
  import SpawnEnergy from "../SpawnSequence/SpawnEnergy.svelte";
  import SpawnBody from "../SpawnSequence/SpawnBody.svelte";
  import SpawnWorld from "../SpawnSequence/SpawnWorld.svelte";

  onMount(async () => {
    if ($playerCore && $playerBaseEntity) {
      spawnStage.set(100);
    }
  });
</script>

{#if $spawnStage == 100 && Object.values($entities).find((e) => e.goal)}
  <div class="leaderboard">
    <Leaderboard />
  </div>
{/if}

<div class="ui-container" class:extended={$castleExtended}>
  {#if $playerCore && $playerBaseEntity && $spawnStage == 100}
    <div class="ui-container-inner-map">
      <Map />
    </div>
    <div class="ui-container-inner-pane">
      <UIPane />
    </div>
  {:else}
    <div class="ui-container-inner">
      {#if $spawnStage === 1}
        <LoadingScreen />
      {:else if $spawnStage === 2}
        <SpawnStart />
      {:else if $spawnStage === 3}
        <SpawnCore />
      {:else if $spawnStage === 4}
        <SpawnEnergy />
      {:else if $spawnStage === 5}
        <SpawnBody />
      {:else if $spawnStage === 6}
        <SpawnWorld />
      {/if}
    </div>
  {/if}
</div>

<style lang="scss">
  .ui-container {
    position: fixed;
    left: 0;
    top: 0;
    width: 100vw;
    height: 100vh;
    color: var(--foreground);
    box-sizing: border-box;
    display: flex;
  }

  .ui-container-inner {
    width: 100vw;
    height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: orangered;
  }

  .ui-container-inner-pane {
    width: 40vw;
    height: 100vh;
    background: blue;
  }

  .ui-container-inner-map {
    width: 60vw;
    height: 100vh;
    background: red;
  }

  .extended .ui-container-inner-pane {
    width: 100vw;
  }

  .extended .ui-container-inner-map {
    display: none;
  }

  .leaderboard {
    position: fixed;
    top: 10px;
    right: calc(40vw + 10px);
    padding: 10px;
    background: red;
    z-index: 100;
  }
</style>
