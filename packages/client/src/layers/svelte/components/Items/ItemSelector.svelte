<script lang="ts">
  import type { Entity } from "../../modules/entities";
  import { ItemType } from "./types";
  import Core from "./Core.svelte";
  import MoveOrgan from "./MoveOrgan.svelte";
  import ConsumeOrgan from "./ConsumeOrgan.svelte";
  import PlayOrgan from "./PlayOrgan.svelte";
  import LootBox from "./LootBox.svelte";
  import Untraversable from "./Untraversable.svelte";
  import GoalOrgan from "./GoalOrgan.svelte";

  export let itemId: string;
  export let item: Entity;
  export let showDialog = true;
  export let isOnMap = false;

  let type: ItemType;

  $: {
    if (item.core) {
      type = ItemType.Core;
    } else if (item.abilityMove) {
      type = ItemType.MoveOrgan;
    } else if (item.abilityConsume) {
      type = ItemType.ConsumeOrgan;
    } else if (item.abilityPlay) {
      type = ItemType.PlayOrgan;
    } else if (item.untraversable) {
      type = ItemType.Untraversable;
    } else if (item.loot) {
      type = ItemType.LootBox;
    } else if (item.goal) {
      type = ItemType.GoalOrgan;
    }
  }
</script>

<div class="item" class:map={isOnMap}>
  {#if type === ItemType.Core}
    <Core {itemId} {item} {showDialog} />
  {:else if type === ItemType.MoveOrgan}
    <MoveOrgan {itemId} {showDialog} {isOnMap} />
  {:else if type === ItemType.ConsumeOrgan}
    <ConsumeOrgan {itemId} {showDialog} {isOnMap} />
  {:else if type === ItemType.PlayOrgan}
    <PlayOrgan {itemId} {showDialog} {isOnMap} />
  {:else if type === ItemType.LootBox}
    <LootBox {itemId} {isOnMap} />
  {:else if type === ItemType.Untraversable}
    <Untraversable {itemId} {showDialog} {isOnMap} />
  {:else if type === ItemType.GoalOrgan}
    <GoalOrgan {itemId} {item} {showDialog} {isOnMap} />
  {/if}
</div>

<style lang="scss">
  .item {
    height: 100px;
    width: 100px;
    overflow: hidden;
    margin-right: 5px;
    margin-bottom: 5px;
    font-size: 42px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;

    &.map {
      font-size: 12px;
      height: 40px;
      width: 40px;
    }
  }
</style>
