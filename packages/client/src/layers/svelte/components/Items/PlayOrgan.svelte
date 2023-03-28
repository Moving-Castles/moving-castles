<script lang="ts">
  import { t } from "../Dialogue";
  import { playerAbilities, playerCore } from "../../modules/player";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { playSound } from "../../../howler";
  import { Activity } from "../../modules/actionUpdater";

  export let isOnMap = false;
  export let itemId: string;

  let markerEl: HTMLElement;
  let dialogEl: HTMLElement;

  let info = {
    symbol: "",
    description: "",
  };

  const setInfo = (symbol: string, description: string) => {
    info.symbol = symbol;
    info.description = description;
  };

  setInfo("P", "Ability: Play");

  function drop() {
    addToSequencer("system.Drop", [itemId]);
  }

  function play() {
    addToSequencer("system.Play");
  }

  function consume() {
    addToSequencer("system.Consume", [itemId]);
  }

  function pickUp() {
    addToSequencer("system.PickUp", [itemId]);
  }

  const click = () => {
    if (isOnMap) {
      pickUp();
    }
  };

  const mouseenter = () => {
    playSound("cursor", "ui");
  };
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div use:t={isOnMap} class="organ play" bind:this={markerEl} on:click={click} on:mouseenter={mouseenter}>
  {info.symbol}
  <div class="dialog" bind:this={dialogEl}>
    <div class="description">{info.description}</div>
    <button on:click={play}>{$playerCore.commit === Activity.Play ? "STOP" : "play"}</button>
    {#if $playerAbilities.includes("abilityConsume")}
      <button on:click={consume}>consume</button>
    {/if}
    <button on:click={drop}>drop</button>
  </div>
</div>

<style lang="scss">
  .organ {
    height: 100%;
    width: 100%;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;

    &.play {
      background-color: #8ee096;
    }

    &:hover {
      opacity: 0.9;
    }
  }
</style>
