<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import tippy from "tippy.js";
  import "tippy.js/dist/tippy.css";
  import { addressToColor } from "../../utils/misc";
  import type { Core } from "../../modules/entities";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { playSound } from "../../../howler";
  import { playerAddress } from "../../modules/player";
  import { idToName, idToAvatar } from "../../utils/name";

  export let itemId: string;
  export let item: Core;
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

  setInfo(
    "*",
    itemId === $playerAddress ? idToName(itemId) + " (you)" : idToName(itemId) + ": " + item.energy + " energy"
  );

  function drop() {
    addToSequencer("system.Drop", [itemId]);
  }

  const mouseenter = () => {
    playSound("friendly", "misc");
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
  class="core"
  class:self={itemId === $playerAddress}
  style={"background:" + addressToColor(itemId) + ";"}
  bind:this={markerEl}
  on:mouseenter={mouseenter}
>
  <img class="core-avatar" src={idToAvatar(itemId)} alt="core" />
</div>

{#if showDialog}
  <div class="dialog" bind:this={dialogEl}>
    <div class="description">{info.description}</div>
    <button on:click={drop}>drop</button>
  </div>
{/if}

<style lang="scss">
  .core {
    height: 100px;
    width: 100px;
    overflow: hidden;
    font-size: 42px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;

    &:hover {
      opacity: 0.9;
    }
  }

  .self {
    border: 1px solid white;
  }

  .core-avatar {
    height: 100px;
    width: 100px;
    object-fit: cover;
  }
</style>
