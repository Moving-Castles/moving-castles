<script lang="ts">
  import { t } from "../Dialogue";
  import { playerAbilities } from "../../modules/player";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { staticContent } from "../../modules/staticContent";
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
  const icon = $staticContent.organs.find((o) => o.name === "blank")?.image;
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div use:t={{ enable: !isOnMap }} class="organ blank" on:click={click} on:mouseenter={mouseenter}>
  <img src={icon} alt="move" />

  <div class="dialog">
    <div class="description">{info.description}</div>
    <button on:click={drop}>drop</button>
    {#if $playerAbilities.includes("abilityConsume")}
      <button on:click={consume}>consume</button>
    {/if}
  </div>
</div>

<style lang="scss">
  .organ {
    height: 100%;
    width: 100%;
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

    img {
      width: 100%;
      height: 100%;
    }

    &:hover {
      opacity: 0.9;
    }
  }
</style>
