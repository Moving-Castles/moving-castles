<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import tippy from "tippy.js";
  import "tippy.js/dist/tippy.css";
  import { playerAbilities } from "../../modules/player";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { playSound } from "../../../howler";

  export let itemId: string;
  export let showDialog: boolean;
  export let isOnMap = false;

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

  setInfo("B", "Blank");

  function drop() {
    addToSequencer("system.Drop", [itemId]);
  }

  function consume() {
    addToSequencer("system.Consume", [itemId]);
  }

  const mouseenter = () => {
    playSound("cursor", "ui");
  };

  function pickUp() {
    addToSequencer("system.PickUp", [itemId]);
  }

  const click = () => {
    if (isOnMap) {
      pickUp();
    }
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
<div class="organ blank" bind:this={markerEl} on:click={click} on:mouseenter={mouseenter}>
  {info.symbol}
</div>

{#if showDialog && !isOnMap}
  <div class="dialog" bind:this={dialogEl}>
    <div class="description">{info.description}</div>
    <button on:click={drop}>drop</button>
    {#if $playerAbilities.includes("abilityConsume")}
      <button on:click={consume}>consume</button>
    {/if}
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

    &.blank {
      background-color: rgb(126, 78, 114);
    }

    &:hover {
      opacity: 0.9;
    }
  }
</style>
