<script lang="ts">
  import { entities, baseEntities } from "../../modules/entities";
  import type { Entity } from "../../modules/entities";
  import { playerCore } from "../../modules/player";
  import Item from "../Items/ItemSelector.svelte";
  import EmptySlot from "./EmptySlot.svelte";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { dragging } from "../Items";

  export let baseEntityId: string;
  export let showCapacity = false;
  export let showEmptySlots = false;
  export let showCores = true;
  export let draggingOver = false;

  $: isPlayer = baseEntityId === $playerCore.carriedBy;

  let inventoryItems: [string, Entity][] = [];
  $: inventoryItems = Object.entries($entities).filter(([itemId, item]) => item.carriedBy === baseEntityId);

  let emptySlotNumber = 0;
  $: emptySlotNumber = $baseEntities[baseEntityId]
    ? $baseEntities[baseEntityId].carryingCapacity - inventoryItems.length
    : 0;

  const onDrop = (event: any) => {
    const item = event.detail.dataTransfer.getData("text/plain");
    // Move this item into the current inventory
    addToSequencer("system.Transfer", [item, baseEntityId]);

    draggingOver = false;
  };
</script>

{#if showCapacity}
  <div class="cc">
    Inventory: {inventoryItems.length}/{$baseEntities[baseEntityId] ? $baseEntities[baseEntityId].carryingCapacity : 0}
  </div>
{/if}

<div class="inventory" class:draggingOver>
  {#each inventoryItems as [itemId, item] (itemId)}
    {#if item.core && !showCores}
      <span />
    {:else}
      <Item {baseEntityId} {itemId} {item} />
    {/if}
  {/each}
  {#if showEmptySlots}
    {#each Array(emptySlotNumber) as _, i (i)}
      <EmptySlot dropAllowed={!isPlayer && !inventoryItems.map((i) => i[0]).includes($dragging)} on:drop={onDrop} />
    {/each}
  {/if}
</div>

<style lang="scss">
  .inventory {
    display: grid;
    grid-template-columns: repeat(3, 140px);
    grid-template-rows: repeat(4, 140px);
    gap: 6px;

    &.draggingOver {
      &::after {
        // pointer-events: none;
        // content: "";
        // position: absolute;
        // inset: 0;
        // background: rgba(0, 0, 0, 0.5);
        // z-index: 10;
      }
    }
  }

  .inventory-item {
    height: 50px;
    width: 50px;
    overflow: hidden;
    margin-right: 5px;
    margin-bottom: 5px;
  }

  .cc {
    margin-bottom: 10px;
  }
</style>
