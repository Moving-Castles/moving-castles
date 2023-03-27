<script lang="ts">
  import { quadOut } from "svelte/easing";
  import { fly, scale } from "svelte/transition";
  import { entities } from "../../modules/entities";
  import { popUpEntity, spawnStage, isSpawned, leaderBoardActive, actionSequencerActive } from "./index";
  // ...
  import Map from "../Map/Map.svelte";
  import UIPane from "./UIPane.svelte";
  import UIBar from "./UIBar.svelte";
  import Leaderboard from "../Leaderboard/Leaderboard.svelte";
  import ActionSequencer from "../ActionSequencer/ActionSequencer.svelte";
  // ---
  import LoadingScreen from "../SpawnSequence/LoadingScreen.svelte";
  import SpawnStart from "../SpawnSequence/SpawnStart.svelte";
  import SpawnCore from "../SpawnSequence/SpawnCore.svelte";
  import SpawnEnergy from "../SpawnSequence/SpawnEnergy.svelte";
  import SpawnBody from "../SpawnSequence/SpawnBody.svelte";
  import SpawnWorld from "../SpawnSequence/SpawnWorld.svelte";
</script>

{#if $isSpawned && Object.values($entities).find((e) => e.goal) && $leaderBoardActive}
  <div class="leaderboard" in:scale={{ duration: 100, easing: quadOut }}>
    <Leaderboard />
  </div>
{/if}

{#if $isSpawned}
  <UIBar />
{/if}

{#if $isSpawned && $actionSequencerActive}
  <div class="action-sequencer" in:scale={{ duration: 100, easing: quadOut }}>
    <ActionSequencer />
  </div>
{/if}

<div class="ui-container">
  {#if $isSpawned}
    <div class="ui-container-inner-map">
      <Map />
    </div>
    {#if $popUpEntity !== ""}
      <div class="ui-container-inner-pane">
        <UIPane />
      </div>
    {/if}
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
    color: white;
    box-sizing: border-box;
    display: flex;

    .ui-container-inner {
      width: 100vw;
      height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: black;
    }

    .ui-container-inner-pane {
      position: fixed;
      right: 40px;
      top: 50px;
      width: 40vw;
      height: 80vh;
      z-index: 10000000;
    }

    .ui-container-inner-map {
      width: 100vw;
      height: 100vh;
      background: red;
    }

    &.extended {
      .ui-container-inner-pane {
        width: 100vw;
      }

      .ui-container-inner-map {
        display: none;
      }
    }
  }

  .leaderboard {
    position: fixed;
    top: 50px;
    left: 10px;
    padding: 10px;
    background: red;
    z-index: 100;
    width: 300px;
  }

  .action-sequencer {
    position: fixed;
    bottom: 20px;
    left: 10px;
    padding: 10px;
    background: red;
    z-index: 100;
    width: 300px;
    max-height: 400px;
    overflow-y: auto;
  }
</style>
