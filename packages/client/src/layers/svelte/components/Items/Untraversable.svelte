<script lang="ts">
  import { t } from "../Dialogue";
  import { pickUp } from "../../modules/player/actions";
  import { playSound } from "../../../howler";

  export let itemId: string;
  export let isOnMap = false;

  let info = {
    symbol: "",
    description: "",
  };

  const setInfo = (symbol: string, description: string) => {
    info.symbol = symbol;
    info.description = description;
  };

  setInfo("X", "Untraversable");

  const click = () => {
    if (isOnMap) {
      pickUp(itemId);
    }
  };

  const mouseenter = () => {
    playSound("cursor", "ui");
  };
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div use:t class="untraversable" on:click={click} on:mouseenter={mouseenter}>
  {info.symbol}

  <div class="dialog">
    <div class="description">{info.description}</div>
  </div>
</div>

<style lang="scss">
  .untraversable {
    height: 100%;
    width: 100%;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;
    background-color: #8ee096;

    &:hover {
      opacity: 0.9;
    }
  }
</style>
