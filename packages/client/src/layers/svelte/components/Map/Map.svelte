<script lang="ts">
  import type { Coord } from "@latticexyz/utils";
  import { onMount } from "svelte";
  import { playerCore, playerBaseEntity, multiCore } from "../../modules/player";
  import { gameConfig } from "../../modules/entities";
  import { panzoom } from "../../modules/map";

  import TileInteract from "./TileInteract.svelte";
  import DebugChat from "../Chat/Chat.svelte";
  import Tile from "./Tile.svelte";

  let selectedTileCoords: Coord;
  let tileInteractActive = false;
  interface GridTile {
    direction: string;
    coordinates: Coord;
    perlinFactor: number;
    resource: number;
  }

  function initGrid(unit: number) {
    let grid = [] as GridTile[];
    for (let y = 0; y < unit; y++) {
      for (let x = 0; x < unit; x++) {
        const newGridTile: GridTile = {
          direction: ".",
          coordinates: { x: x, y: y },
          perlinFactor: 0,
          resource: 100,
        };
        grid = [...grid, newGridTile];
      }
    }

    return grid;
  }

  let grid: GridTile[] = [];

  onMount(() => {
    grid = initGrid($gameConfig.worldWidth);
    centerMapOnPlayer();
    console.log("mounted");
  });

  function centerMapOnPlayer() {
    let playerEl = document.getElementsByClassName("player")[0];

    if (playerEl && playerEl.parentElement) {
      let playerTileEl = playerEl.parentElement;
      playerTileEl.scrollIntoView({ block: "center", inline: "center" });
    }
  }
</script>

{#if tileInteractActive}
  <TileInteract
    {selectedTileCoords}
    on:close={() => {
      tileInteractActive = false;
    }}
  />
{/if}

{#if $multiCore}
  <DebugChat channelId={$playerCore.carriedBy} />
{/if}

<div use:panzoom class="ui-map" class:void={!($playerBaseEntity && $playerBaseEntity.position)}>
  <div class="center-map-button"><button on:click={centerMapOnPlayer}>CENTER</button></div>

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
      <Tile
        {tile}
        on:interact={(e) => {
          selectedTileCoords = e.detail.selectedTileCoords;
          tileInteractActive = true;
        }}
      />
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
