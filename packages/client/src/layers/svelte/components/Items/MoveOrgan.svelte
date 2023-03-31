<script lang="ts">
  import { playerAbilities } from "../../modules/player";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { staticContent } from "../../modules/staticContent";
  import { playSound } from "../../../howler";
  import { pickUp, consume } from "../../modules/player/actions";
  import Dialog from "../Dialog/Dialog.svelte";

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

  setInfo("M", "Ability: Move");

  const click = () => {
    if (isOnMap) {
      pickUp(itemId);
    }
  };

  const mouseenter = () => {
    playSound("cursor", "ui");
  };

  const icon = $staticContent.organs.find((o) => o.label === "move")?.images[0];
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="organ move" on:click={click} on:mouseenter={mouseenter}>
  <img src={icon} alt="move" />
</div>

<Dialog bind:visible={showDialog}>
  <div class="description">{info.description}</div>
  {#if $playerAbilities.includes("abilityConsume")}
    <button on:click={() => consume(itemId)}>consume</button>
  {/if}
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

    &.move {
      background-color: #8ee096;
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
