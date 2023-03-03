<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import tippy from "tippy.js";
  import "tippy.js/dist/tippy.css";
  import { addressToColor } from "../../utils/ui";
  import { blockNumber } from "../../modules/network";
  import { playerAddress, playerAbilities, playerCore } from "../../modules/player";
  import type { Entity } from "../../modules/entities";
  import { Activity } from "../../modules/entities";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { idToName, idToAvatar } from "../../utils/name";

  export let itemId: string;
  export let item: Entity;
  export let targetBaseEntityId: string;

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

  if (item.core) {
    setInfo(
      "*",
      itemId === $playerAddress ? idToName(itemId) + " (you)" : idToName(itemId) + ": " + item.energy + " energy"
    );
  } else if (item.matter) {
    setInfo("S", "Substance block");
  } else if (item.abilityMove) {
    setInfo("M", "Ability: Move");
  } else if (item.abilityConsume) {
    setInfo("C", "Ability: Consume");
  } else if (item.abilityExtract) {
    setInfo("E", "Ability: Extract");
  } else if (item.abilityPlay) {
    setInfo("P", "Ability: Play");
  } else if (item.abilityBurn) {
    setInfo("B", "Ability: Burn");
  } else if (item.untraversable) {
    setInfo("X", "Untraversable");
  } else if (item.loot) {
    setInfo("?", "Loot box");
  } else if (item.goal) {
    setInfo("🎏", "Goal");
  }

  function drop() {
    addToSequencer("system.Drop", [itemId]);
  }

  function consume() {
    addToSequencer("system.Consume", [itemId]);
  }

  function burn() {
    addToSequencer("system.Burn", [itemId]);
  }

  function open() {
    addToSequencer("system.Open", [itemId]);
  }

  function play() {
    addToSequencer("system.Play");
  }

  onMount(async () => {
    if (!targetBaseEntityId) {
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
  class="item"
  class:self={itemId === $playerAddress}
  class:burning={item.burnBlock > $blockNumber}
  class:burnt={item.burnBlock <= $blockNumber}
  bind:this={markerEl}
  style={"background:" + addressToColor(itemId) + ";"}
  on:click={() => {
    if (targetBaseEntityId) {
      addToSequencer("system.Transfer", [itemId, targetBaseEntityId]);
      // $network.api.transfer(itemId, targetBaseEntityId);
    }
  }}
>
  {#if item.matter}
    {#if item.burnBlock}
      {#if item.burnBlock > $blockNumber}
        {item.burnBlock - $blockNumber}
      {:else}
        ╳
      {/if}
    {:else}
      {item.matter}
    {/if}
  {:else if item.core}
    <img class="core-avatar" src={idToAvatar(itemId)} alt="core" />
  {:else if item.goal}
    {info.symbol}
    {$blockNumber - parseInt(item.goal)}
  {:else}
    {info.symbol}
  {/if}
</div>

{#if !targetBaseEntityId}
  <div class="dialog" bind:this={dialogEl}>
    <div class="description">{info.description}</div>

    {#if item.burnBlock}
      {#if item.burnBlock > $blockNumber}
        <div class="description">BURNING🔥🔥🔥</div>
      {:else}
        <div class="description">ASHES</div>
      {/if}
    {/if}

    {#if item.abilityPlay}
      <button on:click={play}>{$playerCore.commit === Activity.Play ? "STOP" : "play"}</button>
    {/if}

    {#if item.loot}
      <button on:click={open}>Open</button>
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

  .self {
    border: 1px solid white;
  }

  .core-avatar {
    height: 100px;
    width: 100px;
    object-fit: cover;
  }

  .item:hover {
    opacity: 0.9;
  }

  .dialog {
    padding: 10px;
    text-align: center;
  }

  .description {
    font-weight: bold;
    margin-bottom: 10px;
  }

  /* Define the keyframes */
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

  .item.burning {
    animation: color-change 2s ease-in-out infinite;
  }

  .item.burnt {
    background: rgb(34, 34, 34) !important;
  }
</style>
