<script lang="ts">
  import { quadOut } from "svelte/easing";
  import { scale } from "svelte/transition";
  import { Activity } from "../../modules/actionUpdater";
  import type { Entity } from "../../modules/entities";
  import { playerCore } from "../../modules/player";
  import { ItemType } from "./types";
  import { dragging } from "./index";
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
  export let baseEntityId: string;
  export let showDialog = true;
  export let isOnMap = false;
  export let dropAllowed = false;
  export let type: ItemType;

  $: console.log("same owner ", baseEntityId === $playerCore.carriedBy);

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

  function dragStart(event: DragEvent) {
    event.dataTransfer.clearData();
    event.dataTransfer.setData("text/plain", itemId);
    dragging.set(itemId);
  }
</script>

<div
  class="item"
  class:dropAllowed
  class:map={isOnMap}
  class:active={type !== ItemType.LootBox && item.activity && item.activity !== Activity.Idle}
  draggable={true}
  transition:scale={{ duration: 100, easing: quadOut }}
  on:dragstart={dragStart}
  on:dragenter|preventDefault
  on:dragleave|preventDefault
  on:dragend|preventDefault
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
    <LootBox {itemId} {item} {isOnMap} />
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
      height: 320px;
      width: 320px;
      border-radius: 10px;
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
