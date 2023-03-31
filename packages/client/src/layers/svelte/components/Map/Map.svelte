<script lang="ts">
  import { onMount } from "svelte";
  import { playerCore, playerBaseEntity, multiCore, playerAbilities } from "../../modules/player";
  import { gameConfig } from "../../modules/entities";
  import { panzoom } from "../../modules/map";
  import { playSound } from "../../../howler";

  import Chat from "../Chat/Chat.svelte";
  import Tile from "./Tile.svelte";
  import type { GridTile } from "./index";

  import { Activity } from "../../modules/actionUpdater";

  let w: number, h: number, containerWidth: number, zoomScale: number;
  let zoomed = false;
  let grid: GridTile[] = [];

  function initGrid(unit: number) {
    let grid = [] as GridTile[];
    for (let y = 0; y < unit; y++) {
      for (let x = 0; x < unit; x++) {
        const newGridTile: GridTile = {
          id: `${x}-${y}`,
          coordinates: { x: x, y: y },
        };
        grid = [...grid, newGridTile];
      }
    }
    return grid;
  }

  // @todo: move this function to an external file so if can be used from other components
  async function centerMapOnPlayer(smooth: boolean = true) {
    setTimeout(() => {
      let playerEl = document.getElementsByClassName("player")[0];
      if (playerEl && playerEl.parentElement) {
        let playerTileEl = playerEl.parentElement;
        playerTileEl.scrollIntoView({ block: "center", inline: "center", behavior: smooth ? "smooth" : "auto" });
      }
    }, 300);
  }

  // @todo: only center on the player if it moved
  $: if ($playerBaseEntity.activity === Activity.Idle) {
    centerMapOnPlayer();
  }

  $: zoomScale = Math.min(w, h) / containerWidth;

  const toggleZoom = (e) => {
    if (e.key === "-") {
      zoomed = true;
    }
    if (e.key === "=") {
      zoomed = false;
      centerMapOnPlayer(false);
    }
  };

  onMount(() => {
    grid = initGrid($gameConfig.worldWidth);
    centerMapOnPlayer(false);
    playSound("workSiteRain", "environment", true);
  });
</script>

<svelte:window on:resize={centerMapOnPlayer} on:keypress={toggleZoom} bind:innerWidth={w} bind:innerHeight={h} />

{#if $multiCore && $playerAbilities.includes("abilityChat")}
  <Chat channelId={$playerCore.carriedBy} />
{/if}

<div
  use:panzoom
  class="ui-map"
  style="--zoomscale: {zoomScale}; --ww: {$gameConfig.worldWidth * 400 + 3}px;"
  class:zoomed
>
  <div class="map-container" class:zoomed bind:clientWidth={containerWidth}>
    {#each grid as tile (tile.id)}
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

    &.zoomed {
      position: fixed;
      top: 50%;
      left: 50%;
      width: var(--ww);
      height: var(--ww);
      transform-origin: top left;
      transform: scale(calc(var(--zoomscale) * 0.85)) translate(-50%, -50%);

      .map-container {
        margin: 0;
      }
    }

    .center-map-button {
      position: fixed;
      top: 100px;
      left: 10px;
      z-index: 1000;
    }

    .map-container {
      margin: 400px;
      box-sizing: border-box;
      border: 1px solid white;
      position: relative;
      width: var(--ww);
      height: var(--ww);
    }
  }
</style>
