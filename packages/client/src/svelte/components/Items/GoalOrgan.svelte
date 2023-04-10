<script lang="ts">
  import { blockNumber } from "../../modules/network"
  import type { Entity } from "../../modules/entities"
  import Dialog from "../Dialog/Dialog.svelte"
  import { addToSequencer, WorldFunctions } from "../../modules/actionSequencer"
  import { playSound } from "../../../howler"
  import { staticContent } from "../../modules/staticContent"

  export let itemId: string
  export let item: Entity
  export let isOnMap = false

  let dialogVisible = false

  let info = {
    symbol: "",
    description: "",
  }

  const setInfo = (symbol: string, description: string) => {
    info.symbol = symbol
    info.description = description
  }

  setInfo("$", "Goal")

  function harvest() {
    addToSequencer(WorldFunctions.Harvest)
  }

  const mouseenter = () => {
    playSound("cursor", "ui")
  }

  const click = () => {
    dialogVisible = true
  }

  const icon = $staticContent.organs.find(o => o.label === "goal")?.images[0]
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="organ goal" on:click={click} on:mouseenter={mouseenter}>
  <img src={icon} alt="goal" />
  <div class="count">
    {$blockNumber - parseInt(String(item.goal || ""))}
  </div>
</div>

<Dialog bind:visible={dialogVisible}>
  <div class="description">{info.description}</div>
  <button on:click={harvest}>harvest</button>
</Dialog>

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

    .count {
      position: absolute;
      z-index: 1;
      display: none;
    }

    &:hover .count {
      display: block;
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
