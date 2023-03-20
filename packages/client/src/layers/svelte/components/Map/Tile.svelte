<script lang="ts">
  import { baseEntities, freePortables, resources } from "../../modules/entities";
  import type { Resource } from "../../modules/entities";

  import { createEventDispatcher } from "svelte";
  const dispatch = createEventDispatcher();

  import Item from "./Item.svelte";
  import BaseEntity from "./BaseEntity.svelte";

  export let tile: any;

  let matter = 100;
  let resource: Resource | undefined;

  $: resource = Object.values($resources).find(
    (r) => r.position?.x === tile.coordinates.x && r.position?.y === tile.coordinates.y
  );

  $: matter = resource ? resource.matter : 100;
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
  <div class="matter" class:empty={matter === 0}>{matter}</div>

  <!-- BASE ENTITIES -->
  {#each Object.entries($baseEntities) as [baseEntityId, baseEntity] (baseEntityId)}
    {#if baseEntity.position?.x == tile.coordinates.x && baseEntity.position?.y == tile.coordinates.y}
      <BaseEntity {baseEntityId} {baseEntity} />
    {/if}
  {/each}

  <!-- FREE PORTABLES -->
  {#each Object.entries($freePortables) as [entityId, entity] (entityId)}
    {#if entity.position?.x == tile.coordinates.x && entity.position?.y == tile.coordinates.y}
      <Item itemId={entityId} item={entity} free={true} />
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

    .matter {
      position: absolute;
      top: 10px;
      left: 10px;
      font-size: 10px;

      &.empty {
        color: red;
      }
    }
  }
</style>
