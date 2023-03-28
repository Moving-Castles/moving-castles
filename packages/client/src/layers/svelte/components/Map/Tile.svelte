<script lang="ts">
  import { createEventDispatcher } from "svelte";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { baseEntities, freeItems } from "../../modules/entities";
  import { playerCore, playerAbilities } from "../../modules/player";
  import { chebyshev } from "../../utils/space";
  import { gameConfig } from "../../modules/entities";
  import Item from "../Items/ItemSelector.svelte";
  import BaseEntity from "./BaseEntity.svelte";
  import { t } from "../Dialogue/index";

  import type { GridTile } from "./index";

  export let tile: GridTile;
  export const isAdjacent = chebyshev($baseEntities[$playerCore.carriedBy].position, tile.coordinates) === 1;

  let pointerover = false;
  let pointerdown = false;
  let isPlayer = false;
  let dialogElement: HTMLElement;

  const onPointerEnter = () => (pointerover = true);
  const onPointerLeave = () => (pointerover = false);
  const onPointerDown = () => (pointerdown = true);
  const onPointerUp = () => (pointerdown = false);

  function move() {
    if (isAdjacent && $playerAbilities.includes("abilityMove")) {
      addToSequencer("system.Move", [tile.coordinates]);
    }
  }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="tile"
  class:adjacent={isAdjacent}
  class:canmoveto={$playerAbilities.includes("abilityMove") && isAdjacent}
  on:pointerenter={onPointerEnter}
  on:pointerleave={onPointerLeave}
  on:pointerup={onPointerUp}
  on:pointerdown|self={onPointerDown}
  use:t={isAdjacent && $playerAbilities.includes("abilityMove")}
>
  <div class="dialog">
    Move here?<br /> Energy costs: {$gameConfig.moveCost}
    <button on:click={move}>Yes</button>
  </div>

  <div class="coords">{tile.coordinates.x}:{tile.coordinates.y}</div>

  <!-- BASE ENTITIES -->
  {#each Object.entries($baseEntities) as [baseEntityId, baseEntity] (baseEntityId)}
    {#if baseEntity.position?.x == tile.coordinates.x && baseEntity.position?.y == tile.coordinates.y}
      <BaseEntity {baseEntityId} {baseEntity} />
    {/if}
  {/each}

  <!-- FREE ITEMS -->
  {#each Object.entries($freeItems) as [itemId, item] (itemId)}
    {#if item.position?.x == tile.coordinates.x && item.position?.y == tile.coordinates.y}
      <Item {itemId} {item} isOnMap={true} />
    {/if}
  {/each}
</div>

<style lang="scss">
  .tile {
    width: 400px;
    height: 400px;
    float: left;
    font-size: 8px;
    // border: 1px solid lightgrey;
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
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
      }
    }

    .coords {
      position: absolute;
      top: 10px;
      right: 10px;
    }
  }
</style>
