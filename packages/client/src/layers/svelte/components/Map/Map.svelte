<script lang="ts">
  import { onMount, tick } from "svelte";
  import { playerCore, playerBaseEntity, multiCore, playerAbilities } from "../../modules/player";
  import { gameConfig } from "../../modules/entities";
  import { panzoom } from "../../modules/map";
  import Chat from "../Chat/Chat.svelte";
  import Tile from "./Tile.svelte";
  import { playSound } from "../../../howler";
  import type { GridTile } from "./index";
  import type { Action } from "../../modules/actionSequencer";

  import { activeActions, processedActions } from "../../modules/actionSequencer";

  let activeAction: Action;
  let processedAction: Action;

  function initGrid(unit: number) {
    let grid = [] as GridTile[];
    for (let y = 0; y < unit; y++) {
      for (let x = 0; x < unit; x++) {
        const newGridTile: GridTile = {
          direction: ".",
          coordinates: { x: x, y: y },
          perlinFactor: 0,
          resource: 100,
          id: `${x}-${y}`,
        };
        grid = [...grid, newGridTile];
      }
    }

    return grid;
  }

  let grid: GridTile[] = [];

  async function centerMapOnPlayer() {
    await tick();
    let playerEl = document.getElementsByClassName("player")[0];

    if (playerEl && playerEl.parentElement) {
      let playerTileEl = playerEl.parentElement;
      playerTileEl.scrollIntoView({ block: "center", inline: "center", behavior: "smooth" });
    }
  }

  $: {
    if ($activeActions.length) {
      activeAction = $activeActions[0];
    }
  }

  $: {
    if ($processedActions.length) {
      processedAction = $processedActions[0];
    }
  }

  $: {
    if (activeAction) {
      if (activeAction.systemId.toLowerCase().includes("move")) {
        centerMapOnPlayer();
      }
    }
  }

  $: {
    if (processedAction) {
      console.log(processedAction);
      if (processedAction.systemId.toLowerCase().includes("move")) {
        playSound("walking", "activity");
        centerMapOnPlayer();
      }
    }
  }

  onMount(() => {
    grid = initGrid($gameConfig.worldWidth);
    centerMapOnPlayer();
  });
</script>

<svelte:window on:resize={centerMapOnPlayer} />

{#if $multiCore && $playerAbilities.includes("abilityChat")}
  <Chat channelId={$playerCore.carriedBy} />
{/if}

<div use:panzoom class="ui-map" class:void={!($playerBaseEntity && $playerBaseEntity.position)}>
  <!-- <div class="center-map-button"><button on:click={centerMapOnPlayer}>CENTER</button></div> -->

  <div
    class="map-container"
    style={"width: " +
      ($gameConfig.worldWidth * 400 + 3) +
      "px; height: " +
      ($gameConfig.worldHeight * 400 + 3) +
      "px;"}
  >
    <!-- GRID -->
    {#each grid as tile (`${tile.coordinates.x}-${tile.coordinates.y}`)}
      <Tile {tile} />
    {/each}
  </div>
</div>

<style lang="scss">
  .ui-map {
    height: 100%;
    width: 100%;
    overflow: auto;
    padding: 0;

    &.void {
      filter: grayscale(1);
      opacity: 0.2;
    }

    .center-map-button {
      position: fixed;
      top: 100px;
      left: 10px;
      z-index: 1000;
    }

    .map-container {
      box-sizing: border-box;
      background: rgb(100, 100, 100);
      border: 1px solid white;
      position: relative;
    }
  }
</style>
