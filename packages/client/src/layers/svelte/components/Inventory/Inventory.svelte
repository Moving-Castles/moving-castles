<script lang="ts">
  import { entities, baseEntities } from "../../modules/entities";
  import type { Entity } from "../../modules/entities";
  import Item from "../Items/ItemSelector.svelte";
  import EmptySlot from "./EmptySlot.svelte";

  export let baseEntityId: string;
  export let targetBaseEntityId = "";
  export let showCapacity = false;
  export let showEmptySlots = false;
  export let showCores = true;

  let inventoryItems: [string, Entity][] = [];
  $: inventoryItems = Object.entries($entities).filter(([itemId, item]) => item.carriedBy === baseEntityId);

  let emptySlotNumber = 0;
  $: emptySlotNumber = $baseEntities[baseEntityId]
    ? $baseEntities[baseEntityId].carryingCapacity - inventoryItems.length
    : 0;
</script>

{#if showCapacity}
  <div class="cc">
    Inventory: {inventoryItems.length}/{$baseEntities[baseEntityId] ? $baseEntities[baseEntityId].carryingCapacity : 0}
  </div>
{/if}

<div class="inventory">
  {#each inventoryItems as [itemId, item] (itemId)}
    {#if item.core && !showCores}
      <span />
    {:else}
      <Item {itemId} {item} />
    {/if}
  {/each}
  {#if showEmptySlots}
    {#each Array(emptySlotNumber) as _, i (i)}
      <EmptySlot />
    {/each}
  {/if}
</div>

<style lang="scss">
  .inventory {
    display: flex;
    flex-wrap: wrap;
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
