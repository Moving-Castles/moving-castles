<script lang="ts">
  import { quadOut } from "svelte/easing";
  import { scale } from "svelte/transition";
  import { Activity } from "../../modules/actionUpdater";
  import type { Entity } from "../../modules/entities";
  import { ItemType } from "./types";
  // ...
  import Core from "./Core.svelte";
  import MoveOrgan from "./MoveOrgan.svelte";
  import ConsumeOrgan from "./ConsumeOrgan.svelte";
  import PlayOrgan from "./PlayOrgan.svelte";
  import ChatOrgan from "./ChatOrgan.svelte";
  import LootBox from "./LootBox.svelte";
  import Untraversable from "./Untraversable.svelte";
  import GoalOrgan from "./GoalOrgan.svelte";
  import BlankOrgan from "./BlankOrgan.svelte";

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
    } else if (item.abilityChat) {
      type = ItemType.ChatOrgan;
    } else if (item.untraversable) {
      type = ItemType.Untraversable;
    } else if (item.loot) {
      type = ItemType.LootBox;
    } else if (item.goal) {
      type = ItemType.GoalOrgan;
    } else {
      type = ItemType.BlankOrgan;
    }
  }
</script>

<div
  class="item"
  class:map={isOnMap}
  class:active={type !== ItemType.LootBox && item.activity && item.activity !== Activity.Idle}
  transition:scale={{ duration: 100, easing: quadOut }}
>
  {#if type === ItemType.Core}
    <Core {itemId} {item} {showDialog} />
  {:else if type === ItemType.MoveOrgan}
    <MoveOrgan {itemId} {showDialog} {isOnMap} />
  {:else if type === ItemType.ConsumeOrgan}
    <ConsumeOrgan {itemId} {showDialog} {isOnMap} />
  {:else if type === ItemType.PlayOrgan}
    <PlayOrgan {itemId} {showDialog} {isOnMap} />
  {:else if type === ItemType.ChatOrgan}
    <ChatOrgan {itemId} {showDialog} {isOnMap} />
  {:else if type === ItemType.LootBox}
    <LootBox {itemId} {isOnMap} />
  {:else if type === ItemType.Untraversable}
    <Untraversable {itemId} {showDialog} {isOnMap} />
  {:else if type === ItemType.GoalOrgan}
    <GoalOrgan {itemId} {item} {showDialog} {isOnMap} />
  {:else}
    <BlankOrgan {itemId} {showDialog} {isOnMap} />
  {/if}
</div>

<style lang="scss">
  .item {
    height: 140px;
    width: 140px;
    overflow: hidden;
    margin-right: 5px;
    margin-bottom: 5px;
    font-size: 42px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;

    &.active {
      animation: color-change 0.2s infinite;
    }

    &.map {
      font-size: 32px;
      height: 200px;
      width: 200px;
    }
  }

  @keyframes color-change {
    0% {
      filter: invert(0);
    }

    100% {
      filter: invert(1);
    }
  }
</style>
