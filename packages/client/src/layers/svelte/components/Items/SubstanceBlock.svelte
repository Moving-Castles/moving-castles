<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import tippy from "tippy.js";
  import "tippy.js/dist/tippy.css";
  import { blockNumber } from "../../modules/network";
  import { playerAbilities } from "../../modules/player";
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

  setInfo("S", "Substance block");

  function drop() {
    addToSequencer("system.Drop", [itemId]);
  }

  function consume() {
    addToSequencer("system.Consume", [itemId]);
  }

  function burn() {
    addToSequencer("system.Burn", [itemId]);
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
<div
  class="substance-block"
  bind:this={markerEl}
  class:burning={item.burnBlock > $blockNumber}
  class:burnt={item.burnBlock <= $blockNumber}
  on:mouseenter={mouseenter}
>
  {#if item.burnBlock}
    {#if item.burnBlock > $blockNumber}
      {item.burnBlock - $blockNumber}
    {:else}
      ╳
    {/if}
  {:else}
    {item.matter}
  {/if}
</div>

{#if showDialog}
  <div class="dialog" bind:this={dialogEl}>
    <div class="description">{info.description}</div>
    {#if item.burnBlock}
      {#if item.burnBlock > $blockNumber}
        <div class="description">BURNING🔥🔥🔥</div>
      {:else}
        <div class="description">ASHES</div>
      {/if}
    {/if}

    {#if item.matter}
      {#if !item.burnBlock}
        {#if $playerAbilities.includes("abilityBurn")}
          <button on:click={burn}>burn</button>
        {/if}
        {#if $playerAbilities.includes("abilityConsume")}
          <button on:click={consume}>consume</button>
        {/if}
      {/if}
    {/if}

    <button on:click={drop}>drop</button>
  </div>
{/if}

<style lang="scss">
  .substance-block {
    height: 100px;
    width: 100px;
    overflow: hidden;
    font-size: 42px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;
    background-color: #c28ee0;

    &.burning {
      animation: color-change 2s ease-in-out infinite;
    }

    &.burnt {
      background: rgb(34, 34, 34) !important;
    }

    &:hover {
      opacity: 0.9;
    }
  }

  .dialog {
    padding: 10px;
    text-align: center;
  }

  .description {
    font-weight: bold;
    margin-bottom: 10px;
  }

  @keyframes color-change {
    0% {
      background: red;
    }
    50% {
      background: orangered;
    }
    100% {
      background: red;
    }
  }
</style>
