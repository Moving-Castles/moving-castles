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
  import { v4 as uuid } from "uuid";

  import { activeActions, processedActions } from "../../modules/actionSequencer";

  let activeAction: Action;
  let processedAction: Action;
  let w: number, h: number, containerWidth: number, zoomScale: number;
  let zoomed = false;
  let grid: GridTile[] = [];

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

  async function centerMapOnPlayer(smooth: boolean = true) {
    await tick();
    let playerEl = document.getElementsByClassName("player")[0];

    if (playerEl && playerEl.parentElement) {
      let playerTileEl = playerEl.parentElement;
      playerTileEl.scrollIntoView({ block: "center", inline: "center", behavior: smooth ? "smooth" : "auto" });
    }
  }

  $: key = uuid();

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
      if (processedAction.systemId.toLowerCase().includes("move")) {
        playSound("walking", "activity");
        centerMapOnPlayer();
        key = uuid();
      }
    }
  }

  $: w - h;
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
  class:void={!($playerBaseEntity && $playerBaseEntity.position)}
  class:zoomed
>
  <div class="map-container" class:zoomed bind:clientWidth={containerWidth}>
    <!-- GRID -->
    {#each grid as tile (`${tile.coordinates.x}-${tile.coordinates.y}-${key}`)}
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
    }

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
      width: var(--ww);
      height: var(--ww);
    }
  }
</style>
