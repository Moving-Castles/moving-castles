<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import tippy from "tippy.js";
  import "tippy.js/dist/tippy.css";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { playSound } from "../../../howler";

  export let itemId: string;
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

  setInfo("E", "Ability: Extract");

  function drop() {
    addToSequencer("system.Drop", [itemId]);
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

<div class="organ extract" bind:this={markerEl} on:mouseenter={mouseenter}>
  {info.symbol}
</div>

{#if showDialog}
  <div class="dialog" bind:this={dialogEl}>
    <div class="description">{info.description}</div>
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

    &.extract {
      background-color: #0000ff;
    }

    &:hover {
      opacity: 0.9;
    }
  }
</style>
