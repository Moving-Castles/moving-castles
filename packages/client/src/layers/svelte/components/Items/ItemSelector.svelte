<script lang="ts">
  import type { Entity } from "../../modules/entities";
  import Core from "./Core.svelte";
  import MoveOrgan from "./MoveOrgan.svelte";
  import ExtractOrgan from "./ExtractOrgan.svelte";
  import ConsumeOrgan from "./ConsumeOrgan.svelte";
  import PlayOrgan from "./PlayOrgan.svelte";
  import BurnOrgan from "./BurnOrgan.svelte";
  import LootBox from "./LootBox.svelte";
  import SubstanceBlock from "./SubstanceBlock.svelte";
  import Untraversable from "./Untraversable.svelte";
  import GoalOrgan from "./GoalOrgan.svelte";

  export let itemId: string;
  export let item: Entity;
  export let showDialog = true;

  enum ItemType {
    Core,
    MoveOrgan,
    ExtractOrgan,
    ConsumeOrgan,
    PlayOrgan,
    BurnOrgan,
    LootBox,
    SubstanceBlock,
    Untraversable,
    GoalOrgan,
  }

  let type: ItemType;

  $: {
    if (item.core) {
      type = ItemType.Core;
    } else if (item.matter) {
      type = ItemType.SubstanceBlock;
    } else if (item.abilityMove) {
      type = ItemType.MoveOrgan;
    } else if (item.abilityConsume) {
      type = ItemType.ConsumeOrgan;
    } else if (item.abilityExtract) {
      type = ItemType.ExtractOrgan;
    } else if (item.abilityPlay) {
      type = ItemType.PlayOrgan;
    } else if (item.abilityBurn) {
      type = ItemType.BurnOrgan;
    } else if (item.untraversable) {
      type = ItemType.Untraversable;
    } else if (item.loot) {
      type = ItemType.LootBox;
    } else if (item.goal) {
      type = ItemType.GoalOrgan;
    }
  }
</script>

<div class="item">
  {#if type === ItemType.Core}
    <Core {itemId} {item} {showDialog} />
  {:else if type === ItemType.MoveOrgan}
    <MoveOrgan {itemId} {showDialog} />
  {:else if type === ItemType.ExtractOrgan}
    <ExtractOrgan {itemId} {showDialog} />
  {:else if type === ItemType.ConsumeOrgan}
    <ConsumeOrgan {itemId} {showDialog} />
  {:else if type === ItemType.PlayOrgan}
    <PlayOrgan {itemId} {showDialog} />
  {:else if type === ItemType.BurnOrgan}
    <BurnOrgan {itemId} {showDialog} />
  {:else if type === ItemType.LootBox}
    <LootBox {itemId} />
  {:else if type === ItemType.SubstanceBlock}
    <SubstanceBlock {itemId} {item} {showDialog} />
  {:else if type === ItemType.Untraversable}
    <Untraversable {itemId} {showDialog} />
  {:else if type === ItemType.GoalOrgan}
    <GoalOrgan {itemId} {item} {showDialog} />
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
  }
</style>
