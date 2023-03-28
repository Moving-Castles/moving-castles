<script lang="ts">
  import { t } from "../Dialogue";
  import { playerAbilities } from "../../modules/player";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { playSound } from "../../../howler";

  export let itemId: string;
  export let showDialog: boolean;
  export let isOnMap = false;

  let info = {
    symbol: "",
    description: "",
  };

  const setInfo = (symbol: string, description: string) => {
    info.symbol = symbol;
    info.description = description;
  };

  setInfo("C", "Ability: Consume");

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
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div use:t={!isOnMap} class="organ consume" on:click={click} on:mouseenter={mouseenter}>
  <div class="dialog">
    <div class="description">{info.description}</div>
    <button on:click={drop}>drop</button>
    {#if $playerAbilities.includes("abilityConsume")}
      <button on:click={consume}>consume</button>
    {/if}
  </div>

  {info.symbol}
</div>

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

    &.consume {
      background-color: #00ff00;
    }

    &:hover {
      opacity: 0.9;
    }
  }
</style>
