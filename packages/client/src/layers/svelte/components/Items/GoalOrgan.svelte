<script lang="ts">
  import { blockNumber } from "../../modules/network";
  import type { Entity } from "../../modules/entities";
  import { t } from "../Dialogue";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { playSound } from "../../../howler";
  import { staticContent } from "../../modules/staticContent";

  export let itemId: string;
  export let item: Entity;
  export let isOnMap = false;

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

  function pickUp() {
    addToSequencer("system.PickUp", [itemId]);
  }

  const click = () => {
    if (isOnMap) {
      pickUp();
    }
  };

  const icon = $staticContent.organs.find((o) => o.label === "goal")?.images[0];
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="organ goal" use:t on:click={click} on:mouseenter={mouseenter}>
  <div class="dialog">
    <div class="description">{info.description}</div>
    <button on:click={harvest}>harvest</button>
    <button on:click={drop}>drop</button>
  </div>
  <img src={icon} alt="goal" />
  {$blockNumber - parseInt(String(item.goal || ""))}
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

    &.goal {
      background-color: #d1de18;
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
