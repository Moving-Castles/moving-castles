<script lang="ts">
  import type { GridTile } from "./index";

  import { addToSequencer } from "../../modules/actionSequencer";
  import { baseEntities, freeItems } from "../../modules/entities";
  import { playerCore, playerAbilities } from "../../modules/player";
  import { chebyshev, isAdjacent } from "../../utils/space";
  import { gameConfig } from "../../modules/entities";
  import Item from "../Items/ItemSelector.svelte";
  import BaseEntity from "./BaseEntity.svelte";
  import { t } from "../Dialogue/index";

  export let tile: GridTile;

  let tileElement: HTMLElement;
  let tileEntities: [string, BaseEntity][];

  $: adjacent = isAdjacent($baseEntities[$playerCore.carriedBy].position, tile.coordinates);

  $: {
    tileEntities = Object.entries($baseEntities).filter(
      ([key, baseEntity]) =>
        baseEntity.position?.x == tile.coordinates.x && baseEntity.position?.y == tile.coordinates.y
    );
  }

  $: tileFreeItems = Object.entries($freeItems).filter(
    ([id, item]) => item.position?.x == tile.coordinates.x && item.position?.y == tile.coordinates.y
  );

  $: totalItemsAndEntities = tileEntities.length + tileFreeItems.length;

  function move() {
    if (adjacent && $playerAbilities.includes("abilityMove")) {
      addToSequencer("system.Move", [tile.coordinates]);
    }

    hide();
  }

  function hide() {
    tileElement._tippy.hide();
  }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="tile"
  class:adjacent
  class:canmoveto={$playerAbilities.includes("abilityMove") && adjacent}
  bind:this={tileElement}
  use:t={adjacent && $playerAbilities.includes("abilityMove")}
>
  <div class="dialog">
    Destination x:{tile.coordinates.x}, y:{tile.coordinates.y}<br /> Costs: {$gameConfig.moveCost} energy
    <br />
    <button on:click={move}>move</button>
    <button on:click={hide}>abort</button>
  </div>

  <div class="coords">{tile.coordinates.x}:{tile.coordinates.y}</div>

  <div class="tile-items item-count-{totalItemsAndEntities}">
    <!-- BASE ENTITIES -->
    {#each tileEntities as [baseEntityId, baseEntity], index (baseEntityId + index)}
      <BaseEntity {baseEntityId} {baseEntity} />
    {/each}

    <!-- FREE ITEMS -->
    {#each tileFreeItems as [itemId, item] (itemId)}
      <Item {itemId} {item} isOnMap={true} />
    {/each}
  </div>
</div>

<style lang="scss">
  .tile {
    width: 400px;
    height: 400px;
    float: left;
    font-size: 8px;
    // border: 1px solid lightgrey;
    position: relative;
    background-size: contain;
    background-image: url("/img/map2.png");

    &:hover {
      background-color: rgb(60, 60, 60);
    }

    &.canmoveto {
      &:hover::after {
        content: "";
        position: absolute;
        inset: 0;
        width: 100%;
        height: 100%;
        background-color: #fff;
        mix-blend-mode: overlay;
        pointer-events: none;
      }
    }

    .coords {
      position: absolute;
      top: 10px;
      right: 10px;
    }
  }

  // Grid system
  .tile-items {
    position: absolute;
    inset: 0;
    display: grid;
    justify-items: center;
    align-items: center;

    &.item-count-1 {
      // One item
      grid-template-columns: 1fr;
    }

    &.item-count-2 {
      grid-template-columns: 1fr 1fr;

      :global(.grid-item) {
        width: 200px;
      }
    }

    &.item-count-3 {
      grid-template-columns: repeat(3, calc(400px / 3));
      grid-template-rows: repeat(3, calc(400px / 3));

      :global(.grid-item) {
        width: 100%;
        height: 100%;
      }

      grid-template-areas:
        ". . b"
        ". a ."
        "c . .";

      :global(.grid-item:nth-child(1)) {
        grid-area: a;
      }

      :global(.grid-item:nth-child(2)) {
        grid-area: b;
      }

      :global(.grid-item:nth-child(3)) {
        grid-area: c;
      }
    }

    &.item-count-4 {
      grid-template-columns: 200px 200px;
      grid-template-rows: 200px 200px;

      :global(.grid-item) {
        width: 200px;
        height: 200px;
      }
    }

    &.item-count-5,
    &.item-count-6,
    &.item-count-7,
    &.item-count-8,
    &.item-count-9 {
      grid-template-columns: repeat(3, calc(400px / 3));
      grid-template-rows: repeat(3, calc(400px / 3));

      :global(.grid-item) {
        width: 100%;
        height: 100%;
      }

      grid-template-areas:
        "b . c"
        ". a ."
        "d . e";

      :global(.grid-item:nth-child(1)) {
        grid-area: a;
      }
      :global(.grid-item:nth-child(2)) {
        grid-area: b;
      }
      :global(.grid-item:nth-child(3)) {
        grid-area: c;
      }
      :global(.grid-item:nth-child(4)) {
        grid-area: d;
      }
      :global(.grid-item:nth-child(5)) {
        grid-area: e;
      }
    }
  }
</style>
