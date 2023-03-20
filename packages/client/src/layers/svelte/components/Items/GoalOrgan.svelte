<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import tippy from "tippy.js";
  import "tippy.js/dist/tippy.css";
  import { blockNumber } from "../../modules/network";
  import type { Entity } from "../../modules/entities";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { playSound } from "../../../howler";

  export let itemId: string;
  export let item: Entity;
  export let showDialog: boolean;

  let markerEl: HTMLElement;
  let dialogEl: HTMLElement;
  let toolTip: any;

  let info = {
    symbol: "",
    description: "",
  };

  const setInfo = (symbol: string, description: string) => {
    info.symbol = symbol;
    info.description = description;
  };

  setInfo("$", "Goal");

  function drop() {
    addToSequencer("system.Drop", [itemId]);
  }

  function harvest() {
    addToSequencer("system.Harvest");
  }

  const mouseenter = () => {
    playSound("cursor", "ui");
  };

  onMount(async () => {
    if (showDialog) {
      toolTip = tippy(markerEl, {
        content: dialogEl,
        interactive: true,
      });
    }
  });

  onDestroy(() => {
    if (toolTip) {
      toolTip.destroy();
    }
  });
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="organ goal" bind:this={markerEl} on:mouseenter={mouseenter}>
  {info.symbol}
  {$blockNumber - parseInt(item.goal)}
</div>

{#if showDialog}
  <div class="dialog" bind:this={dialogEl}>
    <div class="description">{info.description}</div>
    <button on:click={harvest}>harvest</button>
    <button on:click={drop}>drop</button>
  </div>
{/if}

<style lang="scss">
  .organ {
    height: 100px;
    width: 100px;
    overflow: hidden;
    font-size: 42px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;

    &.goal {
      background-color: #d1de18;
    }

    &:hover {
      opacity: 0.9;
    }
  }
</style>
