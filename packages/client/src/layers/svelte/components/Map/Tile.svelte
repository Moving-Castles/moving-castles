<script lang="ts">
  import { baseEntities, freeItems } from "../../modules/entities";
  import Item from "../Items/ItemSelector.svelte";
  import BaseEntity from "./BaseEntity.svelte";

  import { createEventDispatcher } from "svelte";
  const dispatch = createEventDispatcher();

  export let tile: any;
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="tile"
  on:click={(e) => {
    if (e.target?.classList.contains("tile")) {
      dispatch("interact", { selectedTileCoords: tile.coordinates });
    }
  }}
>
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
      <Item {itemId} {item} />
    {/if}
  {/each}
</div>

<style lang="scss">
  .tile {
    width: 300px;
    height: 300px;
    float: left;
    font-size: 8px;
    border: 1px solid lightgrey;
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    background-size: contain;

    &:hover {
      background-color: rgb(60, 60, 60);
    }

    .coords {
      position: absolute;
      top: 10px;
      right: 10px;
    }
  }
</style>
